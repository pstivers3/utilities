#!/bin/bash

# Source the packagecloud token
source ${HOME}/.bash_profile

# set the source_dir to the directory that contains files to be pushed to packageclod.
scp_target_dir=$HOME/devops/yum.server.packages/

# Fill in the array with the list of packages that you want to push.
# Wildcards are allowed. For example 'jdk*.rpm'
scp_package=(
    'heka-0_10_0-linux-amd64.rpm'
    'http-parser-2.7.1-3.el7.x86_64.rpm'
    'jdk*.rpm'
    'logstash-2.3.4-1.noarch.rpm'
    'pgdg-redhat96-9.6-3.noarch.rpm'
    'python2*.rpm'
    'rbenv*.rpm'
    'tomcat*.rpm'
)

for package in ${scp_package[@]}; do
    package_cloud push vericity/rpm/el/7 ${scp_target_dir}/$package 
done

