#!/bin/bash

our_hosts=(localhost)

for i in "${our_hosts[@]}"; do
    ping -c 3 "$i"; exit_code=$?
    if [ $exit_code -gt 0 ]; then
        exit $exit_code
    fi
done