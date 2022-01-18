Satellite Deploy
=========

Ansible playbook to install and config a satellite server and its capsules.

Requirements
------------

This role is tested on Ansible 2.9.

Dependencies
------------
N/A

Encrypted variables
----------------
All encrypted variabled should be placed at `{{ orgs_dir }}/configure_foreman_katello_credentials.yml`

```bash
cat < EOF > orgs_vars/configure_foreman_katello_credentials.yml
---
vault_foreman_admin_username: "admin"
vault_foreman_admin_password: "redhat00"
vault_rhn_user: redhat-support-active-account
vault_rhn_pwd: p4$$W0rD
vault_rhn_pool_id: 01123581321245589144233377610987
vault_ldap_account_password: redhat00
EOF
```
Encrypted with vault

```bash
ansible-vault create orgs_vars/configure_foreman_katello_credentials.yml
ansible-vault encrypt orgs_vars/configure_foreman_katello_credentials.yml
ansible-vault edit orgs_vars/configure_foreman_katello_credentials.yml
```

Playbooks:
-----------------

- `playbooks/prerequisites.yml`.
  > The variables needed are:
  > ```bash
  >   - "{{ dir_orgs_vars }}/configure_foreman_katello_credentials.yml"
  >   - "{{ dir_orgs_vars }}/configure_foreman_katello_general.yml"
  >   - "{{ dir_orgs_vars }}/configure_{{ scenario }}_prerequisites.yml"
  > ```

- `playbooks/config-idm.yml`
  > ```bash
  >   $ ansible-playbook playbooks/config-idm.yml --tags ipa_hostgroup -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars}'
  > ```
  > 
  > ```bash
  > $ ansible-playbook -i inventories/inventory -l satelliteServers playbooks/prerequisites.yml              --tags repos,update,packages,copy_files,lvm       -e '{dir_orgs_vars: ../orgs_vars, orgs: gbs, scenario: satellite}'
  > $ ansible-playbook -i inventories/inventory -l capsuleServers playbooks/prerequisites.yml                --tags repos,selinux,firewall,update,packages,lvm -e '{dir_orgs_vars: ../orgs_vars, orgs: gbs, scenario: capsule}'
  > $ ansible-playbook -i inventories/inventory -l satcapsule2.bcnconsulting.com playbooks/prerequisites.yml --tags repos,selinux,firewall,update,packages,lvm -e '{dir_orgs_vars: ../orgs_vars, orgs: gbs, scenario: capsule}'
  > ```

- `playbooks/install-satellite.yml`
  > ```bash
  > $ ansible-playbook -i inventories/inventory -l satelliteServers playbooks/install-satellite.yml --tags gather_facts,install_satellite,hammer -e '{satellite_version: 6.8, satellite_fqdn: satellite.bcnconsulting.com, orgs: gbs, dir_orgs_vars: ../orgs_vars, scenario: satellite, location: BCN}'
  > ```

- `playbooks/install-capsule.yml`
  > ```bash
  > $ ansible-playbook -i inventories/inventory playbooks/install-capsule.yml --tags gather_facts,certificate_bundle,install_capsule -e '{satellite_version: 6.8, satellite_fqdn: satellite.bcnconsulting.com, orgs: gbs, dir_orgs_vars: ../orgs_vars, scenario: capsule}'
  > ```

- `playbooks/install-monitoring.yml`
  > ```bash
  > $ ansible-playbook -i inventories/inventory -l satellite.bcnconsulting.com playbooks/install-monitoring.yml --tags pcp_packages,pcp_data_collection
  > ```

- `playbooks/config-satellite.yml`
  > ```bash
  > $ ansible-playbook playbooks/config-satellite.yml --tags settings           -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, satellite_fqdn: xcpcvidas904.es.onpremise.bancsabadell.com}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-satellite.yml --tags organizations      -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, satellite_fqdn: xcpcvidas904.es.onpremise.bancsabadell.com}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-satellite.yml --tags locations          -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, satellite_fqdn: xcpcvidas904.es.onpremise.bancsabadell.com}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-satellite.yml --tags ldap               -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, satellite_fqdn: xcpcvidas904.es.onpremise.bancsabadell.com}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-satellite.yml --tags manifest           -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, satellite_fqdn: xcpcvidas904.es.onpremise.bancsabadell.com}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-satellite.yml --tags external_usegroups -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, satellite_fqdn: xcpcvidas904.es.onpremise.bancsabadell.com}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-satellite.yml --tags lifecycles         -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, satellite_fqdn: xcpcvidas904.es.onpremise.bancsabadell.com}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-satellite.yml --tags repositories       -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, satellite_fqdn: xcpcvidas904.es.onpremise.bancsabadell.com}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-satellite.yml --tags sync_plans         -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, satellite_fqdn: xcpcvidas904.es.onpremise.bancsabadell.com}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-satellite.yml --tags content_views      -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, satellite_fqdn: xcpcvidas904.es.onpremise.bancsabadell.com}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-satellite.yml --tags activation_keys    -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, satellite_fqdn: xcpcvidas904.es.onpremise.bancsabadell.com}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-satellite.yml --tags host_collections   -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, satellite_fqdn: xcpcvidas904.es.onpremise.bancsabadell.com}' --ask-vault-pass
  > ```

