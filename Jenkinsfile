pipeline {
  agent any
  environment {
    // Common variables
    RELEASE_VERSION = "1.4.0"

    // Tag: environment
    BASE_IMAGE_ENVIRONMENT = "ubuntu:16.04"
    BUILD_IMAGE_ENVIRONMENT = "ripl/lcm:environment"

    // Tag: latest
    BUILD_IMAGE_LATEST = "ripl/lcm:latest"

    // Tag: <release>
    BUILD_IMAGE_RELEASE = "ripl/lcm:${RELEASE_VERSION}"

    // Tag: environment_trusty
    BASE_IMAGE_ENVIRONMENT_TRUSTY = "ubuntu:14.04"
    BUILD_IMAGE_ENVIRONMENT_TRUSTY = "ripl/lcm:environment_trusty"

    // Tag: latest_trusty
    BUILD_IMAGE_LATEST_TRUSTY = "ripl/lcm:latest_trusty"

    // Tag: <release>_trusty
    BUILD_IMAGE_RELEASE_TRUSTY = "ripl/lcm:${RELEASE_VERSION}_trusty"
  }
  stages {
    stage('Update Base Image') {
      steps {
        sh 'docker pull $BASE_IMAGE_ENVIRONMENT'
        sh 'docker pull $BASE_IMAGE_ENVIRONMENT_TRUSTY'
      }
    }
    stage('Build Image') {
      steps {
        sh 'docker build -t $BUILD_IMAGE_ENVIRONMENT -f Dockerfile.environment ./'
        sh 'docker build -t $BUILD_IMAGE_LATEST -f Dockerfile.latest ./'
        sh 'docker build -t $BUILD_IMAGE_RELEASE --build-arg VERSION=$RELEASE_VERSION -f Dockerfile.release ./'

        sh 'docker build -t $BUILD_IMAGE_ENVIRONMENT_TRUSTY -f Dockerfile.environment_trusty ./'
        sh 'docker build -t $BUILD_IMAGE_LATEST_TRUSTY -f Dockerfile.latest_trusty ./'
        sh 'docker build -t $BUILD_IMAGE_RELEASE_TRUSTY --build-arg VERSION=$RELEASE_VERSION -f Dockerfile.release_trusty ./'
      }
    }
    stage('Push Image') {
      steps {
        withDockerRegistry(credentialsId: 'DockerHub', url: 'https://index.docker.io/v1/') {
          sh 'docker push $BUILD_IMAGE_LATEST'
          sh 'docker push $BUILD_IMAGE_RELEASE'

          sh 'docker push $BUILD_IMAGE_LATEST_TRUSTY'
          sh 'docker push $BUILD_IMAGE_RELEASE_TRUSTY'
        }
      }
    }
    stage('Post - Clean up') {
      steps {
        sh 'docker rmi $BUILD_IMAGE_RELEASE'
        sh 'docker rmi $BUILD_IMAGE_LATEST'
        sh 'docker rmi $BUILD_IMAGE_ENVIRONMENT'
        sh 'docker rmi $BASE_IMAGE_ENVIRONMENT'

        sh 'docker rmi $BUILD_IMAGE_RELEASE_TRUSTY'
        sh 'docker rmi $BUILD_IMAGE_LATEST_TRUSTY'
        sh 'docker rmi $BUILD_IMAGE_ENVIRONMENT_TRUSTY'
        sh 'docker rmi $BASE_IMAGE_ENVIRONMENT_TRUSTY'

        cleanWs()
      }
    }
  }
}
