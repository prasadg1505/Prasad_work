#!/bin/sh

dirpath=/sbtibco/tibcoesb/adm_script/scripts/dirpath
for line in $(cat ${dirpath}); do
echo "Moving to $line ..."
cd $line
echo "Creating rel$1 ..."
mkdir rel$1
cd rel$1
echo "Creating folders  list,external, BILLING and ESB inside $line/rel$1 ..."
mkdir list external BILLING ESB
cd external
echo "Creating folders NETBILL, RDB and ROS inside $line/rel$1/external ..."
mkdir NETBILL RDB ROS
mkdir -p RDB/01.Integration
mkdir -p ROS/01.Integration
done
echo "\n\n\tdir tree created for DML and DDL\n"
