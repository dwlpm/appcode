pipeline { 
  agent any
    stages { 
        stage ('Build') {
            steps {
                sh "echo 'Build'"
                sh 'id'
                sh 'pwd'
                sh 'docker build . -f Dockerfile -t appcode:build'
            }
        }
        //def containerName
        stage('Test') {
            steps {
                sh "echo 'Testing..'"

                // run container
                sh "echo 'run image'"
                sh "docker rm -f appcode"   // remove container if exist
//                sh "docker network create networkBuild"  // create bridge network
//                sh "docker run --name containerBuild --network networkBuild --rm -d -p80:80 appcode:build"
                sh "docker run --name containerBuild --rm -d -p80:80 appcode:build"

                // unit test
                sh "echo 'unit test'"
                //containerName = 
                sh(
                    script: "docker exec containerBuild bash -c './vendor/bin/phpunit ./tests' "
//                    returnStdout: true,
                )

                // system integration test
                sh "echo 'system integration test'"
                sh "sleep 30"
                sh "python sit.py"          // check home page

                // remove container
                sh "docker rm -f containerBuild"
            }
        }
        stage('Push Docker Image') {
            steps {
                sh "echo 'tag and push image'"
                script {
                    try {
                        sh "docker tag appcode:build  dwlpm/appcode"
                        sh "docker push dwlpm/appcode"
                    } catch (err) {
                        echo err.getMessage()
                    }
                }
            }
        }
        stage('Create Artifact') {
            steps {
                sh "echo '${currentBuild.currentResult}, ${env.JOB_NAME}, ${env.BUILD_URL}'  >> artifact.csv"
            }
        }
        // stage('Deploy to ECS/EKS') {
        //     steps {
        //         echo 'deploy manifest'
        //     }
        // }
    }

    // email notification
    post {
        always {
            archiveArtifacts artifacts: '*.csv', onlyIfSuccessful: true

            emailext to: "derekwu@lpm.hk",
            subject: "jenkins build:${currentBuild.currentResult}: ${env.JOB_NAME}",
            body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}",
            attachmentsPattern: '*.csv'

        cleanWs()
        }
    }        
}
