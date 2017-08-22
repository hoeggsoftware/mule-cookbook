pipeline {
    agent any
    stages {
        stage('test') {
            steps {
                sh '/home/jenkins/.rubies/current/bin/ruby --version'
                sh '/home/jenkins/.rubies/current/bin/gem install bundler'
                sh '/home/jenkins/.rubies/current/bin/gem list'
            }
        }
    }
}
