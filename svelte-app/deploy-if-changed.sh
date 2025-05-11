#!/bin/sh

git fetch
UPSTREAM=$(1:-'@{u}')
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
        echo "$(date): no changes in git"
elif [ $LOCAL = $BASE ]; then
        echo "$(date): git changes detected, deploying"
        ./deploy.sh
elif [ $REMOTE = $BASE ]; then
        echo "$(date): LOCAL git changes detected, stashing then deploying"
        git stash
        ./deploy.sh
else
        echo "WARNING git is diverged. this is unexpected"
fi
