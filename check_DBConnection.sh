#!/bin/sh

DB_LIST=/sbTibco/tibcoesb/adm_script/scripts/DB_LIST

for line in $(cat ${DB_LIST}); do
echo $line | grep ^# >/dev/null
if [ $? -ne 0 ]; then
DB_USER=$(echo $line | cut -d";" -f1)
DB_PASSWORD=$(echo $line | cut -d";" -f2)
TNS_NAME=$(echo $line | cut -d";" -f3)
DB_value=$(echo $line | cut -d";" -f4)
echo "**************************************"
echo "Checking Connection for ${DB_value} Database"
echo "exit" | sqlplus -L ${DB_USER}/${DB_PASSWORD}@${TNS_NAME} | grep 'Connected to' > /dev/null
if [ $? -eq 0 ]
then
   echo "Connected to ${DB_value} Database"
else
   echo "Connection Failed to ${DB_value} Database"
fi
echo "**************************************"
fi
done
