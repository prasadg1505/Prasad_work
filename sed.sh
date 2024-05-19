#!/bin/ksh

LIST=$REPOSITORY_PATH/BW/list/EAR_single_list

for line in $(cat $LIST) ; do
	EAR=$(echo $line | cut -d ";" -f2)
	if [[ $EAR != "esb2EHConsole" ]] ; then
		XML=$REPOSITORY_PATH/BW/$EAR/xml/$EAR.ESBDI.xml
		#cp $REPOSITORY_PATH/BW/$EAR/xml/$EAR.ESBDB.xml $XML
	else
		XML=$REPOSITORY_PATH/BW/esb2EHConsole/xml/esb2EHConsoleESB.ESBDI.xml
		#cp $REPOSITORY_PATH/BW/esb2EHConsole/xml/esb2EHConsoleESB.ESBDB.xml $XML
	fi
	cp $XML $XML.bck
	cp $XML $XML.new
	
	echo "" >> $XML.new
	
	sed "s%tcp:\/\/localhost:37222%tcp:\/\/localhost:47222%" $XML.new > $XML.temp
	mv $XML.temp $XML.new
	
	sed "s%ssl:\/\/localhost:37243%ssl:\/\/localhost:47243%" $XML.new > $XML.temp
	mv $XML.temp $XML.new
	
	sed "s%tibjmsnaming:\/\/rmicrm58:37222%tibjmsnaming:\/\/crmsasXX:47222%" $XML.new > $XML.temp
	mv $XML.temp $XML.new
	
	sed "s%tcp:\/\/rmicrm58:37222%tcp:\/\/crmsasXX:47222%" $XML.new > $XML.temp
	mv $XML.temp $XML.new
	
	sed "s%jdbc:tibcosoftwareinc:oracle:\/\/crm-db-dev01:1530;ServiceName=esbdb;AlternateServers=(crm-db-dev02:1530,crm-db-dev03:1530)%jdbc:tibcosoftwareinc:oracle:\/\/crm-db-dev01:1530;ServiceName=esbdi;AlternateServers=(crm-db-dev02:1530,crm-db-dev03:1530)%" $XML.new > $XML.temp
	mv $XML.temp $XML.new
	
	sed "s%rmicrm58%crmsasXX%" $XML.new > $XML.temp
	mv $XML.temp $XML.new
	
	sed "s%10.8.101.82%10.8.101.XX%" $XML.new > $XML.temp
	mv $XML.temp $XML.new
	
	sed "s%crmdB%ESBDI%" $XML.new > $XML.temp
	mv $XML.temp $XML.new
	
	sed "s%rmicrm58.wind.root.it%crmsasXX.wind.root.it%" $XML.new > $XML.temp
	mv $XML.temp $XML.new
	
	sed "s%tcp:37502%tcp:47502%" $XML.new > $XML.temp
	mv $XML.temp $XML.new
	
	sed "s%37502%47502%" $XML.new > $XML.temp
	mv $XML.temp $XML.new
	
	sed "s%tcp:37474%tcp:47474%" $XML.new > $XML.temp
	mv $XML.temp $XML.new
	
	sed "s%37474%47474%" $XML.new > $XML.temp
	mv $XML.temp $XML
	
	rm -f $XML.new
		
done