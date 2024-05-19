#!/bin/sh

for line in $(cat restart_ear_opz.lst)
do
echo "STOPPING--> $line"
${TIBCO_TRA_HOME_PATH}/bin/AppManage -stop -app ESB/${line} -domain $TIB_DOMAIN -user admin -pw tibIntegrato! | tee -a /sbTibco/tibcoesb/adm_script/scripts/log/stopearopz.log
done

for line in $(cat restart_ear_opz.lst)
do
echo "STARTING--> $line"
${TIBCO_TRA_HOME_PATH}/bin/AppManage -start -app ESB/${line} -domain $TIB_DOMAIN -user admin -pw tibIntegrato! | tee -a /sbTibco/tibcoesb/adm_script/scripts/log/startearopz.log
done

