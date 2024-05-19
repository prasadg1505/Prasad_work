#!/bin/ksh

# Script per eseguire start di piu engine con visualizzazione dei log
# Autore: Simone Esposito


stty sane


TIMESTAMP_RUN=$(date "+%Y-%m-%d_%H_%M_%S")


# Per produzione va modificato questo array 
MACCHINE[0]="crmsas52;/sbTibcoEsbdC/products/tibcobw/tra/domain/ESBDC/application/logs"
MACCHINE[1]="crmsas56;/sbTibcoEsbdE/products/tibcobw/tra/domain/ESBDC/application/logs"


# custom
DEPLOY_LIST=provalista
LIST_START=list_dep


# modificare questi path con quelli di produzione
# SCRDIR è il path dove lo script loggerà
# LOGFILE_APP è il nome del file relativo al log dello script
# ENGINE_LOG è il log relativo allo start del singolo bwengine (è il log di appManage)
SCRDIR=/sbTibco/tibadmin/adm_script/scripts/log
LOGFILE_APP=$SCRDIR/runtail_bwengine_$TIMESTAMP_RUN.log
ENGINE_LOG=$SCRDIR/runtail_bwengine_$TIMESTAMP_RUN


# variabili relative all'admin tibco al dominio e al path dell'AppManage
DOMAIN_TIBCO=ESBDC
USER_ADMIN_TIBCO=admin
PASS_ADMIN_TIBCO=admin
APPMANAGE_BIN=/sbTibcoEsbdC/products/tibcobw/tra/5.5/bin/AppManage


function log_ok {
	timestamp_log=$(date "+%d/%m/%Y %H:%M:%S")
	echo [$timestamp_log] OK: $@ >> $LOGFILE_APP
}

function log_err {
	timestamp_log=$(date "+%d/%m/%Y %H:%M:%S")
	echo [$timestamp_log] ERR: $@ >> $LOGFILE_APP
}

function log_info {
        timestamp_log=$(date "+%d/%m/%Y %H:%M:%S")
        echo [$timestamp_log] INFO: $@ >> $LOGFILE_APP
}


function startLog {

	echo "#########################################################";
	echo "#\t\t\t\t\t\t\t#";
	echo "# Deploy bwengine con tail\t\t\t\t#";
	echo "# Pacchetti da deployare \t\t\t\t#";
	echo "# Start time: $(date "+%d/%m/%Y %H:%M:%S")\t\t\t#" 
	echo "#\t\t\t\t\t\t\t#";
	for i in $(cat $DEPLOY_LIST) ; do echo "# $i\t\t\t\t\t\t#" ; done
	echo "#\t\t\t\t\t\t\t#";
	echo "#########################################################";

}


function gestisci_trap {

        ANS=N
	if [[ $TAILLOG == 0 ]] ; then

        	read ANS?"Vuoi uscire dallo script ? (Y/N) [default=N] : "
		
        	if [[ $ANS = "Y" || $ANS = "y" ]] ; then
			log_err Si è scelto di terminare lo script
			exit;
		fi;
	fi
}



function getInfo {

	if [[ -z $1 ]] ; then
		echo "Nessun pacchetto specificato\n";
		return;
	fi

	RETURN=`grep "[A-Za-z0-9]*;$1;[A-Za-z0-9]*" $LIST_START | head -1`

	log_info Trovato $RETURN nel file $LIST_START

	echo $RETURN
}


function getPathLog {


	if [[ -z $1 ]] ; then
		echo "Nessuna macchina indicata\n";
		exit;
	fi;
	

	i=0;

	while [[ $i -lt ${#MACCHINE[@]} ]] ; do
		if [[ $(echo ${MACCHINE[$i]} | cut -d";" -f 1) = $1 ]] ; then
			echo ${MACCHINE[$i]} | cut -d";" -f 2;
		fi;
		((i+=1))
	done
}


#gestisce CTRL+C exit



touch $LOGFILE_APP
startLog >> $LOGFILE_APP
trap "gestisci_trap"  2

echo;

TAILLOG=0

for i in $(cat $DEPLOY_LIST) ; do 
	echo "Vuoi startare il pacchetto $i ? "
	log_info Richiesta start del pacchetto $i
	RISP=N
	read RISP?"Risposta (y/n) : ";
	if [[ $RISP = "Y" || $RISP = "y" ]] ; then 
		
		log_ok Scelta $RISP per il pacchetto $i

		STAMPA=$(getInfo $i)
		MACCHINA=$(echo $STAMPA | cut -d";" -f 1);
		PACCHETTO=$(echo $STAMPA | cut -d";" -f 2);
		PATHBW=$(echo $STAMPA | cut -d";" -f 3);
		PATHENGINE=$(echo $PATHBW | cut -d"/" -f 1);

		LOG_DIR=$(getPathLog $MACCHINA)


		TAILLOG=1
		
	        NAMELOG=$ENGINE_LOG"_"$PATHENGINE"_"$PACCHETTO.log
		
		#rsh $MACCHINA -l tibadmin " . ./.profile ; nohup $APPMANAGE_BIN -start -app $i -domain $DOMAIN_TIBCO -user $USER_ADMIN_TIBCO -pw $PASS_ADMIN_TIBCO" > $NAMELOG 2>&1 &
	#	rsh $MACCHINA -l tibadmin "; . ./.profile ; nohup $APPMANAGE_BIN -start -app $i -domain $DOMAIN_TIBCO -user $USER_ADMIN_TIBCO -pw $PASS_ADMIN_TIBCO"
		#luigi
		nohup $APPMANAGE_BIN -start -app $i -domain $DOMAIN_TIBCO -user $USER_ADMIN_TIBCO -pw $PASS_ADMIN_TIBCO > $NAMELOG &
		ssh $MACCHINA -l tibadmin "ls -rt $LOG_DIR/*$PACCHETTO*$PATHENGINE* | tail -1 | xargs tail -f";
		
		echo "\nVisualizzazione file $NAMELOG\n";
		cat $NAMELOG;
		
		TAILLOG=0
		ISOK=Y
		
		read ISOK?"Il pacchetto è partito correttamente? (y/n) : ";
		if [[ $ISOK = "Y" || $ISOK = "y" ]] ; then
			log_ok Il pacchetto $i è partito correttamente;
		else
			log_err Il pacchetto $i non è partito correttamente;
		fi;
	fi;
	log_info Si è scelto di non startare il pacchetto $i;
	echo;
done
