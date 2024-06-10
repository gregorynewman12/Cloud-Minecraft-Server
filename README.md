# Cloud Minecraft Server Documentation

**Gregory Newman, Chief Cloud Systems Information Technology Network Cybersecurity Architect and Administrator**<br/>

## Background

This document will provide instructions on how to host a Minecraft Server on an AWS EC2 instance, with its configuration and launch fully-automated through Terraform and Ansible. Terraform will be used to provision the AWS EC2 resource, and Ansible will execute a script on the new instance that will install Docker, pull the Minecraft server image, and launch it.

Both the Terraform and Ansible scripts are executed through a single Bash script: `launch.sh`

## 1. Getting Started

1. Install Terraform, following specific instructions for your desired operating system: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

2. Install Ansible, using the instructions for your operating system: https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-debian

3. Open the credentials file in a text editor and fill in your AWS credentials. Depending on how you access AWS, you may also need to add an `aws_session_key` item in addition to the `aws_access_key_id` and `aws_secret_access_key`.

4. Create an SSH key pair using a method of your choosing. For example, in a Bash shell, use the command `ssh-keygen -t rsa -b 4096`. You should now have a private key with no extension and a public key with the extension .pub in your current directory. Note this location for the next steps.

5. Open the `main.tf` file in a text editor. On line 19, fill in the correct path to your .pub public SSH key file.

6. Open the main script, launch.sh, in a text editor, locate the line that reads `echo "$IP ansible_user=ec2-user ansible_ssh_private_key_file=[PATH TO YOUR KEY FILE HERE]" >> hosts.ini` and fill in the path to your private SSH key file that corresponds to the public one used earlier (by default, the private key will have NO suffix).

7. Our configuration is now completed, and the script is ready to run. Finally, make sure it has the correct permissions and is executable. On Linux: `sudo chmod 777 ./launch.sh`

## 2. Running the Script

To run the script, simply enter `./launch.sh` into your terminal. You will be prompted to enter "yes" by the Terraform script. Once the script is completed, the Minecraft server is running on an EC2 instance. Its public IP address can be verified by looking through the script's output. It is displayed as one of the outputs from the Terraform script and after every Ansible command.

You can connect to the server for play at `[EC2-PUBLIC-IP]:25565` (Port 25565 on the EC2 instance).

## 3. Steps in the Pipeline

These are the steps the automated script follows to launch and configure the Minecraft server:

_Terraform is initialized_

_Terraform script begins_

_Terraform launches EC2
instance with provided
AWS credentials_

_EC2 instance completes
launch_

_Public IP of EC2 is output
by Terraform, and is
printed to the hosts.ini
file that is used by
Ansible along with SSH
credentials_

_Ansible script launches
and connects through SSH
to EC2 instance_

_Ansible installs Docker_

_Ansible starts and enables
Docker_

_Ansible pulls Minecraft
server Docker image_

_Ansible runs Minecraft
server container with port
25565 exposed, and sets
restart policy to unless-
stopped so it will always
run_
