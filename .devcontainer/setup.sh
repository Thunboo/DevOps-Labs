#!/bin/bash
set -x
echo "source /home/vscode/.venv/ansible-dev/bin/activate" >> ~/.bashrc
echo "cd /workspace/ansible" >> ~/.bashrc
source ~/.bashrc
ansible-galaxy collection install --force /workspace/collections/*.tar.gz /workspace/thunboo/postgresql_deploy 2>/dev/null
pip install "molecule-plugins[docker]"
# docker image inspect centos9_systemd || docker build -t centos9_systemd /workspace/thunboo/postgresql_deploy/roles/thunboo_postgres/molecule/default/docker_files
# docker network inspect molecule_test_net || docker network create --subnet=100.10.10.0/24 molecule_test_net
