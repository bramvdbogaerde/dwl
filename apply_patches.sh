#!/bin/bash

PATCHES=$(ls -l patches/ | awk 'NR>1 {print $9}')

for patch in $PATCHES; do
    git pull patches/$patch --rebase
done

