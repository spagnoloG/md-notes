# Ansible

### Errors:

#### E1:

If you get error like that:

```bash
TASK [Gathering Facts] **************************************************************************************************************************************************************
fatal: [localhost]: FAILED! => {"ansible_facts": {}, "changed": false, "failed_modules": {"ansible.legacy.setup": {"ansible_facts": {"discovered_interpreter_python": "/usr/bin/python3"}, "failed": true, "module_stderr": "sudo: a password is required\n", "module_stdout": "", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 1}}, "msg": "The following modules failed to execute: ansible.legacy.setup\n"}
```

then issue this command: `ln -s /usr/bin/python3 /usr/bin/python`.

## Setup azure

`sudo apt install azure-cli`

`python3 -m venv ~/.venv-azure`

`source ~/.venv-azure/bin/activate`

`ansible-galaxy collection install azure.azcollection`

So becouse i could not set it up properly, this is is my `requirements.txt`:

```python
adal==1.2.7
ansible==6.5.0
ansible-core==2.13.5
applicationinsights==0.11.10
argcomplete==1.12.3
azure-cli-core==2.34.0
azure-cli-telemetry==1.0.6
azure-common==1.1.11
azure-core==1.26.0
azure-graphrbac==0.61.1
azure-identity==1.7.0
azure-keyvault==1.0.0a1
azure-mgmt-apimanagement==0.2.0
azure-mgmt-authorization==0.51.1
azure-mgmt-automation==1.0.0
azure-mgmt-batch==5.0.1
azure-mgmt-cdn==3.0.0
azure-mgmt-compute==26.1.0
azure-mgmt-containerinstance==1.4.0
azure-mgmt-containerregistry==2.0.0
azure-mgmt-containerservice==9.1.0
azure-mgmt-core==1.3.2
azure-mgmt-cosmosdb==0.15.0
azure-mgmt-datafactory==2.0.0
azure-mgmt-datalake-nspkg==2.0.0
azure-mgmt-datalake-store==0.5.0
azure-mgmt-devtestlabs==3.0.0
azure-mgmt-dns==2.1.0
azure-mgmt-eventhub==2.0.0
azure-mgmt-hdinsight==0.1.0
azure-mgmt-iothub==0.7.0
azure-mgmt-keyvault==1.1.0
azure-mgmt-loganalytics==1.0.0
azure-mgmt-managedservices==1.0.0
azure-mgmt-managementgroups==0.2.0
azure-mgmt-marketplaceordering==0.1.0
azure-mgmt-monitor==3.0.0
azure-mgmt-network==19.1.0
azure-mgmt-notificationhubs==2.0.0
azure-mgmt-nspkg==2.0.0
azure-mgmt-privatedns==0.1.0
azure-mgmt-rdbms==1.9.0
azure-mgmt-recoveryservices==0.4.0
azure-mgmt-recoveryservicesbackup==0.6.0
azure-mgmt-redis==13.0.0
azure-mgmt-resource==10.2.0
azure-mgmt-search==3.0.0
azure-mgmt-servicebus==0.5.3
azure-mgmt-sql==3.0.1
azure-mgmt-storage==19.0.0
azure-mgmt-trafficmanager==0.50.0
azure-mgmt-web==0.41.0
azure-nspkg==2.0.0
azure-storage==0.35.1
bcrypt==4.0.1
certifi==2022.9.24
cffi==1.15.1
charset-normalizer==2.1.1
cryptography==38.0.1
humanfriendly==10.0
idna==3.4
isodate==0.6.1
Jinja2==3.1.2
jmespath==1.0.1
knack==0.9.0
MarkupSafe==2.1.1
msal==1.20.0
msal-extensions==0.3.1
msrest==0.6.21
msrestazure==0.6.4
oauthlib==3.2.2
packaging==21.3
paramiko==2.11.0
pkginfo==1.8.3
portalocker==1.7.1
psutil==5.9.3
pycparser==2.21
Pygments==2.13.0
PyJWT==2.6.0
PyNaCl==1.5.0
pyOpenSSL==22.1.0
pyparsing==3.0.9
PySocks==1.7.1
python-dateutil==2.8.2
PyYAML==6.0
requests==2.28.1
requests-oauthlib==1.3.1
resolvelib==0.8.1
six==1.16.0
tabulate==0.9.0
typing_extensions==4.4.0
urllib3==1.26.12
xmltodict==0.13.0
```

so then just run `pip3 install -r requirements.txt` and you should be ready to rock!

Then go to Azure website and generate a new resource group.
Try to generate az command for that

Then execute command:

```bash
az ad sp create-for-rbac --name <some_random_name>  \
                         --role Contributor \
                         --scopes /subscriptions/<subscription-ID>/resourceGroups/<resource-group-name>
```

to get the password. Other stuff can be fethced with `az account list`.

Now write these creds into file:
`$HOME/.azure/credentials`

like so:

```
[default]
subscription_id= (when you create group)
client_id= (appId in az ad)
secret= (az ad sp password)
tenant= (tennantId in both)
```

Or just use my bash script to set `env` variables:

```bash
#!/bin/sh

# Set those variables
RESOURCE_GROUP_NAME="ansible_terraform_rg"
RESOURCE_GROUP_LOCATION="francecentral"
ROLE_NAME="test"

main() {

  printf "Creating %s resource group\n" $RESOURCE_GROUP_NAME

  C1=$(az group create --name $RESOURCE_GROUP_NAME --location  $RESOURCE_GROUP_LOCATION)
  SCOPE=$(echo $C1 | jq '.id'| sed 's/"//g')
  echo $C1 | jq

  printf "Creating %s countributor in %s resource group\n" $ROLE_NAME $RESOURCE_GROUP_NAME

  C2=$(az ad sp create-for-rbac --name $ROLE_NAME  \
                          --role Contributor \
                          --scopes $SCOPE )


echo $C2 | jq

  AZURE_CLIENT_ID=$(echo $C2 | jq '.appId' | sed 's/"//g')
  AZURE_TENANT_ID=$(echo $C2 | jq '.tenant' | sed 's/"//g')
  AZURE_CLIENT_SECRET=$(echo $C2 | jq '.password' | sed 's/^\"//;s/\"$//')
  AZURE_SUBSCRIPTION_ID=$(echo $SCOPE | awk -F/ '{ print $3 }')

  # Ansible
  export AZURE_CLIENT_ID
  export AZURE_TENANT_ID
  export AZURE_CLIENT_SECRET
  export AZURE_SUBSCRIPTION_ID

  # Terraform
  export TF_VAR_subscription_id=$AZURE_SUBSCRIPTION_ID
  export TF_VAR_client_id=$AZURE_CLIENT_ID
  export TF_VAR_client_secret=$AZURE_CLIENT_SECRET
  export TF_VAR_tenant_id=$AZURE_TENANT_ID


  printf 'Environmental variables set! \n'
}

main
```

## Clear all pip packages

`pip freeze | xargs pip uninstall -y`

## Simple inventory with ssh private key

```yaml
---
all:
  main:
    vars:
      ansible_connection: ssh
      ansible_become: yes
      ansible_become_method: sudo
    hosts:
      ssh_host_with_key:
        ansible_host: ml-node
        ansible_ssh_user: ml-node
        ansible_ssh_private_key_file: /home/spagnologasper/.ssh/keys/id_ed25519_ml-node
```

list hosts in inventory file:

```bash
λ ansible all --list-hosts -i inventory.yml
  hosts (8):
    hsrv
    ml-node
    nextcloud-node
    jellyfin-node
    prism-node
    transmission-node
    ass-node
    adguard-node
```
