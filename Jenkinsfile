pipeline {
    agent any
    stages {
        environment {
            AWS_ACCESS_KEY_ID         = credentials('dev_aws_access_key_id')
            AWS_SECRET_ACCESS_KEY     = credentials('dev_aws_secret_access_key')
            DIGITALOCEAN_ACCESS_TOKEN = credentials('dev_digital_ocean_token')
        }
        stage('test') {
            steps {
                sh '/home/jenkins/.rubies/current/bin/gem install bundler'
                sh '/home/jenkins/.rubies/current/bin/bundle'
                sh '/home/jenkins/.rubies/current/bin/bundle exec rake cloud'
            }
        }
    }
}
