#!/usr/bin/env bash

if [ $# -lt 2 ]; then
  echo "usage: ${0} <ORGANIZATION> <ENVIRONMENT>"
  exit 1
fi

ORGANIZATION=${1}
ENVIRONMENT=${2}
shift; shift
OTHER=${*}

if [ ${ORGANIZATION} == "Global" ]; then
  ansible-playbook config-controller.yml -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: ${ENVIRONMENT} }" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml ${OTHER}
else
  ansible-playbook config-controller.yml --skip-tags organizations -e "{orgs: ${ORGANIZATION}, dir_orgs_vars: orgs_vars, env: ${ENVIRONMENT} }" --vault-password-file ./.vault_pass.txt -e @orgs_vars/env/${ENVIRONMENT}/configure_connection_controller_credentials.yml ${OTHER}
fi

#  ansible-playbook config-controller.yml --tags organizations,credentials -e "{orgs: Global, dir_orgs_vars: orgs_vars, env: dev }" -e @orgs_vars/env/dev/configure_connection_controller_credentials.yml --vault-password-file ./.vault_pass.txt
