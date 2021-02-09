#!/bin/bash


FILE="access_log_20210128-185931.log"
ARG=$1


while read -ra arr; do
    #ip 
    if [ $ARG == 1 ]; then
        echo "${arr[0]}"
    #browser
    elif [ $ARG == 2 ]; then
        echo "${arr[-1]}"
    else
    #all
        echo "${arr[@]}"
    fi
done < "$FILE"
