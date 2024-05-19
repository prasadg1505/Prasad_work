#!/bin/ksh

EMSHOST=$(hostname)

if [[ $# -ne 1 ]]
then
	echo
	echo "USAGE: $0 <queue list>"
	echo
	exit 1
fi

LIST=$REPOSITORY_PATH/EMS/list/$1
if [[ ! -s $LIST ]]
then
		    echo
				echo "ERROR: list file $LIST not found"
				echo
				exit 1
fi

if [[ $EMSHOST = "esbcas01" || $EMSHOST = "esbcas02" ]]
then
				EMSSRV=tcp://esbcas01:27222
				EMSSRV2=tcp://esbcas02:37222
				PROP=global
				echo
				echo "\033[1mRunning in production environment!\033[m"
else
			  PROP=""
				EMSSRV2=""
			  echo
				echo "\033[1mRunning in test environment!\033[m"
fi

echo "Creating queues on EMS SERVER: $EMSSRV"
echo

for QUEUENAME in $(cat $LIST)
do

echo "Creating queue $QUEUENAME"
$TIBCO_HOME/ems/bin/tibemsadmin -server "$EMSSRV" -user admin -password admin <<EOF
create queue $QUEUENAME $PROP
exit
EOF

done

if [[ -n $EMSSRV2 ]]
then

echo "Creating ROUTED queues on EMS SERVER: $EMSSRV2"
echo

for QUEUENAME in $(cat $LIST)

do
$TIBCO_HOME/ems/bin/tibemsadmin -server "$EMSSRV2" -user admin -password admin <<EOF
create queue ${QUEUENAME}@EMS-SERVER-1 $PROP
exit
EOF

done

fi

