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
        stage('Docker Hub Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage("Push"){
            steps{
                sh 'docker push esmira23/docker-jenkins-pipeline:latest'
            }
        }
        stage("Copy files"){
            steps{
                sh '''
                scp docker-compose.yml esmira@192.168.138.133:/home/esmira/docker-jenkins-pipeline
                scp mariadb.sql esmira@192.168.138.133:/home/esmira/docker-jenkins-pipeline
                '''
            }
        }
        stage("Deploy"){
            steps{
                sh 'ssh esmira@192.168.138.133 "docker compose -f ~/docker-jenkins-pipeline/docker-compose.yml up -d --build"'
            }
        } 
        stage("Test"){
            steps{
                script {
                    final String url = "http://192.168.138.133:8080/"
                    final String http_code = sh(script: "ssh esmira@192.168.138.133 \"curl -s -o /dev/nul -w \'%{http_code}\'\"", returnStdout: true).trim()
                    echo http_code
                }
            }
        }
    }
    post{
        always{
            sh ''' 
            docker logout
            ssh esmira@192.168.138.133 "rm ~/docker-jenkins-pipeline/docker-compose.yml"
            ssh esmira@192.168.138.133 "rm ~/docker-jenkins-pipeline/mariadb.sql"
            '''
        }
    }
}