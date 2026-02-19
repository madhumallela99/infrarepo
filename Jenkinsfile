pipeline {
  agent any
  tools {
  git 'Default'
}


  stages {
    stage('Checkout') {
      steps { 
      git branch: 'main', url: 'https://github.com/madhumallela99/infrarepo.git'
    }
    }

    stage('Terraform Init') {
      steps { sh 'terraform init -upgrade' }
    }

    stage('Terraform Validate') {
      steps { sh 'terraform validate' }
    }

    stage('Terraform Plan') {
      steps { sh 'terraform plan -out=tfplan' }
    }

    stage('Terraform Apply') {
      steps { sh 'terraform apply -auto-approve tfplan' }
    }
  }
}




