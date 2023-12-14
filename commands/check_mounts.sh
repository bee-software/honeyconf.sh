#!/bin/sh
list_all_containers() {
    docker ps --format '{{.Names}}'
}

list_mounts() {
    local container=$1
    docker inspect -f '{{ .Mounts }}' $container | sed 's#bind#\n#g' | awk '{ print $1 "«»" $2 }' | grep -v '\['
}

compare_mount() {
    local container=$1
    local host_mountpoint=$2
    local container_mountpoint=$3

    host_inode=$(stat -c %i $host_mountpoint)
    container_inode=$(docker exec $container stat -c %i $container_mountpoint)
    if [ "$host_inode" -ne "$container_inode" ]; then
        echo "❌ $container - $host_mountpoint on $container_mountpoint Inconsistent mountpoint!"
    else
        echo "✅ $container - $host_mountpoint on $container_mountpoint"
    fi
}

for container in $(list_all_containers); do
    for mount in $(list_mounts $container); do
	mounts=$(echo $mount | sed 's#«»# #g')
	compare_mount $container $mounts
    done
done
