# Minecraft Server Automation

## Background

The goal of this project is to automate the deployment and setup of a Minecraft server on AWS using Terraform and Ansible.

Terraform is used to create the AWS resources, including the EC2 instance and security group. Ansible is used to connect to the EC2 instance, install Java, create the Minecraft folder, download the Minecraft server, and accept the EULA.

All commands in this tutorial are run from a local terminal. Terraform and Ansible handle the communication with AWS automatically.

After everything is finished, the Minecraft server can be verified using Nmap.

---

## Requirements

Install the following tools:

* AWS CLI
* Terraform
* Ansible
* Nmap
* Git

You will also need:

* AWS Academy Learner Lab
* AWS credentials
* An SSH key pair

---

## AWS Setup

1. Start the AWS Academy Learner Lab.
2. Wait for the lab to become active.
3. Click **AWS Details**.
4. Open the **AWS CLI** tab.
5. Copy the credentials.

Configure AWS:

```bash
aws configure
```

Enter:

```text
AWS Access Key ID
AWS Secret Access Key
Default region name: us-east-1
Default output format: json
```

Export the session token:

```bash
export AWS_SESSION_TOKEN='YOUR_SESSION_TOKEN'
```

Check that AWS is working:

```bash
aws sts get-caller-identity
```

---

## Architecture

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

## Project Files

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

### Clone the Repository

```bash
git clone https://github.com/Shapuzzz/minecraft-server-automation.git
cd minecraft-server-automation
```

### Initialize Terraform

```bash
terraform -chdir=terraform init
```

This downloads the required Terraform providers.

### Create AWS Resources

```bash
terraform -chdir=terraform apply
```

Type:

```text
yes
```

when prompted.

Terraform will create the EC2 instance and security group.

After it finishes, Terraform will display the public IP address.

Example:

```text
public_ip = "3.87.106.181"
```

Your IP address will be different.

### Update the Inventory File

Check the public IP again if needed:

```bash
terraform -chdir=terraform output
```

Edit the inventory file:

```bash
nano ansible/inventory.ini
```

Replace the IP address with the one returned by Terraform.

Example:

```ini
[minecraft]
3.87.106.181 ansible_user=ec2-user ansible_ssh_private_key_file=~/Downloads/labsuser.pem
```

Save the file and continue.

### Run Ansible

```bash
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory.ini ansible/minecraft.yml
```

This installs Java, creates the Minecraft folder, downloads the server, and accepts the EULA.

If successful, the output should end with something similar to:

```text
ok=5
failed=0
```

### Verify the Server

Run:

```bash
nmap -sV -Pn -p T:25565 <public-ip>
```

Example:

```bash
nmap -sV -Pn -p T:25565 3.87.106.181
```

Expected output:

```text
25565/tcp open minecraft
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
3.87.106.181:25565
```

---

## Cleanup

When finished, remove all AWS resources:

```bash
terraform -chdir=terraform destroy
```

Type:

```text
yes
```

when prompted.

This removes the EC2 instance and security group.

---

## Sources

* https://developer.hashicorp.com/terraform
* https://docs.ansible.com
* https://docs.aws.amazon.com
* https://nmap.org
* https://www.minecraft.net
