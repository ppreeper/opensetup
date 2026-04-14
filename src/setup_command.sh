# install prereqs
sudo bash -c "apt update -y && apt install -y python3-full python3-venv curl direnv git ansible ansible-lint yamllint"

# install uv (fast Python package manager) if not present
if ! command -v uv >/dev/null 2>&1; then
  # install via the official installer script
  curl -LsSf https://astral.sh/uv/install.sh | sh || pip install --user uv
fi

# compile and sync dependencies using uv
if [ -f requirements.in ]; then
  uv pip compile requirements.in --universal --output-file requirements.txt || true
  uv pip sync requirements.txt || true
fi

# enable direnv
if grep -q "direnv hook bash" $HOME/.bashrc; then
  echo
else
  echo 'eval "$(direnv hook bash)"' >> $HOME/.bashrc
fi

# clone repo
rm -rf $HOME/opensetup
git clone https://github.com/ppreeper/opensetup $HOME/opensetup

# reload bash
source $HOME/.bashrc
