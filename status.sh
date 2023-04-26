#! /bin/bash

# list of services (add or remove as desired)
service=(
    service1 
    service2
    nginx
)

# report the status of service
for service in ${service[@]}; do
   status=$(systemctl is-active "$service")
   if [ $status != 'active' ]; then
      status="${status} !!"
   fi 
   printf "%-25s %s \n" "${service}:" "$status"
done

