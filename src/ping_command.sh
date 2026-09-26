if [ -z "${args[target]}" ]; then
  uv run ansible all -m ping -v
else
  uv run ansible ${args[target]} -m ping -v
fi