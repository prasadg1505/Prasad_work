#!/bin/ksh

CRED_FILE=$HOME/adm_script/scripts/cred.txt


echo ........Stopping esb2siebel ears instances......

nohup ${TIBCO_TRA_HOME_PATH}/bin/AppManage -stop -app ESB/esb2siebel -domain $TIB_DOMAIN -cred $CRED_FILE >> nohup.out.ESB 2>&1
nohup ${TIBCO_TRA_HOME_PATH}/bin/AppManage -stop -app ESB2/esb2siebel -domain $TIB_DOMAIN -cred $CRED_FILE >> nohup.out.ESB 2>&1

sleep 50

echo .......Starting  esb2siebel ears instances.......

nohup ${TIBCO_TRA_HOME_PATH}/bin/AppManage -start -app ESB/esb2siebel -domain $TIB_DOMAIN -cred $CRED_FILE >> nohup.out.ESB 2>&1
nohup ${TIBCO_TRA_HOME_PATH}/bin/AppManage -start -app ESB2/esb2siebel -domain $TIB_DOMAIN -cred $CRED_FILE >> nohup.out.ESB 2>&1


