#!/bin/bash


FILE="$1"
while read -ra arr; do
    echo "----------------------"
    echo "Lastname: ${arr[1]}"
    echo "Firstname: ${arr[0]}"
    echo "CC: ${arr[3]:0:5}*************"
    echo "----------------------"
done < "$FILE"
