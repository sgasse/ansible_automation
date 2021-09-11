#!/bin/bash

set -e  # Exit on first error
set -u  # Error on undefined variables
set -o pipefail  # Return exit status of last command with non-zero exit
# See https://tldp.org/LDP/abs/html/options.html

# Run in the right directory
script_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $script_path
echo "Running in $script_path"

if test -d ".venv"; then
    echo ".venv already exists - remove it before running this script."
    exit 1
fi

# Install python requirements
python3 -m venv .venv
source .venv/bin/activate

pip install -r dev/requirements_pip.txt

# Install collections and roles
ansible-galaxy install -r dev/requirements_ansible.yml

echo "Successfully setup virtual environment at ${script_path}/.venv"
echo "    -> Activate with: source ${script_path}/.venv/bin/activate"

exit 0
