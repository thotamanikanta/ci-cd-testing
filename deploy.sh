#!/bin/bash

echo "🚀 Starting deployment on VM..."

# Backend setup
cd ~/project/backend || exit

if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py collectstatic --noinput

sudo systemctl restart gunicorn

# Frontend setup
sudo rm -rf /var/www/html/*
sudo cp -r /var/www/frontend/* /var/www/html/

echo "✅ Deployment finished!"
