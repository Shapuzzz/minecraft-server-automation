# Minecraft Server Automation

## Background

For this project, I automated the deployment and configuration of a Minecraft server on AWS using Terraform and Ansible. The goal was to create a process that can set up the required AWS resources and configure the Minecraft server without having to manually create resources through the AWS Management Console.

Terraform is used to create the AWS infrastructure, including the EC2 instance and security group. Once the instance is created, Ansible is used to connect to the server and perform the configuration tasks. These tasks include installing Java, creating the Minecraft directory, downloading the Minecraft server, and accepting the Minecraft EULA.

The final result is a Minecraft server running on AWS that can be accessed using its public IP address. Nmap can be used to verify that the Minecraft service is running and listening on port 25565.

---

## Requirements

Before running this project, make sure the following software is installed on your computer:

* AWS CLI v2
* Terraform v1.12 or newer
* Ansible Core 2.21 or newer
* Nmap 7.99 or newer
* Git

You will also need:

* An AWS Academy Learner Lab account
* AWS credentials from Learner Lab
* An SSH key pair

This project was tested on macOS. Windows users can run the same commands using PowerShell, Git Bash, or WSL.

---

## AWS Setup

Before Terraform can create resources in AWS, AWS credentials need to be configured.

1. Start the AWS Academy Learner Lab.
2. Wait for the lab status to become active.
3. Click **AWS Details**.
4. Open the **AWS CLI** tab.
5. Copy the credentials provided by AWS Academy.

Run the following command:

```bash
aws configure
```

When prompted, enter:

```text
AWS Access Key ID
AWS Secret Access Key
Default region name: us-east-1
Default output format: json
```

After configuring AWS, export the session token:

```bash
export AWS_SESSION_TOKEN='YOUR_SESSION_TOKEN'
```

To verify that AWS is configured correctly, run:

```bash
aws sts get-caller-identity
```

If everything is working correctly, AWS will return information about your account.

---

## Project Structure

The repository is organized into separate folders for Terraform and Ansible.

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

Terraform files are located in the terraform directory, while the Ansible inventory and playbook are located in the ansible directory.

---

## Pipeline Overview

The project follows the steps below:

1. Terraform initializes the AWS provider.
2. Terraform creates the security group.
3. Terraform creates the EC2 instance.
4. Terraform outputs the public IP address of the instance.
5. The inventory file is updated with the new IP address.
6. Ansible connects to the EC2 instance using SSH.
7. Ansible installs Java.
8. Ansible creates the Minecraft directory.
9. Ansible downloads the Minecraft server.
10. Ansible accepts the Minecraft EULA.
11. Nmap verifies that port 25565 is reachable.

The diagram below shows how the different components interact.

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

---

## Running the Project

All commands below are run from a local terminal.

### Step 1: Clone the Repository

Clone the GitHub repository and move into the project directory.

```bash
git clone https://github.com/Shapuzzz/minecraft-server-automation.git
cd minecraft-server-automation
```

### Step 2: Initialize Terraform

Initialize Terraform and download the AWS provider.

```bash
terraform -chdir=terraform init
```

If successful, Terraform will display a message indicating that initialization completed successfully.

### Step 3: Create AWS Resources

Run Terraform to create the EC2 instance and security group.

```bash
terraform -chdir=terraform apply
```

Terraform will display a summary of the resources that will be created.

Type:

```text
yes
```

when prompted.

After Terraform finishes, it will display the public IP address of the EC2 instance.

Example:

```text
public_ip = "3.87.106.181"
```

The IP address will be different each time a new instance is created.

### Step 4: Update the Inventory File

If needed, the public IP address can be displayed again by running:

```bash
terraform -chdir=terraform output
```

Open the inventory file:

```bash
nano ansible/inventory.ini
```

Replace the existing IP address with the new public IP address returned by Terraform.

Example:

```ini
[minecraft]
3.87.106.181 ansible_user=ec2-user ansible_ssh_private_key_file=~/Downloads/labsuser.pem
```

Save the file and exit.

### Step 5: Configure the Minecraft Server

Run the Ansible playbook.

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory.ini ansible/minecraft.yml
```

The playbook will:

* Install Java
* Create the Minecraft directory
* Download the Minecraft server
* Accept the Minecraft EULA

When the playbook finishes successfully, the output should end with something similar to:

```text
ok=5
failed=0
```

### Step 6: Verify the Server

Use Nmap to verify that the Minecraft service is reachable.

```bash
nmap -sV -Pn -p T:25565 <public-ip>
```

Example:

```bash
nmap -sV -Pn -p T:25565 3.87.106.181
```

If the Minecraft server is running correctly, the output should look similar to:

```text
25565/tcp open minecraft
```

---

## Connecting to the Minecraft Server

Once the server is running, open Minecraft Java Edition.

Select **Multiplayer** and connect using the public IP address of the EC2 instance.

Example:

```text
3.87.106.181:25565
```

Your IP address will be different depending on the instance that Terraform creates.

---

## Cleanup

When finished, remove all AWS resources to avoid unnecessary charges.

Run:

```bash
terraform -chdir=terraform destroy
```

Type:

```text
yes
```

when prompted.

Terraform will remove the EC2 instance and security group that were created earlier.

---

## Sources

The following resources were used while completing this project:

* https://developer.hashicorp.com/terraform
* https://docs.ansible.com
* https://docs.aws.amazon.com
* https://nmap.org
* https://www.minecraft.net
