FROM docker:29-cli AS docker-cli

FROM quay.io/centos/centos:stream9

COPY --from=docker-cli /usr/local/bin/docker /usr/local/bin/docker

RUN dnf install -y \
        glibc-langpack-en \
        sudo \
        vim \
        tree \
        rsync \
        python3.11 \
        python3.11-pip \
        python3.11-devel \
        python3-libselinux \
        bash-completion \
        gcc \
        openssl-devel \
        openssh-clients && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Create non-root user for VS Code remote session
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    chown -R vscode:vscode /home/vscode && \
    usermod -aG root vscode

COPY <<EOF /usr/local/bin/devcontainer-setup
#!/bin/bash
set -x
echo "source /home/vscode/.venv/ansible-dev/bin/activate" >> /home/vscode/.bashrc
# setup bash autocomplete in cli
echo "source /etc/profile.d/bash_completion.sh" >> /home/vscode/.bashrc
echo "cd /workspace/ansible" >> /home/vscode/.bashrc

source /home/vscode/.bashrc
# ansible-galaxy collection install --force /workspace/collections/*.tar.gz /workspace/thunboo/postgresql_deploy 2>/dev/null
pip install "molecule-plugins[docker]"
EOF
RUN chmod 755 /usr/local/bin/devcontainer-setup

# Set up python virtual environment for development purposes
USER vscode
WORKDIR /home/vscode
RUN python3.11 -m venv /home/vscode/.venv/ansible-dev --system-site-packages && \
    . /home/vscode/.venv/ansible-dev/bin/activate && \
    pip install --upgrade pip && \
    pip3 install ansible-dev-tools psycopg2-binary

# For some reason - Running it here causes venv name to be duplicated in terminal. so it was moved out to portCreate script for devcontainer
# It kinda breaks a logic of container being simple and usefull to be ran for using ansible, but for now it will be it (27.07.2026)
# I will try to find a work-around, cause obviously - it is just wrong now, that it's not working outside of devcontainer 
#RUN echo 'source /home/vscode/.venv/ansible-dev/bin/activate' >> /home/vscode/.bashrc
