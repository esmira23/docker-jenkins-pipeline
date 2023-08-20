pipeline{
    agent { label 'agent' }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('')
    }
    stages{
        stage("Clone"){
            steps {
                git url: 'https://github.com/esmira23/docker-jenkins-pipeline.git', 
                branch: 'main',
                credentialsId: 'github_creds'
            }
        }
        stage("Prune Docker data"){
            steps{
                sh 'docker system prune -af --volumes'
            }
        }
        stage("Build"){
            steps{
                sh 'docker-compose build -t esmira/docker-jenkins-pipeline:latest'
            }
        }
        // stage("Test"){
        //     steps{}
        // }
        stage('Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage("Push"){
            steps{
                sh 'docker push esmira/docker-jenkins-pipeline:latest'
            }
        }
        stage("Login and Pull on VM"){
            steps{
                sh '''
                ssh user@remote-vm "docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW 
                docker pull esmira/docker-jenkins-pipeline:latest"
                '''
            }
        }
        stage("Deploy"){
            steps{
                // Assume you have SSH access to the other VM
                sh 'ssh user@remote-vm "docker-compose up -d"'
            }
        }
    }
    post{
        always{
            sh '''
            docker logout
            docker compose down --remove-orphans -v
            docker compose ps
            '''
        }
    }
}

docker login -u esmira23
dckr_pat_fhVg0VzdXKvXmGR83kn_GXoHc6A