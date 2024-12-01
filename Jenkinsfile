pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "syanama2/surveyform"
        DOCKER_REGISTRY = "sha256:49b9f1b801bb1cab01e82b11454946f974b69c00c115afe6ac8d8deb26848360"
        KUBECONFIG = credentials('docker-desktop')
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
                    docker.build("${DOCKER_IMAGE}")
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'syanama2') {
                        docker.image("${DOCKER_IMAGE}").push("latest")
                    }
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                '''
            }
        }
    }
    post {
        always {
            cleanWs() // Remove the node block and just use cleanWs() directly
        }
    }
}
