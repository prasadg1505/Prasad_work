#!/bin/sh


Space_fsTibcoESB=`df -k /fsTibcoESB | awk '{print $4}' | tail -1 | sed "s/%//g" `
Space_sbTibcoServer=`df -k /sbTibcoServer | awk '{print $4}' | tail -1 | sed "s/%//g" `
Space_sbTibco=`df -k /sbTibco | awk '{print $4}' | tail -1 | sed "s/%//g" `
Space_tmp=`df -k /tmp | awk '{print $4}' | tail -1 | sed "s/%//g" `

echo /fsTibcoESB  mount usage is at $Space_fsTibcoESB %
echo /sbTibcoServer mount usage is at $Space_sbTibcoServer
echo /sbTibco mount usage is at $Space_sbTibco %
echo /tmp mount usage is at $Space_tmp %

if [[ $Space_fsTibcoESB -ge '90' || $Space_sbTibcoServer -ge '90' || $Space_sbTibco -ge '90' || $Space_tmp -ge '90' ]]
then
        exit 1
fi

