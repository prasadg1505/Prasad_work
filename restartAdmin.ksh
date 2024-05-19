#!/bin/ksh

cd /sbTibco/tibcoesb/scripts/
LOGFILE=/fsTibcoESB/tibcoesb/products/tibcobw/tra/domain/ESBINTH/logs/restartAdmin.log

pid=$( ps -ef|grep "admin" |grep -v "grep"| awk '{ print $2 }')

if [ -z "$pid" ]
then
	echo "Running Administrator...">>$LOGFILE
	StartAdmin.sh >>$LOGFILE
else
echo "Stop Administrator...">>$LOGFILE
        StopAdmin.sh
        sleep 120
		if [ -z "$pid" ]
		then
			echo "starting admin process..."
			StartAdmin.sh >>$LOGFILE
			echo "admin process started.." >> $LOGFILE
		else
			kill -9 $pid
			sleep 120
			StartAdmin.sh >>$LOGFILE
			echo "admin process started.." >> $LOGFILE				
		fi
fi		
