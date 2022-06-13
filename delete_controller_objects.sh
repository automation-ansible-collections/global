#!/usr/bin/env bash

if [ $# -ne 2 ]; then
  echo "usage: ${0} <ORGANIZATION> <ENVIRONMENT>"
  exit 1
fi

ORGANIZATION=${1}
ENVIRONMENT=${2}

ansible-playbook config-controller.yml --tags workflow_job_templates -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: '${ENVIRONMENT}', controller_state: absent}" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-playbook config-controller.yml --tags job_templates -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: '${ENVIRONMENT}', controller_state: absent}" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-playbook config-controller.yml --tags execution_environments -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: '${ENVIRONMENT}', controller_state: absent}" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-playbook config-controller.yml --tags projects -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: '${ENVIRONMENT}', controller_state: absent}" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-playbook config-controller.yml --tags credentials -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: '${ENVIRONMENT}', controller_state: absent}" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-playbook config-controller.yml --tags groups -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: '${ENVIRONMENT}', controller_state: absent}" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-playbook config-controller.yml --tags hosts -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: '${ENVIRONMENT}', controller_state: absent}" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-playbook config-controller.yml --tags inventory_source -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: '${ENVIRONMENT}', controller_state: absent}" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-playbook config-controller.yml --tags teams -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: '${ENVIRONMENT}', controller_state: absent}" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-playbook config-controller.yml --tags local_users -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: '${ENVIRONMENT}', controller_state: absent}" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-playbook config-controller.yml --tags credential_types -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: '${ENVIRONMENT}', controller_state: absent}" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
ansible-playbook config-controller.yml --tags organizations -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: '${ENVIRONMENT}', controller_state: absent}" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml
