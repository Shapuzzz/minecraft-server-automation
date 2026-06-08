#!/bin/bash

terraform init
terraform apply -auto-approve

ansible-playbook -i inventory.ini minecraft.yml
