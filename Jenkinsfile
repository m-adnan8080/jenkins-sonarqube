// Get dynamically git commit-id and use in code as docker image tags number
def getVersion(){
    def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
    return commitHash
}

pipeline {

  environment{
    DOCKER_TAG = getVersion()
  }

  agent any
  tools {
    maven '3.6.3'
  }

  stages {

    // Sonarqube code quality gate check
    stage('Quality Gate Status Check'){
      steps{
        script{
          withSonarQubeEnv('sonarserver'){
            sh "mvn install"
            sh "mvn sonar:sonar"
          }
          timeout(time: 1, unit: 'HOURS'){
            def qg = waitForQualityGate()
            if (qg.status != 'OK'){
              error "Pipeline aborted due to quality gate failure : ${qg.status}"
            }
          }
          sh 'mvn clean package'
        }
      }
    }

    // Publish maven package to Nexus Artifactory server
    stage('Push maven package to Nexus Artifactory server'){
      steps{
        nexusPublisher nexusInstanceId: 'Nenus',
        nexusRepositoryId: 'local-maven2-releases',
        packages: [[
          $class: 'MavenPackage',
          mavenAssetList: [[
            classifier: '',
            extension: '',
            filePath: '/var/lib/jenkins/workspace/test/target/spring-boot-0.0.1-SNAPSHOT.jar'
          ]],
          mavenCoordinate: [
            artifactId: 'spring-boot',
            groupId: 'com.example',
            packaging: 'jar',
            version: ("$currentBuild.number.0.0")
          ]
        ]]
      }
    }

    // Build myapp.jar in Docker image
    stage('Build Docker Image from Maven package'){
      steps{
        sh 'docker build . -t spring-boot-sample-app:${DOCKER_TAG}'
        sh 'docker tag spring-boot-sample-app:${DOCKER_TAG} 192.168.100.12:8000/spring-boot-sample-app:${DOCKER_TAG}'
      }
    }

    // Push docker image to Nexus Docker repo
    stage('Docker push image to Nexus Docker Repo'){
      steps{
        script{
          withDockerRegistry(credentialsId: 'nexus-jenkins-user', url: 'http://192.168.100.12:8000/v1') {
            sh 'docker push 192.168.100.12:8000/spring-boot-sample-app:${DOCKER_TAG}'
          }
        }
      }
    }

    // remove docker image from Jenkins server
    stage('Remove Docker Images and container after push to Artifactory server'){
      steps{
        sh 'docker container prune -f'
        sh 'docker rmi -f spring-boot-sample-app:${DOCKER_TAG}'
        sh 'docker rmi -f 192.168.100.12:8000/spring-boot-sample-app:${DOCKER_TAG}'
        sh 'docker image prune -f'
      }
    }

    // Deploy docker image of remote server using Ansible playbook present in code directory
    stage('Docker Deploy'){
        steps{
          ansiblePlaybook colorized: true, extras: '-e DOCKER_TAG=${DOCKER_TAG}', installation: 'Ansible', inventory: 'examples/dev.inv', playbook: 'examples/deploy-docker.yml'
        }
    }
  }

  post {
    always {
      cleanWs()
    }
  }
}
