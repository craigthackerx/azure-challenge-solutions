#!/usr/bin/env bash

set -xe
VIRTUAL_ENV="hello-world-api"
CURRENT_LOCATION="$(pwd)"

#Forces script to execute current directory
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


cd "${SCRIPT_DIR}" && \
    virtualenv "${VIRTUAL_ENV}" && \
    chmod +x "${SCRIPT_DIR}"/"${VIRTUAL_ENV}"/bin/activate && \
    source "${SCRIPT_DIR}"/"${VIRTUAL_ENV}"/bin/activate && \
    pip3 install fastapi uvicorn
    cd "${CURRENT_LOCATION}" && \
    pip3 freeze > requirements.txt
