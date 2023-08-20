pipeline{
    agent { label 'agent' }
    environment {
        DOCKERHUB_CREDENTIALS = credentials('esmira23-dockerhub')
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
                sh 'docker build -t esmira23/docker-jenkins-pipeline:latest .'
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
                sh 'docker push esmira23/docker-jenkins-pipeline:latest'
            }
        }
        stage("Login and Pull on VM"){
            steps{
                sh '''
                ssh -i jenkins-agent.pem ec2-user@16.170.203.107 "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin &&
                docker pull esmira23/docker-jenkins-pipeline:latest"
                '''
            }
        }
        stage("Deploy"){
            steps{
                // Assume you have SSH access to the other VM
                sh 'ssh -i jenkins-agent.pem ec2-user@16.170.203.107 "docker-compose up -d"'
            }
        }
    }
    post{
        always{
            sh 'docker logout'
            sh 'docker compose down --remove-orphans -v'
            sh 'docker compose ps'
        }
    }
}