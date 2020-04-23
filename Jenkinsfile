pipeline {
    agent any

    environment {
        AWS_ACCES_KEY_ID = credentials('AWS_ACCES_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        SERVER_A_ADDRESS = credentials('SERVER_A_ADDRESS')
        SERVER_B_ADDRESS = credentials('SERVER_B_ADDRESS')
    }

    stages {
         stage('Set Packer Path') {
            steps {
                script {
                    def packHome = tool name: 'Packer'
                    env.PATH = "${packHome}:${env.PATH}"
                }
                sh 'packer -version'
            }
        }
        stage('Build Nginx Image') {
            steps {
                sh "packer build \
                     -var aws_access_key=$AWS_ACCES_KEY_ID \
                     -var aws_secret_key=$AWS_SECRET_ACCESS_KEY \
                     -var server_a_address=$SERVER_A_ADDRESS\
                     -var server_b_address=$SERVER_B_ADDRESS\
                     packer-nginx.json"
            }
        }
    
        stage('Set Terraform Path') {
            steps {
                script {
                    def tfHome = tool name: 'Terraform'
                    env.PATH = "${tfHome}:${env.PATH}"
                }
                sh 'terraform -version'
            }
        }

        stage('Provision infrastructure') {
            steps {
                    sh 'terraform init'
                    sh "terraform plan -out=plan \
                        -var AWS_ACCES_KEY=$AWS_ACCES_KEY_ID \
                        -var AWS_SECRET_ACCESS=$AWS_SECRET_ACCESS_KEY"
                    // sh ‘terraform destroy -auto-approve’
                    sh 'terraform apply plan'
            }
        }

        // stage('Destroy infrastructure') {
        //     steps {
        //         dir('dev') {
        //             sh "terraform destroy -auto-approve \
        //             -var AWS_ACCES_KEY=$AWS_ACCES_KEY_ID \
        //             -var AWS_SECRET_ACCESS=$AWS_SECRET_ACCESS_KEY"
        //         }
        //     }
        // }
    }
}