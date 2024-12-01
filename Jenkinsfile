pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "syanama2/surveyform"
        DOCKER_REGISTRY = "docker.io"  // Corrected registry URL
        DOCKER_CREDENTIALS_ID = 'syanama2'  // Docker Hub credentials ID
    }
    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/whatnin/SWE-645.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image with a tag
                    dockerImage = docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Login and push to Docker Hub
                    docker.withRegistry('https://docker.io', "${DOCKER_CREDENTIALS_ID}") {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                // Use the configured kubeconfig
                withKubeConfig([credentialsId: 'docker-desktop']) {
                    sh '''
                        kubectl apply -f deployment.yaml
                        kubectl apply -f service.yaml
                    '''
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
    }
}
