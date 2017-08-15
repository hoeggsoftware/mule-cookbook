pipeline {
    agent 
    stages {
        stage('test') {
            steps {
                sh 'bundle'
                sh 'kitchen-test'
            }
        }
    }
}
