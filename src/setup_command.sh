# install uv (fast Python package manager) if not present
if ! command -v uv >/dev/null 2>&1; then
  # install via the official installer script
  curl -LsSf https://astral.sh/uv/install.sh | sh || pip install --user uv
fi

# clone or update the repo
if [ -d "$HOME/opensetup/.git" ]; then
  git -C "$HOME/opensetup" pull --ff-only
else
  git clone https://github.com/ppreeper/opensetup "$HOME/opensetup"
fi

cd "$HOME/opensetup"

# sync Python dependencies (ansible, ansible-lint, molecule, yamllint) into .venv
uv sync

# install Ansible collection dependencies
uv run ansible-galaxy collection install -r collections/requirements.yml

# enable direnv
if grep -q "direnv hook bash" $HOME/.bashrc; then
  echo
else
  echo 'eval "$(direnv hook bash)"' >> $HOME/.bashrc
fi

# reload bash
source $HOME/.bashrc