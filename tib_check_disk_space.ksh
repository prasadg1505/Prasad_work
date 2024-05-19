#!/bin/ksh
. $HOME/.profile

SCRIPTDIR=/sbTibco/tibcoesb/scripts
ADMIN_DIR=$SCRIPTDIR
CFGDIR=$SCRIPTDIR/cfg
TEMPLATEDIR=$CFGDIR
TMPDIR=$SCRIPTDIR/tmp
LOGDIR=$SCRIPTDIR/log
CFGFILE=$CFGDIR/tib_check_disk_space.cfg
MYDATE=$(date +"%d-%m-%y")
LOGFILENAME=tib_check_disk_space_$MYDATE.log
LOGFILE=$LOGDIR/$LOGFILENAME
OUTFILENAME=tib_check_disk_space_$MYDATE.html
OUTFILE=$TMPDIR/$OUTFILENAME
. $CFGFILE

DAINVIARE=0
CREATO=0
PIENO=0

rm -rf $OUTFILE
     
     echo "<html>"                                                                                        >> $OUTFILE
     echo "<head>"                                                                                        >> $OUTFILE
     echo "<title>VERIFICA FILE SYSTEM  $HOST_NAME - $MYDATE </title>"                                    >> $OUTFILE
     echo "<meta name="generator" content="">"                                                            >> $OUTFILE
     echo "<meta name="description" content="">"                                                          >> $OUTFILE
     echo "<meta name="keywords" content="">"                                                             >> $OUTFILE
     echo "</head>"                                                                                       >> $OUTFILE
     echo "<body bgcolor="#ffffff" text="#000000" link="#0000ff" vlink="#800080" alink="#ff0000">"        >> $OUTFILE
     echo "<div align="center"><br><b>FILE SYSTEM CHECK  $HOST_NAME - $MYDATE</b><br><br></div>"       >> $OUTFILE
     echo "<div align="center">"         					                    	  >> $OUTFILE
     echo "   <table cellspacing="1" cellpadding="1" width="400" bgcolor="#ffffff" border="0">"           >> $OUTFILE
     echo "     <tr valign="top">"								          >> $OUTFILE
     echo "        <td nowrap="" bordercolor="#0080c0" bgcolor="#0000a0" width="120">"			  >> $OUTFILE
     echo "          <font color="#ffffff" size="2"><em><strong>FREE SPACE</strong></em></font></td>" 	  >> $OUTFILE
     echo "        <td nowrap="" bordercolor="#0080c0" bgcolor="#0000a0" width="100">"			  >> $OUTFILE
     echo "          <font color="#ffffff" size="2"><em><strong>PCT USED</strong></em></font></td>"       >> $OUTFILE
     echo "        <td nowrap="" bordercolor="#0080c0" bgcolor="#0000a0" width="180">"		          >> $OUTFILE
     echo "          <font color="#ffffff" size="2"><em><strong>F. S.</strong></em></font></td>"          >> $OUTFILE
     echo "    </tr>"										          >> $OUTFILE



# get length of an array
tLen=$(#FSARRAY[@])
 
for i in ${FSARRAY[@]}
do
 if  [ -d $i ]
 then
   cd $i;
   PARTITION=`df -k . | awk '{print $1}' | tail +2`;
        SIZE=`df -k . | awk '{print $2}' | tail +2`;
        FREE=`df -k . | awk '{print $3}' | tail +2`;   
        #USED=`df -k . | awk '{print $3}' | tail +2`;
         PCT=`df -k . | awk '{print $4}' | tail +2 | cut -f1 -d%`;
          FS=`df -k . | awk '{print $7}' | tail +2`;
       
   
     echo "    <tr valign=""top"">" 	          	  						  >> $OUTFILE
     echo "        <td bordercolor="#0080c0" width="230"><font size="2">$FREE KB</font></td> " 		  >> $OUTFILE
     echo "        <td bordercolor="#0080c0"><font size="2">$PCT %</font></td> "   			  >> $OUTFILE
     echo "        <td bordercolor="#0080c0"><font size="2">$FS</font></td> "		    	          >> $OUTFILE
     echo "    </tr>"	                                                                                  >> $OUTFILE
     

     if [ $PCT -ge $WARNING_THREESHOLD ]
     then
           DAINVIARE=1 
           if [ $PCT -ge $ALERT_THREESHOLD ]
           then
               PIENO=1
           fi
     fi
 fi
done
    echo "</table></div></font> </div>"                                                                   >> $OUTFILE  
    echo "</body>"                                                                                        >> $OUTFILE
    echo "</html>"                                                                                        >> $OUTFILE

if [ $DAINVIARE -eq 1 ]
then
      if [ $PIENO -eq  1 ]
      then
             scp $OUTFILE $MAIL_USER_HOP@$MAIL_HOP:/tmp/$OUTFILENAME  >> /dev/null
             ssh $MAIL_USER_HOP@$MAIL_HOP /sbOrd2BillMon/nagios/sendEmail/sendEmail -f $MAIL_FROM -t $MAIL_TO -cc $MAIL_CC -u $MAIL_SBJ_ALERT -m $MAIL_MSG_ALERT -s $MAIL_SRV -a /tmp/$OUTFILENAME
      else
             scp $OUTFILE $MAIL_USER_HOP@$MAIL_HOP:/tmp/$OUTFILENAME  >> /dev/null
             ssh $MAIL_USER_HOP@$MAIL_HOP /sbOrd2BillMon/nagios/sendEmail/sendEmail -f $MAIL_FROM -t $MAIL_TO -cc $MAIL_CC -u $MAIL_SBJ_WARN  -m $MAIL_MSG_WARN  -s $MAIL_SRV -a /tmp/$OUTFILENAME
      fi
                
fi
 rm -f $OUTFILE

