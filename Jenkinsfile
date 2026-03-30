pipeline {
agent any

```
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
            script {
                sh """
                echo "Deploying Nginx config..."

                sudo cp nginx/tata-webhook /etc/nginx/sites-available/tata-webhook || true
                sudo ln -sf /etc/nginx/sites-available/tata-webhook /etc/nginx/sites-enabled/tata-webhook

                sudo nginx -t
                sudo systemctl reload nginx
                """
            }
        }
    }

    stage('Deploy Application') {
        steps {
            script {
                sh """
                echo "Deploying application ${IMAGE_TAG}"

                mkdir -p /home/ubuntu/tata-webhook

                # Create/update docker-compose
                cat <<EOF > /home/ubuntu/tata-webhook/docker-compose.yml
                version: '3.8'

                services:
                  tata-webhook:
                    image: ${registry}:${IMAGE_TAG}
                    container_name: tata-webhook
                    ports:
                      - "127.0.0.1:8000:8000"
                    restart: always
                EOF

                cd /home/ubuntu/tata-webhook

                docker pull ${registry}:${IMAGE_TAG}

                docker-compose down || true
                docker-compose up -d

                docker image prune -f
                """
            }
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
```

}
