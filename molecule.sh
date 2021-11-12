#!/bin/bash
# Molecule shortcut over molecule inside container
# Coming from: https://gist.github.com/fletort/7a34c7f211acf0cde56c8f2749a3ec8b
# Use ./molecule.sh shell to login on the container bash

# Upgrade Some components from quay.io/ansible/toolset:3.5.0 (maybe should make another docker image?)
# Flake and testinfra are not available in this image
# Need to upgrade molecule-docker from 0.2.4 to 1.1.0 to remove some warnings (molecule-docker #47)
bump_version="pip3 install flake8==4.0.1 pytest-molecule==1.5.0 testinfra==6.0.0;pip3 install molecule-docker==1.1.0 -U"

if [ "$1" = "shell" ] ; then
    docker run --rm -it \
        -v $(pwd):/tmp/$(basename "${PWD}") \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ~/.cache/:/root/.cache/ \
        -w /tmp/$(basename "${PWD}") \
        -e HOST_PWD=${PWD} \
        --name molecule \
        quay.io/ansible/toolset:3.5.0 \
        /bin/bash -c "$bump_version;/bin/bash"
else
    docker run --rm -it \
        -v $(pwd):/tmp/$(basename "${PWD}") \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ~/.cache/:/root/.cache/ \
        -w /tmp/$(basename "${PWD}") \
        -e HOST_PWD=${PWD} \
        --name molecule \
        quay.io/ansible/toolset:3.5.0\
        /bin/bash -c "$bump_version;molecule $*"
fi

# Explanation:
# -v $(pwd):/tmp/$(basename "${PWD}")
# This option is used to share the current project directory with the 
# container in the /tmp/<project_dir> directory. <project_dir> is the name
# of the project directory on the host (where this script is located)
#
# -w /tmp/$(basename "${PWD}")
# This option is used to make the directory shared previsouly the
# default (starting/working) directory of the container
#
# -v /var/run/docker.sock:/var/run/docker.sock
# This option gives the possibility to create docker container from 
# the molecule container (docker-in-docker), using the host docker.
#
# -v ~/.cache/:/root/.cache/
# This option is used to keep molecule context  (all molecule cache files)
# between successive creation/execution/deletion of the molecule container.
#
# -e HOST_PWD=$(PWD)
# This option is usefull to have the Host current Working Directroy information
# inside the molecule container. We need this information, as when we run a new
# docker container from the molecule container (docker in docker), if we are
# using PWD in a sharing filesytem process, it will be equal to 
# /tmp/<project_dir>, but container will be created in the host context, where
# this directory does not exist....
#
# --name molecule
# created container will be named "molecule"
#
# quay.io/ansible/toolset:3.5.0
# This is the image used to create the container

