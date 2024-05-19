#!/bin/ksh
CRED_FILE=$HOME/adm_script/scripts/cred.txt
echo ........Stopping sdcStub  ears instances......

nohup ${TIBCO_TRA_HOME_PATH}/bin/AppManage -stop -app ESB/sdcStub -domain $TIB_DOMAIN -cred $CRED_FILE >> nohup.out.ESB 2>&1


sleep 30

echo .......Starting  sdcStub  ears instances.......

nohup ${TIBCO_TRA_HOME_PATH}/bin/AppManage -start -app ESB/sdcStub -domain $TIB_DOMAIN -cred $CRED_FILE >> nohup.out.ESB 2>&1

