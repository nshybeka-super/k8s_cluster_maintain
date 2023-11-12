#!/bin/bash

# Generates a hosts file for a Kubernetes cluster based on the specified number of master and worker nodes

num_masters=$1
num_workers=$2

if [ ! -d "./ansible_playbooks/files" ]; then
    echo "./ansible_playbooks/files directory does not exists..."
    mkdir -p "./ansible_playbooks/files"
    echo "Create ./ansible_playbooks/files."
fi

echo "# Hosts file for Kubernetes cluster" >./ansible_playbooks/files/hosts
echo "" >>./ansible_playbooks/files/hosts
echo "# Master nodes" >>./ansible_playbooks/files/hosts

for ((i = 1; i <= $num_masters; i++)); do
    ip_address="192.168.17.$((200 + i))"
    echo "$ip_address kubentes-master$i" >>./ansible_playbooks/files/hosts
done

echo "" >>./ansible_playbooks/files/hosts
echo "# Worker nodes" >>./ansible_playbooks/files/hosts

for ((i = 1; i <= $num_workers; i++)); do
    ip_address="192.168.17.$((100 + i))"
    echo "$ip_address kubentes-worker$i" >>./ansible_playbooks/files/hosts
done
