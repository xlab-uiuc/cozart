#!/bin/bash
itr=1
reqcnt=5000

source benchmark-scripts/general-helper.sh
mount_fs
enable_network;
mark_start;
# cleanup
rm -rf /var/lib/cassandra/commitlog/*
rm -rf /var/lib/cassandra/data/*
rm -rf /var/lib/cassandra/saved_caches/*
rm -rf /var/log/cassandra/*

cassandra -R &> /cassandra.log
until nodetool status; do
    printf ".";
    sleep 1;
done
cassandra-stress write n=$reqcnt -node localhost -rate threads=4
for i in `seq $itr`; do
    cassandra-stress mixed n=$reqcnt -node localhost -rate threads=4
done

write_modules
mark_end;
