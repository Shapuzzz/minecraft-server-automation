# Minecraft Server Automation

## Background

This project automates the deployment and configuration of a Minecraft server on AWS. The goal is to provision all infrastructure and configure the server without manually using the AWS Management Console.

Terraform is used to create AWS resources such as the EC2 instance and security group. Ansible is used to configure the server, install Java, download Minecraft, accept the EULA, and configure the service to start automatically when the server boots.

The final result is a fully automated pipeline that creates and configures a working Minecraft server that can be verified using Nmap.

---

## Requirements

The following software must be installed:

* AWS CLI v2
* Terraform v1.12+
* Ansible Core 2.21+
* Nmap 7.99+
* Git

The user must also have:

* An AWS Academy Learner Lab account
* AWS credentials
* An SSH key pair

---

## AWS Configuration

Start the AWS Academy Learner Lab and open AWS Details.

Export the provided credentials into your terminal:

```bash
export AWS_ACCESS_KEY_ID=<access_key>
export AWS_SECRET_ACCESS_KEY=<secret_key>
export AWS_SESSION_TOKEN=<session_token>
```

Verify that AWS CLI access is working:

```bash
aws sts get-caller-identity
```

---

## Pipeline Overview

The automation pipeline performs the following steps:

1. Terraform initializes the AWS provider.
2. Terraform creates a security group.
3. Terraform creates an EC2 instance.
4. Terraform outputs the public IP address.
5. Ansible connects to the EC2 instance using SSH.
6. Ansible installs Java.
7. Ansible creates the Minecraft server directory.
8. Ansible downloads the Minecraft server.
9. Ansible accepts the Minecraft EULA.
10. Ansible configures the Minecraft service.
11. Systemd automatically manages the Minecraft service.
12. Nmap verifies that port 25565 is open.

---

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
TCP Port 25565
```

---

## Repository Structure

```text
minecraft-server-automation/
├── ansible/
│   ├── inventory.ini
│   └── minecraft.yml
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── .terraform.lock.hcl
├── README.md
└── .gitignore
```

---

## Running the Project

### Step 1: Initialize Terraform

```bash
terraform -chdir=terraform init
```

This downloads the AWS provider and prepares Terraform.

### Step 2: Deploy Infrastructure

```bash
terraform -chdir=terraform apply
```

Terraform creates the EC2 instance and security group.

After completion, Terraform outputs the public IP address.

### Step 3: Configure the Server

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory.ini ansible/minecraft.yml
```

Ansible installs Java, downloads Minecraft, accepts the EULA, and configures the service.

### Step 4: Verify the Server

```bash
nmap -sV -Pn -p T:25565 <public-ip>
```

Expected output:

```text
25565/tcp open minecraft
```

---

## Minecraft Service Management

The Minecraft server is managed using systemd.

Benefits include:

* Automatically starts after reboot
* Automatically restarts if the service crashes
* Supports clean shutdowns
* Can be managed using standard Linux service commands

Example commands:

```bash
sudo systemctl status minecraft
sudo systemctl restart minecraft
sudo systemctl stop minecraft
```

---

## Connecting to Minecraft

Open Minecraft Java Edition.

Select Multiplayer and connect using:

```text
<public-ip>:25565
```

Example:

```text
18.207.164.8:25565
```

---

## Cleanup

Destroy all AWS resources when finished:

```bash
terraform -chdir=terraform destroy
```

This removes the EC2 instance and security group.

---

## Sources

* https://developer.hashicorp.com/terraform
* https://docs.ansible.com
* https://docs.aws.amazon.com
* https://nmap.org
* https://www.minecraft.net
