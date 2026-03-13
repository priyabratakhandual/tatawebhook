#!/bin/bash

cd /home/ubuntu/tata-webhook

python3 -m venv venv

source venv/bin/activate

pip install --upgrade pip

pip install -r requirements.txt