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
                    sh 'pip install -r ../requirements.txt'
                    sh 'python3 manage.py collectstatic --noinput'
                }
            }
        }

        stage('Deploy to Target VM') {
            steps {
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
