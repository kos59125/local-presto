#!/bin/bash

launcher start >/dev/null 2>&1

# wait until server is ready
while true
do
   if [ -e /opt/presto/data/var/log/server.log ]
   then
      grep -q "SERVER STARTED" /opt/presto/data/var/log/server.log
      if [ $? -eq 0 ]
      then
         break
      fi
   fi
done

presto --server localhost:8080 "$@"
