local target playbook become_opts
target="${args[target]}"
playbook="${args[playbook]}"

[ "$target" = "localhost" ] && become_opts="-K" || become_opts=""

echo "ansible-playbook -l ${target} -b ${PLAYBOOK_DIR}/${playbook}.yml ${become_opts}"
ansible-playbook -l "${target}" -b "${PLAYBOOK_DIR}/${playbook}.yml" ${become_opts}