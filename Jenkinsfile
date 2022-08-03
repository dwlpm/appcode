pipeline { 
  agent any
    stages { 
        stage ('Build') {
            steps {
                sh "echo 'Build..'"
                sh 'id'
                sh 'pwd'
                sh "echo 'build id: ${env.BUILD_ID}'"

                // build and tag as "appcode:build"
                sh 'docker build . -f Dockerfile -t appcode:build'
                sh 'docker images'
            }
        }
        //def containerName
        stage('Test') {
            steps {
                sh "echo 'Testing..'"

                // run container
                sh "docker rm -f containerBuild"   // remove container if exist
                sh "echo 'run image appcode:build' "
                sh "docker run --name containerBuild --rm -d -p80:80 appcode:build"
                sh "docker ps -a"

                // unit test
                sh "echo 'unit test..'"
                sh "docker exec containerBuild bash -c './vendor/bin/phpunit ./tests' "

                // system integration test
                sh "echo 'system integration test..'"
                script {
                    sh '''
                        // get container IP
                        export containerIP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' containerBuild)
                        echo "container IP: $containerIP"
                        // test home page
                        export PATH=$PATH:/opt; echo $PATH; python sit.py ${containerIP}/index.php
                        sleep 5
                    '''
                }

                // remove container
                sh "sleep 36000"   # for troubleshooting use
                sh "docker rm -f containerBuild"
            }
        }
        stage('Push Docker Image') {
            steps {
                sh "echo 'tag and push image..'"
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
