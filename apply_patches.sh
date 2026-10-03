#!/bin/bash

PATCHES=$(ls -l patches/ | awk 'NR>1 {print $9}')

git checkout -B patches main

for patch in $PATCHES; do
    git pull patches/$patch --rebase --no-edit
done
