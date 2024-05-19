#!/bin/ksh

if [[ $# != 1 ]]
	then
		echo
		echo "ERROR....Usage ---> $0 <RELEASE>"
		echo
fi

RELEASE=$1
TEMP_FILE=.temp_oggetti

. $HOME/.profile >/dev/null 2>&1

OGGETTI=`sqlplus -S siebel/siebel@CRMDB << EOF
set FEEDBACK OFF;
set LINESIZE 100;
set PAGES 0;
select concat(concat(i.OGGETTO, ';'), i.ID_ANAGRAFICA_TIPO_OGG) from item i where ID_FUNZIONALITA in (
select ID_FUNZIONALITA from FUNZIONALITA where ID_RICHIESTA_RILASCIO in
    (select ID_RICHIESTA_RILASCIO from RICHIESTA_RILASCIO WHERE 
        ID_RELEASE in (select ID_RELEASE from RELEASE where NOME LIKE '%$1%')))
        order by i.id_anagrafica_tipo_ogg, i.OGGETTO;
	exit;
EOF`             

if [[ -s $TEMP_FILE ]]
	then rm -f $TEMP_FILE
fi
              
#echo $OGGETTI | awk '{if (NF > max) max = NF; for (i = 1; i <= max; i++) print $i}' >>$TEMP_FILE
echo $OGGETTI | awk '{if (NF > max) max = NF; for (i = 1; i <= max; i++) print $i}'
export VERS