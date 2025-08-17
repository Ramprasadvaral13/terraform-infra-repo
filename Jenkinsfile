pipeline {
    agent any
    parameters {
        choice(name: 'TERRAFORM_ACTION', choices: ['apply', 'destroy'], description: 'Terraform action')
    }
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        ANSIBLE_HOST_KEY_CHECKING = 'False'
    }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        disableConcurrentBuilds()
        timestamps()
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init -input=false'
            }
        }
        stage('Terraform Validate') {
            when { expression { params.TERRAFORM_ACTION == 'apply' } }
            steps {
                sh 'terraform validate'
            }
        }
        stage('Terraform Plan') {
            when { expression { params.TERRAFORM_ACTION == 'apply' } }
            steps {
                sh 'terraform plan -out=tfplan'
                archiveArtifacts artifacts: 'tfplan', allowEmptyArchive: true
            }
        }
        stage('Terraform Apply/Destroy') {
            steps {
                script {
                    if (params.TERRAFORM_ACTION == 'apply') {
                        sh 'terraform apply -auto-approve tfplan'
                    } else if (params.TERRAFORM_ACTION == 'destroy') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
        stage('Ansible - AMI Backup') {
            when { expression { params.TERRAFORM_ACTION == 'apply' } }
            steps {
                sh '''
                ansible-playbook -i inventory.aws_ec2.yml backup-create.yml --private-key ~/.ssh/clouddeva.pem
                '''
            }
        }
        stage('Ansible - Patch Linux') {
            when { expression { params.TERRAFORM_ACTION == 'apply' } }
            steps {
                sh '''
                ansible-playbook -i inventory.aws_ec2.yml patch-linux.yml --private-key ~/.ssh/clouddeva.pem
                '''
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: '*.tfstate*', allowEmptyArchive: true
            sh 'rm -f tfplan || true'
            cleanWs()
        }
        failure {
            mail to: 'your-team@example.com',
                 subject: "Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                 body: "Check details at ${env.BUILD_URL}"
        }
    }
}

