#!/bin/bash

num_masters=$1
num_workers=$2 
echo "# Hosts file for Kubernetes cluster" > ./hosts
echo "" >> hosts
echo "# Master nodes" >> ./hosts

for ((i=1;i<=$num_masters;i++))
do
    ip_address="192.168.17.$((200+i))"
    echo "$ip_address kubentes-master$i" >> ./hosts
done

echo "" >> ./hosts
echo "# Worker nodes" >> ./hosts

for ((i=1;i<=$num_workers;i++))
do
    ip_address="192.168.17.$((100+i))"
    echo "$ip_address kubentes-worker$i" >> ./hosts
done
