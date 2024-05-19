#!/bin/ksh



MODEX="KO"

function getValueofGv {

	if [[ -z $2 ]] ; then
		echo "Errore , bisogna utilizzare $0 <xml-file> <GVname>";
		exit;
	fi

	linenumber=`grep -n "<name>[a-zA-Z/_-]*$1[a-zA-Z/_-]*</name>" $2 | awk -F":" '{print $1}'`

	for i in $linenumber ; do
		
		#tail +44 *xml | head -1 
		i=$(($i + 1));
		VALUE=`tail +$i $2 | head -1 | cut -f2 -d">" | cut -f1 -d"<"`
		echo $VALUE
	done;


}




function modGv {


	if [[ -z $2 ]] ; then
		echo "Errore , bisogna utilizzare $0 <xml-file> <GVname> <new-value>";
		exit;
	fi

	read ANS?"Vuoi modificare la GV ? (y/n) : "	

	if [[ $ANS = "n" || $ANS = "N" ]] ; then
        	echo "La modifica non sarà effettuta";
		exit;
	fi;


	read NEWVALUE?"Inserisci il valore da sostituire : ";
	
	if [[ -z $NEWVALUE ]] ; then
		echo "Nessun valore inserito, esco dallo script";
		exit;
	fi

	TMPFILEXML="$1_modgv_`date +%d%m%Y_%H%M%S`"

	numerolinea=`grep -n "<name>[a-zA-Z/_-]*$2[a-zA-Z/_-]*</name>" $1 | awk -F":" '{print $1}'`

	head -n $numerolinea $1 > $TMPFILEXML;
	echo "            <value>$NEWVALUE</value>" >> $TMPFILEXML;
	numerolinea=$(($numerolinea+2))
	tail +$numerolinea $1 >> $TMPFILEXML;

	MODEX="OK"


}

function grepGV {
        if [[ -z $2 ]] ; then
                echo "Errore , bisogna utilizzare grepGV <xml-file> <GVname>"
                exit;
        fi


        GV_FOUND=`grep -ic "<name>[a-zA-Z/_-]*$1[a-zA-Z/_-]*</name>" $2`
	
	if [[ $GV_FOUND -eq 0 ]] ; then
		echo;
		echo "\tNessuna corrispondenza trovata per la GV $1 in $2";
		echo;
		exit;
	fi;

	if [[ $GV_FOUND -eq 1 ]] ; then
		LINEFOUND=`grep -i "<name>[a-zA-Z/_-]*$1[a-zA-Z/_-]*</name>" $2`
		echo;
		echo "Trovata la seguente corrispondenza per $1";
		GVNAME=`echo $LINEFOUND | cut -f2 -d">" | cut -f1 -d"<"`;
		echo "\t$GVNAME\t`getValueofGv $GVNAME $2`";
		modGv $2 $1
		echo;
	fi;

	if [[ $GV_FOUND -gt 1 ]] ; then
		LINEFOUND=`grep -i "<name>[a-zA-Z/_-]*$1[a-zA-Z/_-]*</name>" $2`
		echo;
		echo "Trovate più corrispondenze per $1\n";
		for i in $LINEFOUND ; do
			GVNAME=`echo $i | cut -f2 -d">" | cut -f1 -d"<"`;
			echo "\t$GVNAME\t`getValueofGv $GVNAME $2`";
		done;
		echo "\nSpecificare una sola variabile\n";
	fi;



}

if [[ -z $2 ]] ; then
	echo;
	echo Usage "\t" `basename $0` "<xml-file> <GV-name>";
	echo;
	exit;
fi


grepGV $2 $1


if [[ $MODEX = "OK" ]] ; then
	read DIFF?"La modifica è stata effettuata , vuoi fare la diff tra $1 e $TMPFILEXML ? (y/n) : ";
	if [[ $DIFF = "Y" || $DIFF = "y" ]] ; then
		echo "\n";
		diff $1 $TMPFILEXML
		echo "mv $TMPXMLFILE $1\n"
		mv $TMPFILEXML $1	
        fi;
fi;
