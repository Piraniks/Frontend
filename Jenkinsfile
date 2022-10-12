def imageName="192.168.44.44:8082/docker_registry/frontend" 
def dockerRegistry="http://192.168.44.44:8082"
def registryCredentials="artifactory"
def dockerTag=""


pipeline {
    agent {
      label 'agent'
    }

    environment {
        scannerHome = tool 'SonarQube'
    }

    stages {
        stage('Checkout repository') {
            steps {
                checkout scm
            }
        }
        stage('Install dependencies') {
            steps {
                sh "python3 -m pip install -r requirements.txt"
            }
        }
        stage('Run tests') {
            steps {
                sh "python3 -m pytest --cov=. --cov-report xml:test-results/coverage.xml --junitxml=test-results/pytest-report.xml"
            }
        }
        stage('Sonarqube analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Build docker image') {
            steps {
                script {
                    dockerTag = "RC-${BUILD_NUMBER}"
                    applicationImage = docker.build("${imageName}:${dockerTag}")   
                }
            }
        }
        stage('Push docker image') {
            steps {
                script {
                    docker.withRegistry(dockerRegistry, registryCredentials) {
                        // Push tag with build number.
                        applicationImage.push()
                        
                        // Push latest tag alongside.
                        applicationImage.push('latest')
                    }
                }
            }
        }
    }
    
    post { 
        always { 
            junit testResults: "test-results/*.xml"
            cleanWs()
        }
    }
}
