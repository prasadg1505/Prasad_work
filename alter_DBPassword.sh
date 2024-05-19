#!/bin/sh
. /sbTibco/tibcoesb/scripts/env.sh
. ${HOME}/.profile

DB_LIST=/sbTibco/tibcoesb/adm_script/scripts/DB_LIST

for line in $(cat ${DB_LIST}); do
DB_USER=$(echo $line | cut -d";" -f1)
DB_PASSWORD=$(echo $line | cut -d";" -f2)
TNS_NAME=$(echo $line | cut -d";" -f3)

echo "Applying alter statement for the ${DB_USER} in DB ${TNS_NAME}"
echo "*******************************************************"
echo "ALTER USER ${DB_USER} IDENTIFIED BY \"${DB_PASSWORD}\";"| sqlplus -L ${DB_USER}/${DB_PASSWORD}@${TNS_NAME} | grep 'User altered.' > /dev/null
if [ $? -eq 0 ]
then
   echo "Result:SUCCEEDED"
else
   echo "Result:FAILED"
fi
done
