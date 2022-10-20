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

`pip3 install "ansible[azure]"` (in venv preferably)

Then go to Azure website and generate a new resource group.
Try to generate az command for that

Then execute command:

```bash
az ad sp create-for-rbac --name <some_random_name>  \
                         --role Contributor \
                         --scopes /subscriptions/<subscription-ID>/resourceGroups/<resource-group-name>
```
to get the password. Other stuff can be fethced with  `az account list`.


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

## Clear all pip packages

`pip freeze | xargs pip uninstall -y`
