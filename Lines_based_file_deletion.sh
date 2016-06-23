#!/bin/bash

MINLINES="$1"
FILE="$2"
if [ -z "$MINLINES" ]
then
	echo "Need to enter min number of lines to be present in files for deleting \$MINLINES"

else

       NUMLINES=$(wc -l "${FILE}" | cut -f 1 -d " ")
       if [[ "${NUMLINES}" -le "${MINLINES}" ]];
       then
              rm -f ${FILE} ${FILE}.idx
       fi

fi
