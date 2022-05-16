#!/bin/bash

eval "$(ssh-agent -s)"

# add ssh keys
mkdir -p /vscode/ssh
echo -e "${ED25519_PRIVATE}" > /vscode/ssh/id_ed25519
echo -e "${ED25519_PUBLIC}" > /vscode/ssh/id_ed25519.pub
chmod -R 400 /vscode/ssh/

# adds ssh key to agent
ssh-add /vscode/ssh/id_ed25519

# lists added keys
ssh-add -l

# congifures ssh to avoid host hash checks
mkdir -p ~/.ssh
# echo "Host *" > ~/.ssh/config
echo " StrictHostKeyChecking no" >> ~/.ssh/config

# tests connection to bitbucket
ssh -T git@$GIT_HOSTNAME

# setup git
git config --global user.name $GIT_USERNAME
git config --global user.email $GIT_EMAIL

# update password to config
sed -i \
    -e "s#^password.*#password: ${CODER_PASSWORD}#" \
    /vscode/config.yaml

# allows for CMD in Dockerfile to run after entrypoint.sh
exec "$@"
