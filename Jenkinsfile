pipeline { 
  agent any
    stages { 
        stage ('Build') {
            steps {
                sh "echo 'Build'"
                sh 'id'
                sh 'pwd'
                sh "echo '${env.BUILD_ID}'"
                sh 'ls -l'
                sh 'docker build . -f Dockerfile -t appcode:build'
                sh 'docker images'
                sh 'sleep 15'
            }
        }
        //def containerName
        stage('Test') {
            steps {
                sh "echo 'Testing..'"

                // run container
                sh "echo 'run image'"
                sh 'id'
                sh 'pwd'
                sh 'ls'
                sh "docker rm -f containerBuild"   // remove container if exist

                sh "docker run --name containerBuild --rm -d -p80:80 appcode:build"
                sh "docker ps -a"

                // unit test
                sh "echo 'unit test'"
                sh "docker exec containerBuild bash -c './vendor/bin/phpunit ./tests' "

                // system integration test
                sh "echo 'system integration test'"
                // get container IP
                script {
//                    def IP
//                    IP = sh "docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' containerBuild"
                    sh "docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' containerBuild"
//                    echo ${IP}
                    sh 'sleep 5'
                    echo "-------------------------------"
                    sh 'sleep 5'
//                    sh "export PATH=$PATH:/opt; echo $PATH; python sit.py ${IP}"          // check home page
                }
                echo "-------------------------------"
                sh 'sleep 5'

                // remove container
                sh "sleep 36000"
                sh "docker rm -f containerBuild"
            }
        }
        stage('Push Docker Image') {
            steps {
                sh "echo 'tag and push image'"
                script {
                    try {
                        sh "docker tag appcode:build  dwlpm/appcode"
                        sh "docker tag appcode:build  complete:${env.BUILD_ID}"
                        sh "docker push dwlpm/appcode"
                    } catch (err) {
                        echo err.getMessage()
                    }
                }
            }
        }
        stage('Create Artifact') {
            steps {
                sh "echo '${currentBuild.currentResult}, ${env.JOB_NAME}, ${env.BUILD_ID}, ${env.BUILD_NUMBER}, ${env.BUILD_URL}'  >> artifact.csv"
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
