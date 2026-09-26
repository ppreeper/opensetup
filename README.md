# OpenSetup

Ansible-based sysadmin toolkit for deploying common software setups across hosts and clusters.

```
https://tinyurl.com/ppreeperopensetup
```

## Quick Start

```bash
# 1. Install uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# 2. Clone and enter repo
git clone https://github.com/ppreeper/opensetup
cd opensetup

# 3. Sync Python dependencies (ansible, ansible-lint, molecule, yamllint)
uv sync

# 4. Install Ansible collection dependencies
ansible-galaxy collection install -r collections/requirements.yml

# 5. Set up vault password
# If you have the vault password, create the file:
#   echo "your-vault-password" > .vault_pass
# Otherwise, generate a new one and re-encrypt the vault files:
#   openssl rand -base64 32 > .vault_pass
#   find inventory -name vault.yml -exec ansible-vault rekey --vault-password-file=.vault_pass {} +

# 6. Run a playbook locally
./opensetup play ping

# Or via raw ansible-playbook:
ansible-playbook -i inventory/ playbooks/ping.yml \
  --vault-password-file=.vault_pass
```

## CLI Usage

The `opensetup` script wraps common Ansible operations:

| Command | Description |
|---------|-------------|
| `opensetup play <playbook> [target]` | Run a playbook (`playbooks/<playbook>.yml`) |
| `opensetup role <role> [target]` | Run a single role via `apply_role.yml` |
| `opensetup syntax <playbook>` | Check playbook syntax |
| `opensetup ping [target]` | Ping hosts (default: all) |
| `opensetup setup` | Install system prerequisites |

Target defaults to `localhost`. For remote hosts, specify an inventory group or hostname.

### Examples

```bash
# Ping all hosts
opensetup ping

# Deploy desktop playbook locally
opensetup play desktop-lmde6

# Run a single role on a remote group
opensetup role baseline k3s

# Check syntax before running
opensetup syntax patroni
```

## Vault

Sensitive variables (database passwords, API keys) are stored in encrypted
`vault.yml` files under `inventory/group_vars/` and `inventory/host_vars/`.

**Vault password file**: `.vault_pass` (gitignored — not in repo)

The CLI passes `--vault-password-file=.vault_pass` automatically via
`ansible.cfg`. To run raw `ansible-playbook` commands:

```bash
ansible-playbook -i inventory/ playbooks/patroni.yml \
  --vault-password-file=.vault_pass
```

To edit a vault file:

```bash
ansible-vault edit --vault-password-file=.vault_pass inventory/group_vars/patroni/vault.yml
```

## Development

### Dependencies

Python packages are managed by `uv` and declared in `pyproject.toml`:

```bash
uv sync
```

Ansible collections are declared in `collections/requirements.yml`:

```bash
ansible-galaxy collection install -r collections/requirements.yml
```

### Rebuild CLI

The `opensetup` CLI is generated with [bashly](https://bashly.dannyb.co/):

```bash
make build
```

Source files live in `src/`. Edit those, then regenerate.

### Project Structure

```
opensetup/
├── opensetup              # CLI entry point (bashly-generated)
├── src/                   # CLI source files
│   ├── bashly.yml          # CLI definition
│   ├── play_command.sh
│   ├── role_command.sh
│   ├── ping_command.sh
│   ├── syntax_command.sh
│   └── setup_command.sh
├── ansible.cfg             # Ansible config
├── inventory/              # Host inventory (per-group dirs)
│   ├── all/hosts.yml
│   ├── patroni/hosts.yml
│   ├── k3s/hosts.yml
│   ├── group_vars/         # Group-level variables (vault + plain)
│   └── host_vars/          # Host-level variables (vault + plain)
├── playbooks/              # Ansible playbooks
│   ├── patroni.yml
│   ├── samba_primary.yml
│   └── roles/              # 176+ reusable roles
└── collections/            # Ansible collections
    └── requirements.yml
```

## Contributing

### Adding a role

```bash
mkdir -p playbooks/roles/<role_name>/{tasks,defaults,meta,templates,files}
```

- Put tasks in `tasks/main.yml`.
- Define default variables in `defaults/main.yml`.
- Use `import_role` in playbooks to compose.

### Role naming conventions

Prefix roles by category for discoverability:

| Prefix | Category |
|--------|----------|
| `db_*` | Databases (postgresql, mysql, sqlite) |
| `flatpak_*` | Flatpak applications |
| `cli_*` | CLI tools and utilities |
| `lang_*` | Language runtimes (go, python, java, js) |
| `media-*` | Media playback and editing |
| `k3s_*` | Kubernetes k3s cluster |
| `samba_*` | Samba/CIFS |
| `odas_*` | Odas/ODA platform roles |
| `hosts_*` | Host file management |
| `docker_*` | Docker engine |
| `fonts_*` | Font packages |
| `caddy_*` | Caddy web server |
| `postfix_*` | Postfix mail server |
| `dovecot_*` | Dovecot mail server |
| `pgpool2_*` | Pgpool2 management |

One-off role names (no prefix) are acceptable for simple, single-purpose roles.

### Secrets

Place encrypted variables in `inventory/{group_vars,host_vars}/<name>/vault.yml`.
Encrypt with:

```bash
ansible-vault encrypt --vault-password-file=.vault_pass inventory/group_vars/<name>/vault.yml
```

Edit with:

```bash
ansible-vault edit --vault-password-file=.vault_pass inventory/group_vars/<name>/vault.yml
```

### Testing with Molecule

Some roles include Molecule test scenarios. Run them with:

```bash
cd playbooks/roles/<role_name>
molecule test
```

See `playbooks/roles/baseline/molecule/default/` for an example scenario.
