pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "syanama2/surveyform"
        DOCKER_REGISTRY = "docker.io"
        DOCKER_CREDENTIALS_ID = 'syanama2'
    }
    stages {
        stage('Checkout Code') {
            steps {
                // Explicitly specify the branch and use checkout scm
                checkout([
                    $class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    userRemoteConfigs: [[
                        url: 'https://github.com/whatnin/SWE-645.git'
                    ]]
                ])
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        dockerImage = docker.build("${DOCKER_IMAGE}:latest", ".")
                    } catch (Exception e) {
                        error "Docker build failed: ${e.message}"
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://docker.io', "${DOCKER_CREDENTIALS_ID}") {
                        try {
                            dockerImage.push()
                            dockerImage.push('latest')
                        } catch (Exception e) {
                            error "Docker push failed: ${e.message}"
                        }
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'docker-desktop']) {
                    script {
                        try {
                            sh '''
                                kubectl apply -f deployment.yaml
                                kubectl apply -f service.yaml
                            '''
                        } catch (Exception e) {
                            error "Kubernetes deployment failed: ${e.message}"
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs()
        }
        failure {
            echo "Pipeline failed. Sending notifications..."
        }
        success {
            echo "Pipeline completed successfully!"
        }
    }
}
