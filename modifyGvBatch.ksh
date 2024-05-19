#!/usr/bin/ksh


if [[ -z $1 ]] ; then
  echo;
  echo "ERROR: Usage $0 <LISTMODGV>";
  echo ;
  exit 1;
fi



#PATHLIST="/fsbTibcoAdmESBp/CORE_ESBp/repository/BW/list"
PATHLIST="/fsTibcoESB/tibcoesb/repository/BW/list"
LISTMODGV="${PATHLIST}/$1"
TMPFILE="/tmp/.tmpFileSortOrder_$$"
DATETIME=$(date '+%d%m%Y_%H%M%S')
#LOGFILE="/vobs/ESB_DEV/BW/list/logFileModGv_$$_${DATETIME}.log"
#LOGFILE="/sbTibco/tibadmin/adm_script/scripts/log/logFileModGv_$$_${DATETIME}.log"
LOGFILE="/sbTibco/tibcoesb/adm_script/scripts/log/logFileModGv_$$_${DATETIME}.log"

if [[ ! -f $LISTMODGV ]] ; then
  echo;
  echo "ERROR: List not found";
  echo;
  exit 1;
fi

####### FUNZIONI

function _modifyGv {

  if [[ -z $3 ]] ; then
    echo;
    echo "ERROR: Usare $0 <XMLFILE> <GVNAME> <NEWVALUE>";
    echo;
    exit 1;
  fi

  TMPFILEXML="/tmp/tmpBatchModGv.xml"


  grepCount=$(grep -c "<name>[a-zA-Z/_-]*$2[a-zA-Z/_-]*</name>" $1)
  if [[ $grepCount -eq 1 ]] ; then
    grepFound=$(grep -n "<name>[a-zA-Z/_-]*$2[a-zA-Z/_-]*</name>" $1)
    lineGrep=$(echo $grepFound | cut -f1 -d":")
    lineGrep=$(($lineGrep + 1))
    oldValue=$(tail +${lineGrep} $1 | head -1 | cut -f2 -d">" | cut -f1 -d"<")

    head -n $(($lineGrep - 1)) $1 > $TMPFILEXML;
    echo "            <value>$3</value>" >> $TMPFILEXML;
          lineGrep=$(($lineGrep+1))
          tail +$lineGrep $1 >> $TMPFILEXML;
    chmod +x $1
    cp $TMPFILEXML $1
    printf "$(basename $1) - Modify $2\n" | tee -a $LOGFILE;
    printf "\told value : $oldValue\n" | tee -a $LOGFILE;
    printf "\tnew value : $3\n" | tee -a $LOGFILE;

  else
    printf "Founded ${grepCount} GV for $2\n" | tee -a $LOGFILE;
  fi




}




######## MAIN

#sorting list

printf "Sorting list..."
cat $LISTMODGV | sort -k1 -t"," > $TMPFILE
mv $TMPFILE $LISTMODGV
printf "ok\n"


read BACKUP?"Do you want to create a backup copy of xml file(s) [Y|n] ? "
case $BACKUP in
  y|Y)
      for i in $(cat $LISTMODGV | cut -f1 -d"," | sort -u) ; do
        printf "Backup of $(basename $i) .. " | tee -a $LOGFILE;
        cp -p $i ${i}_$(date +%d%m%y_%H%M%S)
        printf "ok\n" | tee -a $LOGFILE;
      done;
  ;;
esac

for i in $(cat $LISTMODGV) ; do
  XMLFILE=$(echo $i | cut -f1 -d",")
  GVNAME=$(echo $i | cut -f2 -d",")
  NEWVALUE=$(echo $i | cut -f3- -d",")

  if [[ ! -f $XMLFILE ]] ; then
    printf "$XMLFILE doesn't exists, skip\n" | tee -a $LOGFILE;
  else
    _modifyGv $XMLFILE $GVNAME $NEWVALUE
    printf "\n" | tee -a $LOGFILE;
  fi;

done;

for i in $(cat $LISTMODGV) ; do
  XMLFILE=$(echo $i | cut -f1 -d",")
  GVNAME=$(echo $i | cut -f2 -d",")
  NEWVALUE=$(echo $i | cut -f3- -d",")

  if [[ -f $XMLFILE ]] ; then
    #check=$(/sbTibco/tibadmin/adm_script/scripts/tib_extract_gv.sh $XMLFILE $GVNAME)
     check=$(/sbTibco/tibcoesb/adm_script/scripts/tib_extract_gv.sh $XMLFILE $GVNAME)
if [[ -z $check ]] ; then
      printf "${GVNAME} doesn't exists in $(basename ${XMLFILE})\n" | tee -a $LOGFILE;
    else
      checkVal=$(echo $check | awk -F" " '{print $2}')
      printf "Checking if ${GVNAME} has been modified in ${NEWVALUE} .. " | tee -a $LOGFILE;
      if [[ "$NEWVALUE" = "$checkVal" ]] ; then
        printf "ok\n" | tee -a $LOGFILE;
      else
        printf "failed\n" | tee -a $LOGFILE;
      fi;
    fi;
  fi;
done

