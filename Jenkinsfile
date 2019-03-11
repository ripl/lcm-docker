pipeline {
    agent any
    stages {
        stage('Update Base Image') {
            steps {
                sh 'docker pull ubuntu:14.04'
                sh 'docker pull ubuntu:16.04'
            }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t ripl/lcm:environment -f Dockerfile.environment ./'
                sh 'docker build -t ripl/lcm:environment_trusty -f Dockerfile.environment_trusty ./'
                sh 'docker build -t ripl/lcm:latest -f Dockerfile.latest ./'
                sh 'docker build -t ripl/lcm:latest_trusty -f Dockerfile.latest_trusty ./'
                sh 'docker build -t ripl/lcm:1.4.0 --build-arg VERSION=1.4.0 -f Dockerfile.release ./'
                sh 'docker build -t ripl/lcm:1.4.0_trusty --build-arg VERSION=1.4.0 -f Dockerfile.release_trusty ./'
            }
        }
        stage('Push Image') {
            steps {
                withDockerRegistry(credentialsId: 'DockerHub', url: 'https://index.docker.io/v1/') {
                    sh 'docker push ripl/lcm:latest'
                    sh 'docker push ripl/lcm:latest_trusty'
                    sh 'docker push ripl/lcm:1.4.0'
                    sh 'docker push ripl/lcm:1.4.0_trusty'
                }
            }
        }
        stage('Post - Clean up') {
            steps {
                sh 'docker rmi ripl/lcm:latest'
                sh 'docker rmi ripl/lcm:latest_trusty'
                sh 'docker rmi ripl/lcm:1.4.0'
                sh 'docker rmi ripl/lcm:1.4.0_trusty'
                sh 'docker rmi ripl/lcm:environment'
                sh 'docker rmi ripl/lcm:environment_trusty'
                cleanWs()
            }
        }
    }
}
