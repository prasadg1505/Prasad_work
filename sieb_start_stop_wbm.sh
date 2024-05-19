#!/bin/ksh

if [[ $# -ne 1 ]]
then
	echo
	echo "USAGE: $0 <start | stop >"
	echo
	echo "Start/Stop work-batch manager server"
	echo
	exit 1
fi

COMM=$1

if [[ $COMM != "stop" &&  $COMM != "start" &&  $COMM != "check" ]]
then 
	echo
	echo "ERROR: wrong parameter"
	echo
        echo "USAGE: $0 <start | stop | check>"
        echo
        echo "Stop Siebel work/batch manager server"
        echo
        exit 1
fi

rsh crmsas51 -l siebmast -n ". /sbsieb/siebmast/.profile >/dev/null 2>&1 ; cd /sbsieb/siebmast/tibadmin ; sieb_start_stop_wbm.sh $COMM"

echo

