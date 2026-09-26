local target role_name become_opts
target="${args[target]}"
role_name="${args[role]}"

[ "$target" = "localhost" ] && become_opts="-K" || become_opts=""

echo "ansible-playbook -l ${target} -e role=${role_name} -b ${PLAYBOOK_DIR}/apply_role.yml ${become_opts}"
ansible-playbook -l "${target}" -e "role=${role_name}" -b "${PLAYBOOK_DIR}/apply_role.yml" ${become_opts}
