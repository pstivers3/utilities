#!/bin/bash

# set the scp_target_dir to the directory where you want the files to be SCPed.
scp_target_dir=$HOME/devops/yum.server.packages/

# Fill in the array with the list of packages that you want to download.
# Wildcards are allowed. For example 'jdk*.rpm'
scp_package=(
    'app1.rpm'
    'app2.rpm'
    'jdk*.rpm'
    'python2*.rpm'
    'rbenv*.rpm'
    'tomcat*.rpm'
)

for package in ${scp_package[@]}; do
    scp root@yum-server.net:/var/repo/rpms/$package $scp_target_dir
done

