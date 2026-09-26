local target playbook become_opts
target="${args[target]}"
playbook="${args[playbook]}"

[ "$target" = "localhost" ] && become_opts="-K" || become_opts=""

echo "uv run ansible-playbook -l ${target} -b ${PLAYBOOK_DIR}/${playbook}.yml ${become_opts}"
uv run ansible-playbook -l "${target}" -b "${PLAYBOOK_DIR}/${playbook}.yml" ${become_opts}