- `playbooks/config-tower.yml`
  > ```bash
  > $ ansible-playbook playbooks/config-tower.yml --tags credentials,                -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags groups,                     -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags hosts,                      -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags inventories,                -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags inventory_source,           -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags job_templates,              -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags ldap,                       -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags list_jobs,                  -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags organizations,              -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags projects,                   -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags roles,                      -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags settings,                   -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags teams,                      -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags users,                      -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags workflow_job_templates      -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > $ ansible-playbook playbooks/config-tower.yml --tags workflow_job_template_nodes -e '{orgs: "OR-AL-TO-O-SGOP-DEF-COF-[SEGURIDAD OPERATIVA]", dir_orgs_vars: ../orgs_vars}' --ask-vault-pass
  > ```

- `playbooks/create-sshkeys.yml`. The needed variables follows:
  > ```bash
  >   - {{ dir_orgs_vars }}/configure_satellite_ssh_keys.yml
  >   - {{ dir_orgs_vars }}/{{ orgs }}/configure_tower_credentials.yml
  >   - {{ dir_orgs_vars }}/{{ orgs }}/configure_sshkeys_remote_users.yml
  >   - {{ dir_orgs_vars }}/{{ orgs }}/configure_sshkeys_from_at_ssh_public_keys.yml
  >   - {{ dir_orgs_vars }}/{{ orgs }}/configure_sshkeys_saved_keys.yml
  > ```

Playbook's example execution:
----------------------------
```bash
$ ansible-playbook -i inventories/inventory playbooks/renew-sshkeys.yml --tags creation                   -e '{dir_orgs_vars: ../orgs_vars, orgs: gbs}' # By default, no new keys are created
$ ansible-playbook -i inventories/inventory playbooks/renew-sshkeys.yml --tags creation                   -e '{dir_orgs_vars: ../orgs_vars, orgs: gbs, create_new_keys: true}'
$ ansible-playbook -i inventories/inventory playbooks/renew-sshkeys.yml --tags install_pubs_to_idm        -e '{dir_orgs_vars: ../orgs_vars, orgs: gbs}'
$ ansible-playbook -i inventories/inventory playbooks/renew-sshkeys.yml --tags distribute                 -e '{dir_orgs_vars: ../orgs_vars, orgs: gbs}'
$ ansible-playbook -i inventories/inventory playbooks/renew-sshkeys.yml --tags install_priv_to_tower      -e '{dir_orgs_vars: ../orgs_vars, orgs: gbs}'
$ ansible-playbook -i inventories/inventory playbooks/renew-sshkeys.yml --tags install_priv_to_satellite  -e '{dir_orgs_vars: ../orgs_vars, orgs: gbs}'
```

Content Views PUBLISH
---------------------
Content views will be published on Library environment, this way could be promoted by any other environment. By default, Content Views will be purged except last 3 published. It can be changed with the variable "content_views_purge_count".

##### Publish BY cvtype: [os, app,infra] AND cvname: [os_release, app_name, redhat_product]

```bash
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: publish, cvtype: os, cvname: rhel7, env: Library, content_views_purge_count: 6}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: publish, cvtype: app, cvname: jws, env: Library, content_views_purge_count: 6}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: publish, cvtype: infra, cvname: satcapsules, env: Library, content_views_purge_count: 6}'
```

##### Publish BY cvtype: [os, app,infra] AND cvname: [ALL]
```bash
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: publish, cvtype: os, cvname: all, env: Library, content_views_purge_count: 6}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: publish, cvtype: app, cvname: all, env: Library, content_views_purge_count: 6}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: publish, cvtype: infra, cvname: all, env: Library, content_views_purge_count: 6}'
```

Compositive Content Views PUBLISH
---------------------------------
##### Publish BY cvtype: [ccv] AND cvname: [ALL]
```bash
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: publish, cvtype: ccv, cvname: all, env: Library, content_views_purge_count: 6}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: publish, cvtype: ccv, cvname: all, env: Library, content_views_purge_count: 6}'
```

Content Views PROMOTE
---------------------
##### Promote BY env: [InfraTest,InfraProd] AND cvtype: [os,infra] AND cvname: [ALL]
```bash
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../..orgs_vars, cvaction: promote, cvtype: os, cvname: all, env: all}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: os, cvname: all, env: InfraTest}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: os, cvname: all, env: InfraProd}'

$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: infra, cvname: all, env: InfraTest}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: infra, cvname: all, env: InfraProd}'
```

##### Promote BY env: [Development,UAT,Integration,Preproduction,Production] AND cvtype: [os,app] AND cvname: [ALL]
```bash
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: os, cvname: all, env: Development}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: os, cvname: all, env: UAT}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: os, cvname: all, env: Integration}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: os, cvname: all, env: Preproduction}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: os, cvname: all, env: Production}'

$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: app, cvname: all, env: Development}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: app, cvname: all, env: UAT}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: app, cvname: all, env: Integration}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: app, cvname: all, env: Preproduction}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: app, cvname: all, env: Production}'
```

