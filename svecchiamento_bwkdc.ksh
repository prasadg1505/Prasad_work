#!/bin/ksh
. $HOME/.profile


SCRIPTDIR=/sbTibco/tibcoesb/scripts
CFGDIR=$SCRIPTDIR/cfg
TMPDIR=$SCRIPTDIR/tmp
LOGDIR=$SCRIPTDIR/log
CFGFILE=$CFGDIR/clean_LogTable_bwkdc.cfg
MYDATE=$(date +"%d-%m-%y")
LOGFILENAME=clean_LogTable_bwkdc_$MYDATE.log
LOGFILE=$LOGDIR/$LOGFILENAME
SQLFILE=$SCRIPTDIR/svecchiamento_bwkdc.sql
#SQLFILE=$SCRIPTDIR/test.sql


rm -rf $LOGFILE

echo $(date +%F_%T) "### START">> $LOGFILE
echo $(date +%F_%T) "### LOGFILE">> $LOGFILE
echo "- $LOGFILE" >> $LOGFILE

### CARICO IL FILE DI CONFIGURAZIONE
echo $(date +%F_%T) "### CARICO IL FILE DI CONFIGURAZIONE " >> $LOGFILE
echo "- "$CFGFILE >> $LOGFILE
. $CFGFILE


### LANCIO QUERY
echo $(date +%F_%T) "### LANCIO SCRIPT DI PULIZIA">> $LOGFILE
echo "- sqlplus $DBUSER_BWC/$DBPWD_BWC@$DBSID_BWC @$SQLFILE" >> $LOGFILE
sqlplus  $DBUSER_BWC/$DBPWD_BWC@$DBSID_BWC < $SQLFILE >> $LOGFILE
EOF
echo $(date +%F_%T) "### FINE PULIZIA" >> $LOGFILE
