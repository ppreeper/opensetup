#!/bin/bash
sudo apt update
sudo apt install -y python3-pip python3-venv direnv git && pip install pipenv
echo 'eval "$(direnv hook bash)"' >> $HOME/.bashrc
git clone https://github.com/ppreeper/ansible_installer
source $HOME/.bashrc