Compositive Content Views PROMOTE
---------------------------------
##### Promote BY env: [InfraTest,InfraProd,Development,UAT,Integration,Preproduction,Production] AND cvtype: [app,infra] AND cvname: [ALL]
```bash
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: ccv, cvname: infra, env: InfraTest}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: ccv, cvname: infra, env: InfraProd}'

$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: ccv, cvname: app, env: Development}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: ccv, cvname: app, env: UAT}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: ccv, cvname: app, env: Integration}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: ccv, cvname: app, env: Preproduction}'
$ ansible-playbook playbooks/config-satellite.yml --tags cv_publish_promote -e '{orgs: gbs, dir_orgs_vars: ../orgs_vars, cvaction: promote, cvtype: ccv, cvname: app, env: Production}'
```

Variables
----------
Variables Must be set in yaml files with follow structure:

```bash
{{ dir_orgs_vars }}/{{ orgs }}/configure_{{ foreman/katello }}_{{ entity }}.yml
```
Vars files example:
```
orgs_vars/
├── configure_capsule_alc1_deployment.yml
├── configure_capsule_prerequisites.yml
├── configure_foreman_katello_credentials.yml
├── configure_foreman_katello_general.yml
├── configure_satellite_prerequisites.yml
├── configure_satellite_pri_deployment.yml
└── gbs
    ├── configure_foreman_external_usergroup.yml
    ├── configure_foreman_ldap.yml
    ├── configure_foreman_locations.yml
    ├── configure_foreman_organization.yml
    ├── configure_foreman_settings.yml
    ├── configure_katello_activation_keys.yml
    ├── configure_katello_host_collections.yml
    ├── configure_katello_lifecycle_environments.yml
    ├── configure_katello_repositories.yml
    ├── configure_katello_sync_plans.yml
    └── cv
        ├── configure_katello_content_views.yml
        ├── promote
        │   ├── app
        │   │   ├── configure_katello_cv_versions_promote_app_all_Development.yml
        │   │   ├── configure_katello_cv_versions_promote_app_all_Integration.yml
        │   │   ├── configure_katello_cv_versions_promote_app_all_Preproduction.yml
        │   │   ├── configure_katello_cv_versions_promote_app_all_Production.yml
        │   │   └── configure_katello_cv_versions_promote_app_all_UAT.yml
        │   ├── ccv
        │   │   ├── configure_katello_cv_versions_promote_ccv_app_Development.yml
        │   │   ├── configure_katello_cv_versions_promote_ccv_app_Integration.yml
        │   │   ├── configure_katello_cv_versions_promote_ccv_app_Preproduction.yml
        │   │   ├── configure_katello_cv_versions_promote_ccv_app_Production.yml
        │   │   ├── configure_katello_cv_versions_promote_ccv_app_UAT.yml
        │   │   ├── configure_katello_cv_versions_promote_ccv_infra_InfraProd.yml
        │   │   └── configure_katello_cv_versions_promote_ccv_infra_InfraTest.yml
        │   ├── infra
        │   │   ├── configure_katello_cv_versions_promote_infra_all_InfraProd.yml
        │   │   └── configure_katello_cv_versions_promote_infra_all_InfraTest.yml
        │   └── os
        │       ├── configure_katello_cv_versions_promote_os_all_Development.yml
        │       ├── configure_katello_cv_versions_promote_os_all_InfraProd.yml
        │       ├── configure_katello_cv_versions_promote_os_all_InfraTest.yml
        │       ├── configure_katello_cv_versions_promote_os_all_Integration.yml
        │       ├── configure_katello_cv_versions_promote_os_all_Preproduction.yml
        │       ├── configure_katello_cv_versions_promote_os_all_Production.yml
        │       └── configure_katello_cv_versions_promote_os_all_UAT.yml
        └── publish
            ├── app
            │   ├── configure_katello_cv_versions_publish_app_all_all.yml
            │   ├── configure_katello_cv_versions_publish_app_all_Library.yml
            │   └── configure_katello_cv_versions_publish_app_jws_Library.yml
            ├── ccv
            │   ├── configure_katello_cv_versions_publish_ccv_all_all.yml
            │   ├── configure_katello_cv_versions_publish_ccv_jws_all.yml
            │   ├── configure_katello_cv_versions_publish_ccv_jws_Library.yml
            │   ├── configure_katello_cv_versions_publish_ccv_sat6-capsule_all.yml
            │   └── configure_katello_cv_versions_publish_ccv_sat6-capsule_Library.yml
            ├── infra
            │   ├── configure_katello_cv_versions_publish_infra_all_all.yml
            │   ├── configure_katello_cv_versions_publish_infra_all_Library.yml
            │   └── configure_katello_cv_versions_publish_infra_sat6-capsules_Library.yml
            └── os
                ├── configure_katello_cv_versions_publish_os_all_all.yml
                ├── configure_katello_cv_versions_publish_os_all_Library.yml
                └── configure_katello_cv_versions_publish_os_rhel7_Library.yml
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
silvinux - silvio@redhat.com

iaragone - iaragone@redhat.com

