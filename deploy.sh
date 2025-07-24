#!/bin/bash

# Fail if any command fails
set -e

# Set vars
TARGET_USER="root"                # Change this to your VM2 username
TARGET_HOST="10.0.1.54"
TARGET_FRONTEND_DIR="/var/www/frontend"
TARGET_BACKEND_DIR="/usr/share/project/backend"

echo "🔧 Building React app..."
cd frontend
npm install
npm run build
cd ..

echo "🧹 Collecting Django static files..."
cd backend
pip install -r ../requirements.txt
python3 manage.py collectstatic --noinput
cd ..

echo "🚀 Deploying to $TARGET_HOST..."

# Copy frontend build and backend project
scp -r frontend/build ${TARGET_USER}@${TARGET_HOST}:${TARGET_FRONTEND_DIR}
scp -r backend ${TARGET_USER}@${TARGET_HOST}:${TARGET_BACKEND_DIR}
scp deploy.sh ${TARGET_USER}@${TARGET_HOST}:/home/${TARGET_USER}/deploy.sh

echo "▶️ Running remote deploy script..."
ssh ${TARGET_USER}@${TARGET_HOST} 'chmod +x ~/deploy.sh && bash ~/deploy.sh'
