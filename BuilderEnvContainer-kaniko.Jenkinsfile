@Library('jenkins-sharedlibs')_

pipeline {
    agent {
        kubernetes {
            cloud 'Kubernetes-dev'
            defaultContainer 'jnlp'
            yamlFile 'containerBuildPod.yaml'
            showRawYaml(false)
        }
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '10'))
        timestamps()
        timeout(activity: true, time: 60, unit: 'MINUTES')
    }

    stages {
        stage('Configure Environment') {
            steps {
                container('jnlp') {
                    updateDependentFiles('project.settings')
                }
            }
        }

        stage('Build Container') {
            steps {
                container('kaniko') {
                    kanikoCmdLine()
                }
            }
        }
    }

    post {
        always {
            kafkaBuildReporter()
        }
    }
}
