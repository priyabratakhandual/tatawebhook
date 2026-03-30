pipeline {
agent any

environment {
    registry = "priyabratakhandual/tata-webhook"
    registryCredential = 'dockerhub-cred-id'
    IMAGE_TAG = "prod-${BUILD_NUMBER}"
    dockerImage = ''
}

stages {

    stage('Checkout') {
        steps {
            checkout scm
        }
    }

    stage('Build Docker Image') {
        steps {
            script {
                dockerImage = docker.build("${registry}:${IMAGE_TAG}")
            }
        }
    }

    stage('Push Docker Image') {
        steps {
            script {
                docker.withRegistry('', registryCredential) {
                    dockerImage.push()
                }
            }
        }
    }

    stage('Deploy Application') {
        steps {
            script {
                sh '''
                echo "Deploying application"

                mkdir -p /var/lib/jenkins/tata-webhook

                cat <<EOF > /var/lib/jenkins/tata-webhook/docker-compose.yml

version: '3.8'

services:
tata-webhook:
image: priyabratakhandual/tata-webhook:prod-${BUILD_NUMBER}
container_name: tata-webhook
ports:
- "127.0.0.1:8000:8000"
restart: always
EOF

                cd /var/lib/jenkins/tata-webhook

                docker pull priyabratakhandual/tata-webhook:prod-${BUILD_NUMBER}

                docker-compose down || true
                docker-compose up -d

                docker image prune -f
                '''
            }
        }
    }
}

post {
    success {
        echo "Deployment successful"
    }
    failure {
        echo "Deployment failed"
    }
}

}