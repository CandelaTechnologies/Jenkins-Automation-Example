#!/usr/bin/env bash
#
# Check and install dependencies for test automation.
# This script does not configure Jenkins and does not run tests.
#

# Set Python virtual environment if not already set
VIRTUALENV_NAME="${VIRTUALENV_NAME:-"venv"}"

# Submodule path relative to base of repository
# This is hardcoded given since submodule checkout committed to this directory
LF_SCRIPTS=./lanforge-scripts

printf "> Configuring LANforge scripts test automation\n\n"

if [[ -d $LF_SCRIPTS ]]; then
    # If things aren't actually setup and this is printed, then
    # manually run 'git submodule init && git submodule update'
    printf "> LANforge scripts git submodule already configured\n\n"
else
    printf "> Cloning LANforge scripts git submodule\n\n"
    git submodule init && git submodule update
    if [[ $? -ne 0 ]]; then
        printf "! Failed to clone LANforge scripts git submodule\n\n"
        exit 1
    fi
fi

if [[ -d $VIRTUALENV_NAME ]]; then
    printf "> Python virtual environment '$VIRTUALENV_NAME' already present\n\n"
else
    printf "> Creating script Python virtual environment '$VIRTUALENV_NAME'\n\n"
    python3 -m virtualenv venv
    if [[ $? -ne 0 ]]; then
        printf "! Failed to create Python virtual environment '$VIRTUALENV_NAME'\n\n"
        exit 1
    fi
    echo  # Newline after virtual environment creation logs
fi

printf "> Activating and installing dependencies in Python virtual environment '$VIRTUALENV_NAME'\n\n"
source $VIRTUALENV_NAME/bin/activate
if [[ $? -ne 0 ]]; then
    printf "! Failed to source Python virtual environment '$VIRTUALENV_NAME'\n\n"
    exit 1
fi

python3 lanforge-scripts/py-scripts/update_dependencies.py
if [[ $? -ne 0 ]]; then
    printf "! Failed to install dependencies in virtual environment '$VIRTUALENV_NAME'\n\n"
    exit 1
fi

printf "> Setup complete. Activate virtuel environment by running 'source $VIRTUALENV_NAME/bin/activate'\n\n"
