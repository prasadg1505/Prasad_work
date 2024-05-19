#!/bin/ksh

cd /fsTibcoESB/tibcoesb/products/tibcobw/tra/domain/ESBINTH/


find . -name "*.phd" -type f -exec ls -lrt {} \; > /sbTibco/tibcoesb/scripts/heapdump.log

count=`find . -name "*.phd" -type f -exec ls -lrt {} \;|wc -l`
echo $count

if [[ $count -eq 0 ]]
then
echo "no files"
else
echo "Heap Dump files are present"
fi
