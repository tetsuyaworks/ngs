#!/bin/bash

USER_ID=${LOCAL_UID:-1000}
GROUP_ID=${LOCAL_GID:-1000}

echo "Starting with UID: $USER_ID, GID: $GROUP_ID"

echo "root:root" | chpasswd
useradd -u $USER_ID -o -m user
groupmod -g $GROUP_ID user
echo "user:user" | chpasswd
echo "%user    ALL=(ALL)    NOPASSWD:    ALL" >> /etc/sudoers.d/user
chmod 0440 /etc/sudoers.d/user
export HOME=/home/user
echo "export PS1='[docker \h \W]\$ '" >> $HOME/.bashrc

if [ $# -eq 0 ]; then
    exec /usr/sbin/gosu user bash
else
    exec /usr/sbin/gosu user "$@"
fi
