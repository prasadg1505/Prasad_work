#!/bin/ksh

CRED_FILE=$HOME/adm_script/scripts/cred.txt

OPTION="KO"
while [[ $OPTION = "KO" ]] ; do
        clear
        echo
        echo
        echo "\033[1m                            Wind - Progetto CRM Unico           \033[m"
        echo "                           - Tibco Administration Tools -                    "
        echo "                         - Wrapper / PAM Integration Switch -                        "
        echo
        echo "                           ---> \033[7mChoose Options\033[m <---             "
        echo
        echo
        echo "\033[1m  1\033[m   Switch to stub"
        echo
        echo "\033[1m  2\033[m   Switch to integration"
        echo
        read ANS?"  Select option ([A] to abort): "

        case $ANS in
          1)    OPTION="STUB";;
          2)    OPTION="ESB";;
                A|a)exit 0;;
          *)    OPTION="KO";;
        esac
done

echo Stopping PAM/wrapper instances......

nohup ${TIBCO_TRA_HOME_PATH}/bin/AppManage -stop -app ESB/pam_nms_ndb2crm -domain $TIB_DOMAIN -cred $CRED_FILE >> nohup.out.ESB 2>&1
nohup ${TIBCO_TRA_HOME_PATH}/bin/AppManage -stop -app STUB/pam_nms_ndb2crm -domain $TIB_DOMAIN -cred $CRED_FILE >> nohup.out.ESB 2>&1

echo Starting required PAM/wrapper instances...

if [[ $OPTION == "STUB" ]]; then
        nohup ${TIBCO_TRA_HOME_PATH}/bin/AppManage -start -app STUB/pam_nms_ndb2crm -domain $TIB_DOMAIN -cred $CRED_FILE >> nohup.out.ESB 2>&1
fi
if [[ $OPTION == "ESB" ]]; then
        nohup ${TIBCO_TRA_HOME_PATH}/bin/AppManage -start -app ESB/pam_nms_ndb2crm -domain $TIB_DOMAIN -cred $CRED_FILE >> nohup.out.ESB 2>&1
fi

sleep 10
echo Switch completed !
echo

