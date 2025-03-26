pipeline {
    agent any
    tools {
        git 'Default'
    }
    environment {
        SONAR_HOST_URL = 'http://host.docker.internal:9000'
    }
    stages {
        stage('Clean Workspace') {
                    steps {
                        deleteDir()
                    }
                }
        stage('Checkout') {
            steps {
                sh 'rm -rf app && git clone https://github.com/cibarra95/threepoints_devops_webserver.git app'
                dir('app') {
                    echo 'Repositorio clonado correctamente'
                }
            }
        }
        stage('Paralelo SAST + Env') {
            parallel {
                stage('Pruebas de SAST'){
                    steps {
                        echo 'Ejecución del test SAST'
                    }
                }
                stage('Imprimir Env'){
                    steps {
                        echo "El workspace es: ${env.WORKSPACE}"
                    }
                }
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t devops_ws app'
            }
        }
        stage('SonarQube') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    sh '''
                        docker run --rm \
                            -e SONAR_HOST_URL=$SONAR_HOST_URL \
                            -e SONAR_TOKEN=$SONAR_TOKEN \
                            -v $(pwd)/app:/usr/src \
                            sonarsource/sonar-scanner-cli \
                            -Dsonar.projectKey=threepoints_devops_webserver_practica \
                            -Dsonar.sources=.
                    '''
                }
            }
        }
    }
}