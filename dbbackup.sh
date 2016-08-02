#!/bin/sh
ID=`docker-compose ps -q |head -1`
IP=`docker inspect -f "{{.NetworkSettings.IPAddress}}" $ID`    

if [ $# -lt 1 ];then
  mysqldump -ummuser -pmostest -h$IP -P3306 mattermost_test
  #--all-databases
else
 echo "Restore data" 1>&2
 mysql -ummuser -pmostest -h$IP -P3306
 #mattermost_test
fi
 
