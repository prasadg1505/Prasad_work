#!/bin/ksh

CHECK_LIST=/sw_repository/tibadmin/BW/list/ciao.txt
DISTRIBUTION_LIST=/sw_repository/tibadmin/BW/list/mail_TEA_distribution.lst

_sendMail () {
        SUBJECT="Chiara Vellucci e' stata inserita nella lista!!!"
        for line in $(cat $DISTRIBUTION_LIST) ; do
                mail=$(echo $line | cut -d";" -f2)
                mailx -s "$SUBJECT" $mail < $CHECK_LIST
                echo "Invio a $mail"
        done
}
_sendMail 
