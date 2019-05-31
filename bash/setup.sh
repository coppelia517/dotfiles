#!/bin/bash
set -e
OS="$(uname -s)"
DOT_DIRECTORY="${HOME}/.dotfiles"
DOT_TARBALL="https://github.com/coppelia517/dotfiles/tarball/master"
REMOTE_URL="git@github.com:coppelia517/dotfiles.git"

GIT_CONFIG="${DOT_DIRECTORY}/git"
SSH_CONFIG="${DOT_DIRECTORY}/ssh"
BASH_CONFIG="${DOT_DIRECTORY}/bash"

has() {
    type "$1" > /dev/null 2>&1
}

# 1. Download dotfiles.
if [ ! -d ${DOT_DIRECTORY} ]; then
    echo "Downloading dotfiles..."
    mkdir ${DOT_DIRECTORY}

    if type "git" > /dev/null 2>&1; then
        git clone --recursive "${REMOTE_URL}" "${DOT_DIRECTORY}"
    else
        curl -fsSLo ${HOME}/dotfiles.tar.gz ${DOT_TARBALL}
        tar -zxf ${HOME}/dotfiles.tar.gz --strip-components 1 -C ${DOT_DIRECTORY}
        rm -f ${HOME}/dotfiles.tar.gz
    fi

    echo $(tput setaf 2)Download dotfiles complete!. ✔︎$(tput sgr0)
fi

# 2. Deploy dotfiles.
# 2-1. Git Config Deploy dotfiles.
cd ${GIT_CONFIG}
for f in .??*
do
    [[ ${f} = ".git" ]] && continue
    [[ ${f} = ".gitignore" ]] && continue
    [[ ${f} = ".gitconfig.local" ]] && continue
    ln -snfv ${GIT_CONFIG}/${f} ${HOME}/${f}
done
touch ${HOME}/.gitconfig.local
echo $(tput setaf 2)    Deploy Git Config dotfiles complete!. ✔︎$(tput sgr0)

# 2-2. SSH Config Deploy dotfiles.
cd ${SSH_CONFIG}
SSH_FOLDER="${HOME}/.ssh"
if [ ! -d ${SSH_FOLDER} ]; then
    echo "Create .ssh folder..."
    mkdir ${SSH_FOLDER}
fi
for f in ??*
do
    [[ ${f} = ".git" ]] && continue
    [[ ${f} = ".gitignore" ]] && continue
    ln -snfv ${SSH_CONFIG}/${f} ${SSH_FOLDER}/${f}
done
echo $(tput setaf 2)    Deploy SSH Config dotfiles complete!. ✔︎$(tput sgr0)

# 2-3. Bash Config Deploy dotfiles.
cd ${BASH_CONFIG}
if [ ! -f ${BASH_CONFIG}/.bashrc ]; then
    echo "Create .bashrc file..."
    touch ${BASH_CONFIG}/.bashrc
fi
for f in .??*
do
    [[ ${f} = ".git" ]] && continue
    [[ ${f} = ".gitignore" ]] && continue
    ln -snfv ${BASH_CONFIG}/${f} ${HOME}/${f}
done
cat << EOS >> ${BASH_CONFIG}/.bashrc
if [ "$TERM" != "linux" ]; then
    source ${BASH_CONFIG}/pureline ${BASH_CONFIG}/pureline.conf
fi
EOS
echo $(tput setaf 2)    Deploy Bash Config dotfiles complete!. ✔︎$(tput sgr0)

echo $(tput setaf 2)Deploy dotfiles complete!. ✔︎$(tput sgr0)