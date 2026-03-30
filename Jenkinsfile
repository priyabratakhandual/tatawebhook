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

        stage('Deploy Nginx Config') {
            steps {
                sh '''
echo "Deploying Nginx config"

sudo cp nginx/tata-webhook /etc/nginx/sites-available/tata-webhook || true
sudo ln -sf /etc/nginx/sites-available/tata-webhook /etc/nginx/sites-enabled/tata-webhook

sudo nginx -t
sudo systemctl reload nginx
'''
            }
        }

        stage('Deploy Application') {
            steps {
                sh '''
echo "Deploying application"

mkdir -p /var/lib/jenkins/tata-webhook

cat <<EOF > /var/lib/jenkins/tata-webhook/docker-compose.yml
version: "3.8"
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

    post {
        success {
            echo "Deployment successful: ${IMAGE_TAG}"
        }
        failure {
            echo "Deployment failed"
        }
    }
}