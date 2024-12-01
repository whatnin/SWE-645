pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "syanama2/surveyform"
        DOCKER_REGISTRY = "docker.io"
    }
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:latest", ".")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    // Use Jenkins credentials with Docker Registry
                    withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-credentials', 
                        usernameVariable: 'syanama2', 
                        passwordVariable: 'Chinmayee@123'
                    )]) {
                        sh """
                            docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
                            docker push ${DOCKER_IMAGE}:latest
                        """
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
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
        failure {
            echo "Pipeline failed. Sending notifications..."
        }
        success {
            echo "Pipeline completed successfully!"
        }
    }
}
