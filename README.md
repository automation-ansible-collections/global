AWX / Ansible Automation Platform CasC
==========================================

The collection will handle the creation and management of the AAP objetcs. Also, one of the main features, is that the owner of the AAP Organization can ensure that only the objects existing in the SCM will be at AAP.

AAP Workflow CasC
----------
![Alt text](AAP_CasC.png?raw=true "AAP Workflow CasC")

AAP Controller Workflow CasC
----------
![Alt text](AAP_CasC_Worflow.png?raw=true "AAP Controller Workflow CasC")

Requirements
------------

This role is tested on Ansible >=2.9.

Dependencies
-------------
Collection needed are included int the requirements.yml file.

$ cat requirements.yml
---
collections:
  - name: ansible.controller
  - name: ansible.utils
  - name: ansible.posix
  - name: community.general
  - name: casc.aap_controller

Dependencies install
--------------------
```bash

$ ansible-galaxy collection install -r collections/requirements.yml -p collections/
```

Encrypted variables
-------------------

Variables related to Ansible Automation Controller connection (AAP) or credentials to be use through AAP, it's strongly recommended to be encrypted. Files to encrypt should be the following:

```bash
- Orgs/global/orgs_vars/env/${ENVIRONMENT}
└── configure_connection_controller_credentials.yml

- Orgs/global/orgs_vars/Global/env/${ENVIRONMENT}
└── configure_controller_credentials.yml
```


```bash
cat < EOF > orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
---
vault_controller_username: "admin"
vault_controller_password: "redhat00"
EOF
```

Encrypted with vault

```bash
ansible-vault create  orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-vault encrypt orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-vault edit orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
```

Playbooks:
----------

- `config-controller.yml`

```bash
$ ansible-playbook config-controller.yml --tags credentials,                -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags groups,                     -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags hosts,                      -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags inventories,                -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags inventory_source,           -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags job_templates,              -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags organizations,              -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags projects,                   -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags roles,                      -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags settings,                   -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags teams,                      -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags users,                      -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags workflow_job_templates      -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags workflow_job_template_nodes -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
$ ansible-playbook config-controller.yml --tags desired_state -e '{orgs: "Organization_Acme", dir_orgs_vars: orgs_vars}' --ask-vault-pass
```

Variables
----------
Variables Must be set in yaml files with follow structure:

```bash
{{ dir_orgs_vars }}/{{ orgs }}/configure_{{ controller }}_{{ entity }}.yml
```
Vars files example:
```
/home/ansible/Orgs/organization1/orgs_vars/
├── controller_settings
├── env
│   ├── common
│   │   └── configure_controller_organizations.yml
│   ├── dev
│   │   └── configure_connection_controller_credentials.yml
│   └── prod
│       └── configure_connection_controller_credentials.yml
└── Organization1
    └── env
        ├── common
        │   ├── configure_controller_credential_types.yml
        │   ├── configure_controller_execution_environments.yml
        │   ├── configure_controller_groups.yml
        │   ├── configure_controller_instance_groups.yml
        │   ├── configure_controller_inventories.yml
        │   ├── configure_controller_job_templates.yml
        │   ├── configure_controller_local_users.yml
        │   ├── configure_controller_projects.yml
        │   ├── configure_controller_roles.yml
        │   ├── configure_controller_schedules.yml
        │   ├── configure_controller_teams.yml
        │   ├── configure_controller_workflow_job_templates.yml
        │   └── workflow_nodes
        ├── dev
        │   ├── configure_controller_credentials.yml
        │   ├── configure_controller_hosts.yml
        │   └── configure_controller_inventory_source.yml
        └── prod
            ├── configure_controller_credentials.yml
            ├── configure_controller_hosts.yml
            └── configure_controller_inventory_source.yml
```

Git configuration to diff vaulted files
=========

If you want to diff vaulted files, you must name them with the pattern `*_credentials.yml` configure some thing into your local git configuration.

Content to be added to your local config file for git `${HOME}/.gitconfig` (alias section is not required):
```ini
[diff "ansible-vault"]
  textconv = ansible-vault view
[merge "ansible-vault"]
  driver = ./ansible-vault-merge %O %A %B %L %P
  name = Ansible Vault merge driver
[alias]
lg1 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all
lg2 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all
lg = !"git lg1"
```

Already provided files:

- `${REPO_ROOT}/.gitattributes`:
  > ```
  > *_credentials.yml filter=ansible-vault diff=ansible-vault merge=binary
  > ```

- `${REPO_ROOT}/ansible-vault-merge`:
  > ```bash
  > #!/usr/bin/env bash
  > set -e
  >
  > ancestor_version=$1
  > current_version=$2
  > other_version=$3
  > conflict_marker_size=$4
  > merged_result_pathname=$5
  >
  > ancestor_tempfile=$(mktemp tmp.XXXXXXXXXX)
  > current_tempfile=$(mktemp tmp.XXXXXXXXXX)
  > other_tempfile=$(mktemp tmp.XXXXXXXXXX)
  >
  > delete_tempfiles() {
  >     rm -f "$ancestor_tempfile" "$current_tempfile" "$other_tempfile"
  > }
  > trap delete_tempfiles EXIT
  >
  > ansible-vault decrypt --output "$ancestor_tempfile" "$ancestor_version"
  > ansible-vault decrypt --output "$current_tempfile" "$current_version"
  > ansible-vault decrypt --output "$other_tempfile" "$other_version"
  >
  > git merge-file "$current_tempfile" "$ancestor_tempfile" "$other_tempfile"
  >
  > ansible-vault encrypt --output "$current_version" "$current_tempfile"
  > ```

Finally, and to simplify your life, you can create the file `${REPO_ROOT}/.vault_password` containing the vault password and configure your `ansible.cfg` like follows:
```ini
vault_password_file = ./.vault_password
```
This way, the `git diff` command will not ask for the vault password multiple times.

License
-------

GPLv3

Author Information
------------------
- silvinux - silvio@redhat.com
- iaragone - iaragone@redhat.com


ToDo
----
- Change file extension from YML to YAML
