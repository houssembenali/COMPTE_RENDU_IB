#!/bin/bash
set -e



#Create group ressource
az group create --name grs-tp1-houssem --location eastus

#Create VM
az vm create --resource-group grs-tp1-houssem \
  --name vm-tp1-houssem \
  --image UbuntuLTS \
  --generate-ssh-keys \ 
  --output json \
  --verbose 

#Sleep while VM construction
sleep 45

#get public IP addresse
VM_PUBLIC_IP=$(az vm show -d --name vm-tp1-houssem \
  --resource-group grs-tp1-houssem \
  --query 'publicIps' \
  --output tsv)

#Open VM Port 80
az vm open-port \
    --port 80 \
    --resource-group tp1-medchan \
    --name vm-tp1-houssem

#install requirement in VM
chmod +x install-requirement.sh

az vm run-command invoke  --command-id RunShellScript --name vm-tp1-houssem -g grs-tp1-houssem
    --scripts @install-requirement.sh
