pipeline {
    agent any

    environment {
        DEPLOY_SCRIPT = './deploy.sh'
    }

    stages {
        

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    sh 'npm install'
                    sh 'npm run build'
                }
            }
        }

        stage('Collect Django Static Files') {
            steps {
                dir('backend') {
                    
                    sh '''
                        python3 -m venv venv
                        . venv/bin/activate
                        pip install --upgrade pip
                        pip install -r ../requirements.txt
                        python manage.py makemigrations
                        python manage.py migrate 
                        '''
                }
            }
        }

        stage('Deploy to Target VM') {
            steps {
                sh "chmod +x ${DEPLOY_SCRIPT}"
                sh "${DEPLOY_SCRIPT}"
            }
        }
    }

    post {
        success {
            echo '✅ Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed.'
        }
    }
}
