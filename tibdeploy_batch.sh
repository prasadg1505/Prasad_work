#!/bin/ksh

# Usage : tibdeploy_batch <LIST_FILE>

SCRIPTNAME=$0

if [[ $# != 1 ]]
then
    echo
    echo "Error!! Usage: $SCRIPTNAME <list_file>\n\n"
    echo
    exit 1
fi

LIST_FILE=$1
LIST_PATHNAME=$REPOSITORY_PATH/BW/list/$LIST_FILE


if [[ ! -s $LIST_PATHNAME ]]
then
    echo
    echo "File $LIST_PATHNAME does not exist"
    echo
    exit 1
fi

LOGFILE=$HOME/log/tibdeploy_batch_$(date +"%Y%m%d_%H%M%S").log
touch $LOGFILE

integer CONTOK=0

for line in $(cat $LIST_PATHNAME)
do
   echo "************************************************************" >> $LOGFILE
   CATEG=$(echo $line | cut -d";" -f1)
   EAR=$(echo $line | cut -d";" -f2)
   #echo "\ntibdeploy.sh $DOMAIN_NAME $EAR $EAR $CATEG\n\n"
   tibdeploy.sh $DOMAIN_NAME $EAR $EAR $CATEG
   error=$?
   if [[ $error != 0 ]]
   then
       echo "Ear $EAR not deployed" >> $LOGFILE
       echo "Deploy KO" >> $LOGFILE
       
       echo "\n\nError deployng ear $EAR\n\n"
       echo "Do you want to continue deployng next ear in the list?\n"
       echo "Make your choice: "
       read choice
       if [ "$choice" = "n" ] || [ "$choice" = "N" ]
       then
           echo "************************************************************" >> $LOGFILE
           echo "Leaving deploy application. You must manually deploy next ears in the list starting from $EAR\n\n"
           exit 1
       fi
   fi
   if [[ $error = 0 ]]
   then
       CONTOK=$CONTOK+1
       echo "Ear $EAR successfully deployed" >> $LOGFILE
       echo "Deploy OK" >> $LOGFILE
   fi 
done
echo "************************************************************" >> $LOGFILE
echo "\n$CONTOK ears correctly deployed\n" >> $LOGFILE
exit 0
