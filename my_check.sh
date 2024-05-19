#!/bin/ksh

_getbwpid () {

for i in $(ps -o "%p;%a" -u tibadmin |grep on\/${CHECKEAR} | grep "5.6\/bin\/bwengine" | cut -d";" -f1); do
	echo "$i \c"
done
return
}

# Main

if [[ -z $1 ]]; then
	echo
	echo "USAGE: $0 <EAR>"
	echo
	exit 1
fi

CHECKEAR=$1

if [[ $CHECKEAR = esb2EHConsole ]]; then
	echo
	echo "WARNING: sorry, but for $CHECKEAR the duplicate-check feature is disabled! Please check manually."
	echo
	exit 2
fi

CHECKPID=$(_getbwpid)

echo $CHECKPID
exit 1

if [[ -n $CHECKPID ]]; then
	echo
	echo "\033[1mWARNING: running instances of $CHECKEAR (PIDs = ${CHECKPID}) found!\033[m"
	echo
	echo "Killing PIDs $CHECKPID...\c"
	kill -9 $CHECKPID
	sleep 3
	
	CHECKPID=$(_getbwpid)
	if [[ -n $CHECKPID ]]; then
		echo
		echo "ERROR: impossible to kill $CHECKEAR (PIDs = ${CHECKPID})"
		echo
		exit 3
	fi
	
	echo "Done!"
	echo	
else
	echo
	echo "INFO: no running instances of $CHECKEAR found"
	echo
fi