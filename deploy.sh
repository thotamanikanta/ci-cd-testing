#!/bin/bash

# Fail if any command fails
set -e

# Set vars
TARGET_USER="root"                # Change this to your VM2 username
TARGET_HOST="10.0.1.54"
TARGET_FRONTEND_DIR="/var/www/frontend"
TARGET_BACKEND_DIR="/usr/share/backend"

echo "🔧 Building React app..."
cd frontend
npm install
npm run build
cd ..


if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate
echo "🧹 Collecting Django static files..."

pip install -r requirements.txt
cd backend
python manage.py makemigrations
python manage.py migrate 
cd ..
echo "🚀 Deploying to $TARGET_HOST..."

# Copy frontend build and backend project


ssh -o StrictHostKeyChecking=no ${TARGET_USER}@${TARGET_HOST} "mkdir -p ${TARGET_FRONTEND_DIR}"
ssh -o StrictHostKeyChecking=no ${TARGET_USER}@${TARGET_HOST} "mkdir -p ${TARGET_FRONTEND_DIR}"
ssh -o StrictHostKeyChecking=no ${TARGET_USER}@${TARGET_HOST} "mkdir -p ${TARGET_FRONTEND_DIR}"
scp -o StrictHostKeyChecking=no -r frontend ${TARGET_USER}@${TARGET_HOST}:${TARGET_BACKEND_DIR}
scp -o StrictHostKeyChecking=no -r backend ${TARGET_USER}@${TARGET_HOST}:${TARGET_BACKEND_DIR}
scp -o StrictHostKeyChecking=no deploy.sh ${TARGET_USER}@${TARGET_HOST}:/home/${TARGET_USER}/deploy.sh

echo "▶️ Running remote deploy script..."
ssh -o StrictHostKeyChecking=no ${TARGET_USER}@${TARGET_HOST} 'chmod +x ~/deploy.sh && bash ~/deploy.sh'
