#!/bin/ksh

DATAFILES="/fsTibcoESB/tibcoesb/products/tibcobw/tra/domain/${DOMAIN_NAME}/datafiles"
LOCAL_PATH="/sbTibco/tibcoesb/adm_script/scripts"
#echo "$DATAFILES"




#exit


for dir in $(ls ${DATAFILES}) ; do
	DIRECTORY=${dir}
	ENGINE=$(echo ${dir} | sed 's/_root//g')
	DIRECTORY="esb2etg_root"
	ENGINE="esb2etg"
	rm -f ${LOCAL_PATH}/.temp_gv
	find ${DATAFILES}/${DIRECTORY} -type f -name "*.process" > ${LOCAL_PATH}/lista_process.txt
	while read -r file ; do
		CHECK=$(grep -i "_configData" "${file}")
		if [[ ! -z "${CHECK}" ]] ; then
			### ESCLUDE CHIAMATE INTERNE ###
			INTERNE=$(grep -i "bwGetCfgHostPort" "${file}")
			if [[ -z "${INTERNE}" ]] ; then
				#echo "[${ENGINE}]"
				### SCELTA TIPO PARSING ###
				PARSING=$(grep -i "variable name=\"setHostAndPort\"" "${file}")
				if [[ -z "${PARSING}" ]] ; then
					#echo "$file: Parsing semplice"
					echo "$file" > ${LOCAL_PATH}/filename.txt
					sed 's/\//\/\//g' ${LOCAL_PATH}/filename.txt > ${LOCAL_PATH}/new.txt
					rm -f ${LOCAL_PATH}/filename.txt
					PERCORSO_FILE=$(cat ${LOCAL_PATH}/new.txt)
					rm -f ${LOCAL_PATH}/new.txt
					java -jar ${LOCAL_PATH}/parser.jar "${PERCORSO_FILE}"
				else
					echo "$file: Parsing avanzato"
				fi
			fi
		fi
		
	done < ${LOCAL_PATH}/lista_process.txt
	rm -f ${LOCAL_PATH}/lista_process.txt
done




exit
