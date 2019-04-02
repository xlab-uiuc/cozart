#!/bin/bash
itr=1
reqcnt=5000

source benchmark-scripts/general-helper.sh
source benchmark-scripts/docker-helper.sh
mount_fs
randomd
enable_network
mark_start
rm -rf /run/docker* /var/run/docker*
docker_start
sleep 5;
docker system prune --all --force;
docker run -dit --name my-redis-app -p 6379:6379 redis:4.0
redis-cli FLUSHALL
for i in `seq $itr`; do
    redis-benchmark -n $reqcnt -t SET,GET --csv
done
docker stop my-redis-app
write_modules
mark_end

