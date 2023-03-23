pipeline {
  agent any
  triggers {
    githubPush()
  }
  stages {
    stage('Update Base Image') {
      steps {
        sh 'make pre-build'
      }
    }
    stage('Build Image') {
      steps {
        sh 'make docker-build'
      }
    }
    stage('Push Image') {
      steps {
        withDockerRegistry(credentialsId: 'dockerhub', url: 'https://index.docker.io/v1/') {
          sh 'make push'
        }
      }
    }
    stage('Clean up') {
      steps {
        sh 'make cleanup'

        cleanWs()
      }
    }
  }
}
