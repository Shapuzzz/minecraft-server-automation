# Minecraft Server Automation

## Background

This project automates the deployment of a Minecraft server on AWS using Terraform and Ansible. Terraform is used to provision the infrastructure, including the EC2 instance and networking configuration. Ansible is used to configure the server, install Java, download the Minecraft server, and configure the service to start automatically.

## Requirements

The following software is required:

* AWS CLI
* Terraform
* Ansible
* Nmap
* Git

The user must configure AWS credentials before running Terraform.

Example:

```bash
export AWS_ACCESS_KEY_ID=<access_key>
export AWS_SECRET_ACCESS_KEY=<secret_key>
export AWS_SESSION_TOKEN=<session_token>
```

## Pipeline Overview

1. Terraform creates AWS resources.
2. Terraform creates the EC2 instance.
3. Terraform configures networking and security groups.
4. Ansible installs Java.
5. Ansible downloads the Minecraft server.
6. Ansible configures the Minecraft service.
7. The server starts automatically after reboot.

## Architecture

Local Machine

↓

Terraform

↓

AWS EC2 Instance

↓

Ansible

↓

Minecraft Server

↓

TCP Port 25565

## Commands

Initialize Terraform:

```bash
terraform init
```

Deploy infrastructure:

```bash
terraform apply
```

Run Ansible:

```bash
ansible-playbook -i inventory.ini minecraft.yml
```

Verify the server:

```bash
nmap -sV -Pn -p T:25565 <public-ip>
```

## Connecting to Minecraft

Open Minecraft and connect using the EC2 public IP address.

Example:

```text
54.xxx.xxx.xxx:25565
```

## Cleanup

Destroy all AWS resources:

```bash
terraform destroy
```

## Resources

https://developer.hashicorp.com/terraform

https://docs.ansible.com

https://aws.amazon.com

https://www.minecraft.net

## Architecture Diagram

```text
Local Machine
      |
      v
Terraform
      |
      v
AWS EC2 Instance
      |
      v
Ansible
      |
      v
Minecraft Server
      |
      v
Port 25565
```

## Resources

Terraform Documentation:
https://developer.hashicorp.com/terraform

Ansible Documentation:
https://docs.ansible.com

AWS Documentation:
https://aws.amazon.com

Minecraft Documentation:
https://www.minecraft.net
