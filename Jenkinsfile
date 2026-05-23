// Enterprise-style multibranch Jenkins pipeline for the EKS training repository.
@Library('acme-shared-library') _

pipeline {
  agent none

  options {
    disableConcurrentBuilds()
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }

  environment {
    AWS_REGION = 'us-east-1'
    REGISTRY = '111122223333.dkr.ecr.us-east-1.amazonaws.com'
    IMAGE_TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"
    TERRAFORM = 'C:/tools/terraform.exe'
  }

  stages {
    stage('Checkout') {
      agent { label 'linux && docker' }
      steps {
        checkout scm
      }
    }

    stage('Static Analysis') {
      parallel {
        stage('SonarQube') {
          agent { label 'linux && docker' }
          steps {
            sh 'echo Running SonarQube scan for Python services'
            sh 'sonar-scanner -Dsonar.projectKey=acme-eks-platform -Dsonar.sources=microservices'
          }
        }
        stage('Dependency Check') {
          agent { label 'linux && docker' }
          steps {
            sh 'dependency-check.sh --project acme-eks-platform --scan microservices --format HTML --out reports/dependency-check'
          }
        }
      }
    }

    stage('Build and Scan Images') {
      agent { label 'linux && docker' }
      steps {
        script {
          ['user-service', 'product-service', 'order-service', 'payment-service', 'notification-service', 'frontend-ui'].each { service ->
            buildAndPushImage(service, env.REGISTRY, env.IMAGE_TAG)
            runSecurityScans(service, env.REGISTRY, env.IMAGE_TAG)
          }
        }
      }
    }

    stage('Terraform Plan') {
      agent { label 'windows && terraform' }
      steps {
        terraformWorkflow('plan', env.TERRAFORM)
      }
    }

    stage('Deploy to Dev via GitOps') {
      when {
        branch 'main'
      }
      agent { label 'linux && docker' }
      steps {
        sh 'python scripts/update_helm_values.py dev ${IMAGE_TAG}'
        sh 'git config user.email "jenkins@acme.example.com"'
        sh 'git config user.name "Jenkins CI"'
        sh 'git add helm/platform-stack/values-dev.yaml'
        sh 'git commit -m "Update dev image tags to ${IMAGE_TAG}" || true'
        sh 'git push origin HEAD:main'
      }
    }
  }

  post {
    success {
      emailext subject: 'ACME EKS Pipeline Succeeded', body: 'Build succeeded.', to: 'platform-team@example.com'
      slackSend channel: '#platform-alerts', message: "ACME EKS pipeline succeeded for ${env.BRANCH_NAME}"
    }
    failure {
      emailext subject: 'ACME EKS Pipeline Failed', body: 'Build failed.', to: 'platform-team@example.com'
      slackSend channel: '#platform-alerts', message: "ACME EKS pipeline failed for ${env.BRANCH_NAME}"
    }
  }
}
