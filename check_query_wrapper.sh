#!/bin/ksh

MODE="$(ps -ef|grep -v grep|grep pam|awk '{print $12}'|cut -d'/' -f11|cut -d'-' -f4|cut -d'.' -f1 )"
if [[ "$MODE" == "INT" ]];then
	echo "Pam is in INT MODE"
else
	echo "Pam is in STUB MODE"
fi
