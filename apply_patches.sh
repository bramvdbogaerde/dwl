#!/bin/bash

PATCHES=$(ls -l patches/ | awk 'NR>1 {print $9}')
LOCAL_PATCHES=$(git for-each-ref --format='%(refname:short)' refs/heads/patch/)

# apply_patch <repository> <branch, optional>
apply_patch() {
    if ! git -c rerere.enabled=true -c rerere.autoUpdate=true \
            pull "$@" --no-rebase --no-edit; then
        # rerere staged its resolutions; finish the merge if nothing is left
        if [ -z "$(git diff --name-only --diff-filter=U)" ]; then
            git commit --no-edit
        else
            echo "unresolved conflicts from $*; resolve and commit, then rerun"
            exit 1
        fi
    fi
}

git checkout -B patches main

for patch in $PATCHES; do
    apply_patch patches/$patch
done

for patch in $LOCAL_PATCHES; do
    apply_patch . $patch
done
