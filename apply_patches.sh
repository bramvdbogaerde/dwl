#!/bin/bash

PATCHES=$(ls -l patches/ | awk 'NR>1 {print $9}')

git checkout -B patches main

for patch in $PATCHES; do
    if ! git -c rerere.enabled=true -c rerere.autoUpdate=true \
            pull patches/$patch --no-rebase --no-edit; then
        # rerere staged its resolutions; finish the merge if nothing is left
        if [ -z "$(git diff --name-only --diff-filter=U)" ]; then
            git commit --no-edit
        else
            echo "unresolved conflicts from $patch; resolve and commit, then rerun"
            exit 1
        fi
    fi
done
