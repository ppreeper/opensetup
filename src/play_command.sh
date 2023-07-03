[ "${args[target]}" = "localhost" ] && export BECOME="-K" || export BECOME=""
echo ansible-playbook -l ${args[target]} -b ${PLAYBOOK_DIR}/${args[playbook]}.yml $BECOME
ansible-playbook -l ${args[target]} -b ${PLAYBOOK_DIR}/${args[playbook]}.yml $BECOME