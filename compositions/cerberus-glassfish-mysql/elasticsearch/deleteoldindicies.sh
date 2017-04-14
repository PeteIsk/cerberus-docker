#!/bin/bash
echo "starting"
#regex to find and extract the date from the index name which is of the standard logstash-YYYY.MM.DD
regex="-([0-9][0-9][0-9][0-9].[0-9][0-9].[0-9][0-9])$"
ELASTICSEARCH="elasticsearch"
LOGFILE="cleanindex.log"
DELETEIDICIESOLDERTHAN=3

#Get a list of the indicies that match the grep that we have n elasticsearch
INDICES_TEXT=`curl -s "http://$ELASTICSEARCH:9200/_cat/indices"`

declare -a INDEX_LIST=($INDICES_TEXT):q

echo "`date` Found ${#INDEX_LIST[@]} indicies" >> $LOGFILE

for index in ${INDEX_LIST[@]};do
        #does the index name match the housekeep standard?
    if [[ $index =~ $regex ]]
    then
        echo "`date` Found $index " >> $LOGFILE
        index_name_date="${BASH_REMATCH[1]//.}" #get the date and remove the . from yyyy.mm.dd to get the right format ( yyyymmdd) for the following command
        age_in_days=$((($(date +%s) -  $(date --date=$index_name_date +%s))/(60*60*24) ))
        echo "`date` Is $age_in_days days old" >> $LOGFILE
        #is it old enough to delete
        if [[ $age_in_days -gt DELETEIDICIESOLDERTHAN ]]
        then
            echo "`date` Deleting $index " >> $LOGFILE
            curl -s -XDELETE "http://$ELASTICSEARCH:9200/$index/"
        fi
    fi
done
