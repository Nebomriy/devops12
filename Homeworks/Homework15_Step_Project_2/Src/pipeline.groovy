pipeline {
  agent { label 'docker' }

  environment {
    GIT_URL = 'https://github.com/Nebomriy/4-danit-stepproject-2-nodejs.git'
    GIT_BRANCH = 'main'
    IMAGE = 'seglianik/jenkins-lab:latest'
  }

  stages {
    stage('Pull the code') {
      steps {
        git branch: "${GIT_BRANCH}", url: "${GIT_URL}"
      }
    }

    stage('Build Docker image') {
      steps {
        sh 'docker build -t "$IMAGE" .'
      }
    }

    stage('Run tests in container') {
      steps {
        sh 'docker run --rm "$IMAGE" npm test'
      }
    }

    stage('Login & Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_TOKEN')]) {
          sh '''
            echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USER" --password-stdin
            docker push "$IMAGE"
            docker logout
          '''
        }
      }
    }
  }

  post {
    failure {
      echo 'Tests failed'
    }
  }
}

