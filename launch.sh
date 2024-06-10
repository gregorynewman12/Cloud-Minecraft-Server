#!/bin/bash

# Initialize Terraform
terraform init

# Apply Terraform configuration and get the output
terraform apply

# Assign environment variable through a subshell
# (Uses IP output by Terraform)
IP=$(terraform output -raw instance_public_ip)

echo "[ec2_instance]" > hosts.ini
echo "$IP ansible_user=ec2-user ansible_ssh_private_key_file=[PATH TO YOUR KEY FILE HERE]" >> hosts.ini

echo "Pausing to allow server to finish initializing..."
echo "5.."
sleep 1
echo "4..."
sleep 1
echo "3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
echo "Running Ansible Playbook:"
sleep 1

# Use IP of new EC2 instance in Ansible
ansible-playbook -i hosts.ini setup.yml
