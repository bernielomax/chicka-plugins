#!/bin/bash

USAGE="Usage: stringmatch.sh <file-path> <match-string> <threshold>"

FILE=$1
if [ "${FILE}" == "" ]
then
    echo "No file parameter passed."
    echo ${USAGE}
    exit 1
fi

MATCH=$2
if [ "${MATCH}" == "" ]
then
    echo "No match parameter passed."
    echo ${USAGE}
    exit 1
fi

THRESHOLD=$3
if [ "${THRESHOLD}" == "" ]
then
    echo "No threshold parameter passed."
    echo ${USAGE}
    exit 1
fi

RESULT=true

FOUND=$(grep -o ${MATCH} ${FILE} | wc -l |awk '{print $1}')

if [ ${FOUND} -gt ${THRESHOLD} ]
then
    RESULT=false
fi

echo "{\"result\": ${RESULT}, \"data\": ${FOUND}, \"description\": \"no more than ${THRESHOLD} occurences of string '${MATCH}' in '${FILE}'\", \"expect\": true}"
