#!/bin/ksh 
. $HOME/.profile

SCRIPTDIR=/sbTibco/tibcoesb/scripts
CFGDIR=$SCRIPTDIR/cfg
TMPDIR=$SCRIPTDIR/tmp
LOGDIR=$SCRIPTDIR/log
CFGFILE=$CFGDIR/clean_LogTable_crmdh.cfg     
MYDATE=$(date +"%d-%m-%y")
LOGFILENAME=clean_LogTable_crmdh_$MYDATE.log
LOGFILE=$LOGDIR/$LOGFILENAME
OUTFILE=$TMPDIR/clean_LogTable_crmdh_$MYDATE.out
SQLFILE=$CFGDIR/clean_LogTable_crmdx.sql



rm -rf $LOGFILE
rm -rf $OUTFILE

echo $(date +%F_%T) "### START">> $LOGFILE
echo $(date +%F_%T) "### LOGFILE">> $LOGFILE
echo "- $LOGFILE" >> $LOGFILE

### CARICO IL FILE DI CONFIGURAZIONE
echo $(date +%F_%T) "### CARICO IL FILE DI CONFIGURAZIONE " >> $LOGFILE
echo "- "$CFGFILE >> $LOGFILE
. $CFGFILE


### LANCIO QUERY
echo $(date +%F_%T) "### LANCIO SCRIPT DI PULIZIA">> $LOGFILE
echo "- $DBUSER_H/$DBPWD_H@$DBSID_H @$SQLFILE" >> $LOGFILE   
sqlplus  $DBUSER_H/$DBPWD_H@$DBSID_H << EOF >> $LOGFILE
   @$SQLFILE
EOF
echo $(date +%F_%T) "### FINE PULIZIA" >> $LOGFILE

_sendMail () {
   echo $(date +%F_%T) "### COPIO ALLEGATO SU " $MAIL_HOP " dir: /tmp >> $LOGFILE
   echo "- scp  $LOGFILE $MAIL_USER_HOP@$MAIL_HOP:/tmp/$LOGFILENAME >>  $LOGFILE
   scp  $LOGFILE $MAIL_USER_HOP@$MAIL_HOP:/tmp/$LOGFILENAME

   ssh $MAIL_USER_HOP@$MAIL_HOP unix2dos /tmp/$LOGFILENAME

   echo $(date +%F_%T) "### INVIO MAIL ">> $LOGFILE
   echo "- ssh $MAIL_USER_HOP@$MAIL_HOP /sbOrd2BillMon/nagios/sendEmail/sendEmail -f $MAIL_FROM -t $MAIL_TO -cc $MAIL_CC  -u $MAIL_SBJ -m $MAIL_MSG -s $MAIL_SRV -a $LOGFILE">> $LOGFILE
   ssh $MAIL_USER_HOP@$MAIL_HOP /sbOrd2BillMon/nagios/sendEmail/sendEmail -f $MAIL_FROM -t $MAIL_TO -cc $MAIL_CC -u $MAIL_SBJ -m $MAIL_MSG -s $MAIL_SRV -a /tmp/$LOGFILENAME
}


_sendMail
