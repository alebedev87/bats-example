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