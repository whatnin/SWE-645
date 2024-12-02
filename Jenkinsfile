pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "syanama2/surveyform"
        DOCKER_TAG = "${env.BUILD_ID}"
        KUBECONFIG = "${WORKSPACE}/survey.yaml"
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/whatnin/SWE-645.git'
            }
        }
        
        stage('Build Project') {
            steps {
                script {
                    dir('swe-645') {
                        sh 'mvn clean package -DskipTests'
                    }
                }
            }
        }
        
        stage('Verify JAR file') {
            steps {
                sh 'ls -l swe-645/target/'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("syanama2/surveyform:latest", "-f swe-645/Dockerfile .")
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-credentials') {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'kubernetes-token', variable: 'TOKEN')]) {
                        sh """
                            sed -i 's|token:.*|token: ${TOKEN}|g' survey.yaml
                        """
                    }
                    
                    withEnv(["KUBECONFIG=${WORKSPACE}/survey.yaml"]) {
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f service.yaml'
                        sh 'kubectl rollout restart deployment/survey-deployment'
                        sh 'kubectl rollout status deployment/survey-deployment'
                    }
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            echo 'Pipeline executed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
