#!/bin/ksh

if [[ $# != 4 ]] ; then
	echo
	echo "ERROR!!! Usage ----> $0 <DML_list> <DBLOGIN> <REL> <CATEG>"
	echo
fi

LISTA=$1
DBLOGIN=$2
REL=$3
CATEG=$4

REPOSITORY=${REPOSITORY_PATH}/DML/deploy/rel${REL}/${CATEG}
LIST_PATH=${REPOSITORY_PATH}/DML/deploy/rel${REL}/list/${LISTA}

if [[ ! -e $LIST_PATH ]] ; then
	echo
	echo "Error!!! $LISTA does not exists in ${REPOSITORY_PATH}/DML/deploy/rel${REL}/list"
	echo
	exit 1
fi

DATA=$(date +%H%M_%Y%m%d)
LOGPATH=${HOME}/adm_script/scripts/log
SCRIPT=$(basename $0)
LOGFILE=${LOGPATH}/${SCRIPT}_${DATA}.log

STARTDATE=$(date)
echo "\n\tSTART INSTALL AT ${STARTDATE}\n\n" > ${LOGFILE}

cd $REPOSITORY


for line in `cat ${LIST_PATH}` ; do
	echo Eseguo $line	
	echo "**************************************************************************\n" >> ${LOGFILE}
	echo "Install $line" >> ${LOGFILE}
	sqlplus ${DBLOGIN}@${ORACLE_SID} @$line >> ${LOGFILE} 
	echo "**************************************************************************\n" >> ${LOGFILE}
done


ENDDATE=$(date)
echo "\n\n\tINSTALL FINISHED AT ${ENDDATE}\n" >> ${LOGFILE}
exit 0

