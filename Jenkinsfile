@Library('pipeline-toolbox') _

pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        timeout(time: 10, unit: 'MINUTES')
    }

    environment {
        registryCredentialsId = 'IZ_USER'
        registryUrl = 'https://dockerhub.rnd.amadeus.net:5002'
        imageName = "acs_sre_images/setupjob-base-images"
        imageVersion = ''
        dockerImage = ''
    }

    stages {
        stage('Building image') {
            steps {
                script {
                    dockerImage = docker.build(imageName, '-f Dockerfile.helm .')
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

        stage('Tag') {
            when {
                expression {!isPullRequest()}
            }
            steps {
                script {
                    // extract base version (ex: 1.0)
                    def base_version = sh(returnStdout: true, script: 'cat version').trim()
                    // compute next version based on repo tags
                    imageVersion = newBuildVersion(base_version)
                    // add tag in BitBucket
                    completeBuild(imageVersion)
                }
            }
        }

        stage('Deploy Image') {
            when {
                expression {!isPullRequest()}
            }
            steps {
                script {
                    docker.withRegistry( registryUrl, registryCredentialsId ) {
                        dockerImage.push(imageVersion)
                    }
                }
            }
        }
    }
}
