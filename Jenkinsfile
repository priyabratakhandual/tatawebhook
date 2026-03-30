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

    stage('Deploy Application') {
        steps {
            script {
                sh '''
                echo "Deploying application ${BUILD_NUMBER}"

                # Create directory
                mkdir -p /var/lib/jenkins/tata-webhook

                # Create docker-compose.yml (STRICT FORMAT)
```

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

```
                # Go to directory
                cd /var/lib/jenkins/tata-webhook

                echo "===== docker-compose.yml ====="
                cat docker-compose.yml
                echo "=============================="

                # Pull latest image
                docker pull priyabratakhandual/tata-webhook:prod-${BUILD_NUMBER}

                # Restart container
                docker-compose down || true
                docker-compose up -d

                # Cleanup old images
                docker image prune -f
                '''
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
