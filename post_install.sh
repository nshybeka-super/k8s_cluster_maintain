#!/bin/bash
# This script runs post-installation tasks necessary for this project.
# For instance, it installs Ansible collections and roles.

# Setting the path for local installation of Ansible collections within the project
export ANSIBLE_COLLECTIONS_PATH=$(pwd)/collections


export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"

# Installing required Ansible collections and roles based on the defined requirements file
ansible-galaxy collection install -r ansible-requirements.yml --force
