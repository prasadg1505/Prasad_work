
ld=$(tty -s && tput bold)
normal=$(tty -s && tput sgr0)
NONE='\033[00m'
RED='\033[01;31m'

rm -rf spacemount.log

Space_sbTibcoServer=`df -k /sbTibcoServer | awk '{print $4}' | tail -1 | sed "s/%//g" `

Space_fsTibcoESB=`df -k /fsTibcoESB | awk '{print $4}' | tail -1 | sed "s/%//g" `

Space_tmp=`df -k /tmp | awk '{print $4}' | tail -1 | sed "s/%//g" `

echo /sbTibcoServer  mount usage is at $Space_sbTibcoServer % > diskspace.txt
echo /fsTibcoESB mount usage is at $Space_fsTibcoESB % >> diskspace.txt
echo /tmp mount usage is at $Space_tmp % >> diskspace.txt

if [[ $Space_sbTibcoServer -ge '90' ]];
then
       
        find . -name "*.phd" -type f -exec ls -lrt {} \; >> /sbTibco/tibcoesb/scripts/heapdump.log
else
       
                echo -e ${NONE}${normal} /sbTibcoServer  mount usage is at $Space_sbTibcoServer % >> heapdump.log
fi
if [[ $Space_fsTibcoESB -ge '85' ]];
then
       
              find . -name "*.phd" -type f -exec ls -lrt {} \; >> /sbTibco/tibcoesb/scripts/heapdump.log
else
       
                echo -e ${NONE}${normal} /fsTibcoESB mount usage is at $Space_fsTibcoESB % >> heapdump.log
fi
if [[  $Space_tmp -ge '85' ]];
then
       
                find . -name "*.phd" -type f -exec ls -lrt {} \; >> /sbTibco/tibcoesb/scripts/heapdump.log
else
       
                 echo -e ${NONE}${normal} /tmp mount usage is at $Space_tmp % >> heapdump.log
fi


#!/bin/ksh
bold=$(tty -s && tput bold)
normal=$(tty -s && tput sgr0)
NONE='\033[00m'
RED='\033[01;31m'

rm -rf spacemount.log

Space_sbTibcoServer=`df -k /sbTibcoServer | awk '{print $4}' | tail -1 | sed "s/%//g" `

Space_fsTibcoESB=`df -k /fsTibcoESB | awk '{print $4}' | tail -1 | sed "s/%//g" `

Space_tmp=`df -k /tmp | awk '{print $4}' | tail -1 | sed "s/%//g" `

echo /sbTibcoServer  mount usage is at $Space_sbTibcoServer % > diskspace.txt
echo /fsTibcoESB mount usage is at $Space_fsTibcoESB % >> diskspace.txt
echo /tmp mount usage is at $Space_tmp % >> diskspace.txt

if [[ $Space_sbTibcoServer -ge '50' ]];
then
       
        find . -name "*.phd" -type f -exec ls -lrt {} \; >> /sbTibco/tibcoesb/scripts/removephd.log
else
       
                echo -e ${NONE}${normal} /sbTibcoServer  mount usage is at $Space_sbTibcoServer % >> removephd.log
fi
if [[ $Space_fsTibcoESB -ge '50' ]];
then
       
              find . -name "*.phd" -type f -exec ls -lrt {} \; >> /sbTibco/tibcoesb/scripts/removephd.log
else
       
                echo -e ${NONE}${normal} /fsTibcoESB mount usage is at $Space_fsTibcoESB % >> removephd.log
fi
if [[  $Space_tmp -ge '50' ]];
then
       
                find . -name "*.phd" -type f -exec ls -lrt {} \; >> /sbTibco/tibcoesb/scripts/removephd.log
else
       
                 echo -e ${NONE}${normal} /tmp mount usage is at $Space_tmp % >> removephd.log
fi


