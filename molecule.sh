#!/bin/bash
# Molecule shortcut over molecule inside container
# Coming from: https://gist.github.com/fletort/7a34c7f211acf0cde56c8f2749a3ec8b

docker run --rm -it \
    -v $(pwd):/tmp/$(basename "${PWD}") \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v ~/.cache/:/root/.cache/ \
    -w /tmp/$(basename "${PWD}") \
    quay.io/ansible/molecule:3.0.6 \
    molecule "$@"