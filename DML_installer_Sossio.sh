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
if [ ${CATEG} == "external/RDB" ] ; then
	if [ -a ${REPOSITORY_PATH}/DML/deploy/rel${REL}/external/RDB/01.Integration/CRMU_RDBOWN*.sql ] ; then
		REPOSITORY=${REPOSITORY_PATH}/DML/deploy/rel${REL}/external/RDB
	else
		REPOSITORY=${REPOSITORY_PATH}/DML/deploy/rel${REL}/EXTERNAL/RDB
	fi
fi

if [ ${CATEG} == "external/ROS" ] ; then
        if [ -a ${REPOSITORY_PATH}/DML/deploy/rel${REL}/external/ROS/01.Integration/CRMU_ROS*.sql ] ; then
                REPOSITORY=${REPOSITORY_PATH}/DML/deploy/rel${REL}/external/ROS
        else
                REPOSITORY=${REPOSITORY_PATH}/DML/deploy/rel${REL}/EXTERNAL/ROS
        fi
fi

cd $REPOSITORY

tail -1 ${LIST_PATH} | grep CRMU_RDBOWN > .lista_appo
tail -1 ${LIST_PATH} | grep ROS_RDBOWN > .lista_appo1



if [[ -s .lista_appo ]] ; then
	for line in `cat ${LIST_PATH}` ; do
		echo "**************************************************************************\n" >> ${LOGFILE}
		echo "Install $line" >> ${LOGFILE}
#               export TNS_ADMIN=/sbtibco/tibcoesb 
		sqlplus ${DBLOGIN}@CRMDH @$REPOSITORY/01.Integration/$line >> ${LOGFILE} 
		echo "**************************************************************************\n" >> ${LOGFILE}
	done
elif [[ -s .lista_appo1 ]] ; then
        for line in `cat ${LIST_PATH}` ; do
                echo "**************************************************************************\n" >> ${LOGFILE}
                echo "Install $line" >> ${LOGFILE}
#               export TNS_ADMIN=/sbtibco/tibcoesb 
                sqlplus ${DBLOGIN}@ROST @$REPOSITORY/01.Integration/$line >> ${LOGFILE}
                echo "**************************************************************************\n" >> ${LOGFILE}
        done
else
	for line in `cat ${LIST_PATH}` ; do
		echo "**************************************************************************\n" >> ${LOGFILE}
		echo "Install $line" >> ${LOGFILE}
                export TNS_ADMIN=/sbrdbms/app/oracle/product/11.2.0.2/db_clie/network/admin
		sqlplus ${DBLOGIN}@${ORACLE_SID} @$line >> ${LOGFILE} 
		echo "**************************************************************************\n" >> ${LOGFILE}
	done
rm -f .lista_appo
fi

ENDDATE=$(date)
echo "\n\n\tINSTALL FINISHED AT ${ENDDATE}\n" >> ${LOGFILE}
exit 0
