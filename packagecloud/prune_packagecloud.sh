#!/bin/bash

# Source the packagecloud token
source ${HOME}/.bash_profile

# Array of strings for package name and range of versions to prune. Fill in manually.
# Range is inclusive of the low limit, exclusive of the high limit.
# Values must be comma delimited. Ensure there is no white space in the array elements.
# Use any number of '#' for the generic version number. '####' is fine.
prune_package=(
    # 'generic_package_name,low_version_limit,high_version_limit'
    # 'app1-1.0.0-####.x86_64.rpm,359,481'
)

# Delete packages
for package_string in ${prune_package[@]}; do
    generic_package_name=$(echo $package_string | cut -d',' -f1)
    low_version_limit=$(echo $package_string | cut -d',' -f2)
    high_version_limit=$(echo $package_string | cut -d',' -f3)
    name_prefix=$(echo $generic_package_name | cut -d'#' -f1)
    name_suffix=${generic_package_name##*#}

    for version in $(seq $((high_version_limit-1)) -1 $low_version_limit); do
        package_name="${name_prefix}${version}${name_suffix}" 
        echo "Pruning $package_name"
        ## Limit output to one line, either error or done.
        ## Comment out "| grep ..." to see entire output for each yank. 
        package_cloud yank vericity/rpm/el/7 $package_name | grep 'error\|done' 
    done

done

