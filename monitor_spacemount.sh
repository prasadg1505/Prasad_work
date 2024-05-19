bold=$(tty -s && tput bold)
normal=$(tty -s && tput sgr0)
NONE='\033[00m'
RED='\033[01;31m'

rm -rf spacemount.log
Space_sbTibcoServer=`df -k /sbTibcoServer | awk '{print $4}' | tail -1 | sed "s/%//g" `
Space_fsTibcoESB=`df -k /fsTibcoESB | awk '{print $4}' | tail -1 | sed "s/%//g" `


echo /sbTibcoServer  mount usage is at $Space_sbTibcoServer % > diskspace.txt
echo /fsTibcoESB mount usage is at $Space_fsTibcoESB % >> diskspace.txt


if [[ $Space_sbTibcoServer -ge '85' || $Space_fsTibcoESB -ge '85' ]];
then
        alertFlag=1
        echo
        echo -e '\t''\t''\t' ${bold}================================================
        echo -e '\t''\t''\t' Action Required. Clear up space to avoid issues.
        echo -e '\t''\t''\t' ================================================
        echo -e '\t''\t''\t' ${bold}================================================ > spacemount.log
        echo -e '\t''\t''\t' Action Required. Clear up space to avoid issues. >> spacemount.log
        echo -e '\t''\t''\t' ================================================ >> spacemount.log

fi
echo

if [[ $Space_sbTibcoServer -ge '85' ]];
then
        #echo -e ${RED}${bold} /sbTibcoServer  mount usage is at $Space_sbTibcoServer %
        echo -e ${RED}${bold} /sbTibcoServer  mount usage is at $Space_sbTibcoServer % >> spacemount.log
else
        #echo -e ${NONE}${normal} /sbTibcoServer  mount usage is at $Space_sbTibcoServer %
                echo -e ${NONE}${normal} /sbTibcoServer  mount usage is at $Space_sbTibcoServer % >> spacemount.log
fi
if [[ $Space_fsTibcoESB -ge '85' ]];
then
        #echo -e ${RED}${bold} /fsTibcoESB mount usage is at $Space_fsTibcoESB %
                echo -e ${RED}${bold} /fsTibcoESB mount usage is at $Space_fsTibcoESB % >> spacemount.log
else
        #echo -e ${NONE}${normal} /fsTibcoESB mount usage is at $Space_fsTibcoESB %
                echo -e ${NONE}${normal} /fsTibcoESB mount usage is at $Space_fsTibcoESB % >> spacemount.log
fi


ssh crmsas52 -l tibcoesb "./sbTibco/tibcoesb/scripts/monitor_spacemount.sh" >> spacemount.log
cat spacemount.log

echo
echo
