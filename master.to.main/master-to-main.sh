#! /bin/bash

remote1_name=$(git remote -v | sed -n 1p | awk '{ print $1 }')
remote1_url=$(git remote -v | sed -n 1p | awk '{ print $2 }')
remote2_name=$(git remote -v | sed -n 3p | awk '{ print $1 }')
remote2_url=$(git remote -v | sed -n 3p | awk '{ print $2 }')

echo "remotes are:"
echo "$remote1_name $remote1_url"
echo "$remote2_name $remote2_url"

master_branch=$(git branch | grep master)
if [ -z "$master_branch" ]; then
    echo -e "master branch not found\nexiting"
    exit 1
else
    echo "master branch found"
fi

function master_to_main {
    echo -e "\n## change default branch from master to main on $remote1_name"
    echo "git branch -m master main"
    git branch -m master main
    echo "git push -u $remote1_name main"
    git push -u $remote1_name main
    # if there's a second remote
    if [ ! -z "$remote2_name" ]; then
       echo "## change default branch from master to main on $remote2_name"
       echo "git push -u $remote2_name main"
       # use the URL from remote2 fetch because remove2 (upstream) push may include "do-not-push" or similar
       git push -u $remote2_url main
    fi

    echo -e "\n## update local clone"
    echo "git checkout -b  master --track ${remote1_name}/master"
    git checkout -b  master --track ${remote1_name}/master
    echo "git fetch"
    git fetch
    echo "git branch --unset-upstream"
    git branch --unset-upstream
    echo "git branch -u ${remote1_name}/main"
    git branch -u ${remote1_name}/main
    echo "git symbolic-ref refs/remotes/${remote1_name}/HEAD refs/remotes/${remote1_name}/main"
    git symbolic-ref refs/remotes/${remote1_name}/HEAD refs/remotes/${remote1_name}/main

    echo -e "\n## delete local master"
    echo "git checkout main"
    git checkout main
    echo "git branch -d master"
    git branch -d master

    echo -e "\n## DONE"
}

read -p "do you want to proceed to move/rename master to main? y/n " answer
case $answer in
    [Yy]* ) master_to_main;;
    [Nn]* ) echo "exiting"; exit;;
     * ) echo "Please answer y or n.";;
esac

