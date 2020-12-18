pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        timeout(time: 10, unit: 'MINUTES')
    }

    environment {
        registryCredentialsId = 'IZ_USER'
        registryUrl = 'https://dockerhub.rnd.amadeus.net:5000'
        imagename = "acs_sre/setupjob-base-images"
        dockerImage = ''
    }

    stages {
        stage('Building image') {
            steps {
                script {
                    dockerImage = docker.build(imagename, '-f Dockerfile.helm .')
                }
            }
        }

        stage('Test') {
            steps{
                script {
                    dockerImage.inside("--entrypoint='' --user=root") {
                        sh '''
                            microdnf install -y git
                            git clone https://github.com/sstephenson/bats.git
                            cd bats
                            ./install.sh /usr/local
                        '''
                        sh 'bats ./test/*.bats'
                    }
                }
            }
        }

        stage('Deploy Image') {
            steps {
                script {
                    docker.withRegistry( registryUrl, registryCredentialsId ) {
                        dockerImage.push("$BUILD_NUMBER")
                    }
                }
            }
        }
    }
}
