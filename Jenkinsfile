pipeline {
    agent any

    environment {
        VM_HOST = 'user@your-vm-ip'       // Replace with actual SSH user and IP
        SSH_KEY_ID = 'vm-ssh-key'         // Jenkins SSH credential ID
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/your-org/your-project.git'
            }
        }

        stage('Build Frontend') {
            dir('frontend') {
                steps {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Test Backend') {
            dir('backend') {
                steps {
                    sh 'pip install -r requirements.txt'
                    sh 'python manage.py test'
                }
            }
        }

        stage('Deploy to VM') {
            steps {
                sshagent([env.SSH_KEY_ID]) {
                    sh """
                    echo "📦 Copying frontend build to VM..."
                    scp -r ./frontend/build ${VM_HOST}:/var/www/frontend/

                    echo "📦 Copying backend code to VM..."
                    scp -r ./backend ${VM_HOST}:/home/user/project/

                    echo "📦 Copying deployment script..."
                    scp ./deploy.sh ${VM_HOST}:/home/user/deploy.sh

                    echo "🚀 Running deployment script on VM..."
                    ssh ${VM_HOST} 'chmod +x /home/user/deploy.sh && bash /home/user/deploy.sh'
                    """
                }
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
