#!/bin/ksh

_getPrintval() {

rm -rf /tmp/billing2crm.BILL_appl.xml
/sbTibcoServer/tibcoesb/products/tibcobw/tra/5.7/bin/AppManage -export -app BILL/billing2crm -domain ESBINTH -out /tmp/billing2crm.BILL_appl.xml -cred /sbTibco/tibcoesb/adm_script/scripts/cred.txt -max -serialize
val=`awk '/serverId_prep/{getline; print}' /tmp/billing2crm.BILL_appl.xml | cut -d'<' -f2 | cut -d'>' -f2`

echo
echo "\033[1m  \033[m   Current value is : $val"
echo
echo "\033[1m  \033[m   Would you like to update the billing2crm/consumer/serverId_prep value ? (Y/N) :"
read ANS2?

	case $ANS2 in
		Y|y)	_updateVal
				;;
		*)	exit
				;;
	esac
}


_updateVal() {

	
    echo "                        ---> \033[7mChoose Option\033[m <---             "
    echo
    echo
    echo "\033[1m  1\033[m   Update value to 41"
    echo
    echo "\033[1m  2\033[m   Update value to 42"
    echo
    read ANS?"  Select option ([A] to abort): "

    case $ANS in
		1)	val=41
			;;
		2)	val=42
			;;
    esac

	if [[ $val -eq 41 ]]; then
		echo "/fsTibcoESB/tibcoesb/repository/BW/billing2crm/xml/billing2crm.BILL.ESBINTH.xml,billing2crm/consumer/serverId_prep,41" > /fsTibcoESB/tibcoesb/repository/BW/list/b2c_sp_id_gv
	fi
	if [[ $val -eq 42 ]]; then
		echo "/fsTibcoESB/tibcoesb/repository/BW/billing2crm/xml/billing2crm.BILL.ESBINTH.xml,billing2crm/consumer/serverId_prep,42" > /fsTibcoESB/tibcoesb/repository/BW/list/b2c_sp_id_gv
	fi

	/sbTibco/tibcoesb/adm_script/scripts/modifyGvBatch.ksh b2c_sp_id_gv
	
	echo
	echo " Deploying the updated configuration. . ."
	/sbTibco/tibcoesb/adm_script/scripts/tib_parallel_deploy_batch.sh b2c_sp_id_list start undeploy nodelete > /sbTibco/tibcoesb/adm_script/scripts/log/spval.log
}

############################### MAIN ##################################

        clear
        echo
        echo "                         - ServerId_prep value modifier -                        "
		echo
		echo
		echo "\033[1m  \033[m   Fetching the current value . . ."
		_getPrintval

