#!/bin/bash

set -e

cd /home/ubuntu/tata-webhook

# create virtual environment if it does not exist
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

# activate virtual environment
source venv/bin/activate

# upgrade pip
pip install --upgrade pip

# install project dependencies
pip install -r requirements.txt