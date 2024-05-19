#!/bin/ksh

echo ${0}
PROCESSO=`ps -ef|grep ${0}|grep -v 'grep'|wc -l`
LOCAL_PATH="/sbTibco/tibcoesb/adm_script/scripts"
if [[ $PROCESSO -gt 1 ]] ; then
        echo "Esiste gia' un processo attivo dello script"
        exit
fi





DB=bwkdc
USER=bw_bill
PASS=bw_billpwdc


sqlplus -s ${USER}/${PASS}@${DB} @${LOCAL_PATH}/rebuild_idx.sql
