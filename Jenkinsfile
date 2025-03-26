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
                stage('Pruebas de SAST') {
                    steps {
                        withSonarQubeEnv('SonarQube') {
                            withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                                sh '''
                                    docker run --rm --network devops-net \
                                        -e SONAR_HOST_URL=$SONAR_HOST_URL \
                                        -e SONAR_TOKEN=$SONAR_TOKEN \
                                        -v $(pwd)/app:/usr/src \
                                        -w /usr/src/SIC \
                                        sonarsource/sonar-scanner-cli \
                                        -Dsonar.projectKey=threepoints_devops_webserver_practica \
                                        -Dsonar.sources=. \
                                        -Dsonar.qualitygate.wait=false
                                '''
                            }
                            timeout(time: 2, unit: 'MINUTES') {
                                waitForQualityGate abortPipeline: false
                            }
                        }
                    }
                }
                stage('Imprimir Env'){
                    steps {
                        sh '''
                            echo "==== Imprimir Env ===="
                            printenv
                            echo "==== Fin Env ===="
                            echo "<==== Ruta y contenido del workspace ====>"
                            pwd
                            ls -la
                        '''
                    }
                }
            }
        }
        stage('Configurar archivo') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Credentials_Threepoints_Practica', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                        echo "[credentials]" > credentials.ini
                        echo "user=${USER}" >> credentials.ini
                        echo "password=${PASS}" >> credentials.ini
                    '''
                    archiveArtifacts artifacts: 'credentials.ini', onlyIfSuccessful: true
                }
            }
        }
        stage('Build') {
            steps {
                sh 'docker build -t devops_ws app'
            }
        }
    }
}