#!/bin/ksh

echo
echo "Enable dequeue and enqueue on iProcess queuest..."

sqlplus SWPRO1/staffpro1@IPEDC <<EOF
execute DBMS_AQADM.START_QUEUE('bgmboxqueue1',true,true);
execute DBMS_AQADM.START_QUEUE('bgmboxqueue2',true,true);
execute DBMS_AQADM.START_QUEUE('bgmboxqueue3',true,true);
execute DBMS_AQADM.START_QUEUE('predictmboxqueue1',true,true);
execute DBMS_AQADM.START_QUEUE('predictmboxqueue2',true,true);
execute DBMS_AQADM.START_QUEUE('sw_system_events',true,true);
execute DBMS_AQADM.START_QUEUE('wismboxqueue1',true,true);
execute DBMS_AQADM.START_QUEUE('wismboxqueue2',true,true);
EOF

