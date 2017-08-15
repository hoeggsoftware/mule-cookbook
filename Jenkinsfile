pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                sh 'bundle'
                sh 'kitchen-test'
            }
        }
    }
}
