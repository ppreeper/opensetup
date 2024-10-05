# install prereqs
sudo bash -c "apt update -y && apt install -y python3-full python3-venv direnv git && pip install pipenv"

# enable direnv
if grep -q "direnv hook bash" $HOME/.bashrc; then
  echo
else
  echo 'eval "$(direnv hook bash)"' >> $HOME/.bashrc
fi

# clone repo
git clone https://github.com/ppreeper/opensetup $HOME/opensetup

# reload bash
source $HOME/.bashrc
