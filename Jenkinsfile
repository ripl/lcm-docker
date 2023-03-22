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

    // Tag: environment_xenial
    BASE_IMAGE_ENVIRONMENT_XENIAL = "ubuntu:16.04"
    BUILD_IMAGE_ENVIRONMENT_XENIAL = "ripl/lcm:environment_xenial"

    // Tag: latest_xenial
    BUILD_IMAGE_LATEST_XENIAL = "ripl/lcm:latest_xenial"

    // Tag: <release>_XENIAL
    BUILD_IMAGE_RELEASE_XENIAL = "ripl/lcm:${RELEASE_VERSION}_xenial"
  }
  stages {
    stage('Update Base Image') {
      steps {
        sh 'docker pull $BASE_IMAGE_ENVIRONMENT'
        sh 'docker pull $BASE_IMAGE_ENVIRONMENT_XENIAL'
      }
    }
    stage('Build Image') {
      steps {
        sh 'docker build -t $BUILD_IMAGE_ENVIRONMENT -f Dockerfile.environment ./'
        sh 'docker build -t $BUILD_IMAGE_LATEST -f Dockerfile.latest ./'
        sh 'docker build -t $BUILD_IMAGE_RELEASE --build-arg VERSION=$RELEASE_VERSION -f Dockerfile.release ./'

        sh 'docker build -t $BUILD_IMAGE_ENVIRONMENT_XENIAL -f Dockerfile.environment_xenial ./'
        sh 'docker build -t $BUILD_IMAGE_LATEST_XENIAL -f Dockerfile.latest_xenial ./'
        sh 'docker build -t $BUILD_IMAGE_RELEASE_XENIAL --build-arg VERSION=$RELEASE_VERSION -f Dockerfile.release_xenial ./'
      }
    }
    stage('Push Image') {
      steps {
        withDockerRegistry(credentialsId: 'dockerhub', url: 'https://index.docker.io/v1/') {
          sh 'docker push $BUILD_IMAGE_LATEST'
          sh 'docker push $BUILD_IMAGE_RELEASE'

          sh 'docker push $BUILD_IMAGE_LATEST_XENIAL'
          sh 'docker push $BUILD_IMAGE_RELEASE_XENIAL'
        }
      }
    }
    stage('Clean up') {
      steps {
        sh 'docker rmi $BUILD_IMAGE_RELEASE'
        sh 'docker rmi $BUILD_IMAGE_LATEST'
        sh 'docker rmi $BUILD_IMAGE_ENVIRONMENT'
        sh 'docker rmi $BASE_IMAGE_ENVIRONMENT'

        sh 'docker rmi $BUILD_IMAGE_RELEASE_XENIAL'
        sh 'docker rmi $BUILD_IMAGE_LATEST_XENIAL'
        sh 'docker rmi $BUILD_IMAGE_ENVIRONMENT_XENIAL'
        sh 'docker rmi $BASE_IMAGE_ENVIRONMENT_XENIAL'

        cleanWs()
      }
    }
  }
}
