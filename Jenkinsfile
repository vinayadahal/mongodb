pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS= credentials('docker-hub-credentials')
    }

    stages {
        stage('Docker Build') {
            steps {
                script {
                    def branch_name=env.BRANCH_NAME
                    if (branch_name == "main") {
                        echo "Building docker image with 'latest' tag"
                        sh 'docker build -t bidahal/mongodb .'
                    } else if (branch_name == "stg") {
                        echo "Building docker image with 'stg' tag"
                        sh 'docker build -t bidahal/mongodb:stg .'
                    } else if (branch_name == "dev") {
                        echo "Building docker image with 'dev' tag"
                        sh 'docker build -t bidahal/mongodb:dev .'
                    } else {
                        echo "Building docker image without a tag for feature branch: $branch_name"
                        sh 'docker build -t bidahal/mongodb .'
                    }
                }
            }
        }
        stage('Docker Login and Push') {
            steps {
                script {
                    def branch_name=env.BRANCH_NAME
                    if (branch_name == "main") {
                        echo "Logging into docker hub and pushing the changes to 'main' tag"
                        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                        sh 'docker push bidahal/mongodb'
                    } else if (branch_name == "stg") {
                        echo "Logging into docker hub and pushing the changes to 'stg' tag"
                        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                        sh 'docker push bidahal/mongodb:stg'
                    } else if (branch_name == "dev") {
                        echo "Logging into docker hub and pushing the changes to 'dev' tag"
                        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                        sh 'docker push bidahal/mongodb:dev'
                    } else {
                        echo "Skipping docker login and push for feature branch: $branch_name..."
                    }
                }
            }
        }
        stage('Deploy k8s') {
            steps {
                script {
                    def branch_name=env.BRANCH_NAME
                    if (branch_name == "main") {
                        echo "Applying changes to the main k8s cluster"
                        sh 'kubectl apply -f k8s/main/01-application-namespace.yml'
                        sh 'kubectl apply -f k8s/main/02-configmap-mongo.yml'
                        sh 'kubectl apply -f k8s/main/03-secret-mongo.yml'
                        sh 'kubectl apply -f k8s/main/04-pvc-mongo.yml'
                        sh 'kubectl apply -f k8s/main/05-deploy-mongodb.yml'
                    } else if (branch_name == "stg") {
                        echo "Applying changes to the main k8s cluster for stg branch"
                        sh 'kubectl apply -f k8s/stg/01-application-namespace.yml'
                        sh 'kubectl apply -f k8s/stg/02-configmap-mongo.yml'
                        sh 'kubectl apply -f k8s/stg/03-secret-mongo.yml'
                        sh 'kubectl apply -f k8s/stg/04-pvc-mongo.yml'
                        sh 'kubectl apply -f k8s/stg/05-deploy-mongodb.yml'
                    } else if (branch_name == "dev") {
                        echo "Applying changes to the main k8s cluster for dev branch"
                        sh 'kubectl apply -f k8s/dev/01-application-namespace.yml'
                        sh 'kubectl apply -f k8s/dev/02-configmap-mongo.yml'
                        sh 'kubectl apply -f k8s/dev/03-secret-mongo.yml'
                        sh 'kubectl apply -f k8s/dev/04-pvc-mongo.yml'
                        sh 'kubectl apply -f k8s/dev/05-deploy-mongodb.yml'
                    } else {
                        echo "Skipping deploy for feature branch: $branch_name..."
                    }
                }
            }
        }
        stage('Deploy latest image') {
            steps {
                script {
                    def branch_name=env.BRANCH_NAME
                    if (branch_name == "main") {
                        echo "Replace image in the cluster for main branch"
                        sh 'kubectl set image statefulset/adex-webapp-mongo-stateful adex-webapp-mongo-pod=bidahal/mongodb:latest -n adex-webapp'
                    } else if (branch_name == "stg") {
                        echo "Replace image in the cluster for stg branch"
                        sh 'kubectl set image statefulset/adex-webapp-mongo-stateful-stg adex-webapp-mongo-pod-stg=bidahal/mongodb:stg -n adex-webapp-stg'
                    } else if (branch_name == "dev") {
                        echo "Replace image in the cluster for dev branch"
                        sh 'kubectl set image statefulset/adex-webapp-mongo-stateful-dev adex-webapp-mongo-pod-dev=bidahal/mongodb:dev -n adex-webapp-dev'
                    } else {
                        echo "Skipping deploy for feature branch: $branch_name..."
                    }
                }
            }
        }
    }
}