pipeline {
  environment{
    JAVA_TOOL_OPTIONS="-Duser.home=/tmp"
  }
  agent
  { // To use maven inside docker container and also
    // mount jenkins_home/.m2 directory to docker /root/.m2 directory
    docker {
      image 'maven:3.6.3-openjdk-8'
      args '-v $HOME/data:/tmp/data/ -v $HOME/.m2:/tmp/.m2 -e MAVEN_CONFIG=/tmp/.m2'
    }
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
          sh 'cp target/spring-boot-0.0.1-SNAPSHOT.jar /tmp/data/myapp.jar'
        }
      }
    }
  }

  post {
    always {
      cleanWs()
    }
  }
}


// pipeline{
//     agent any

//     // Define tools installed/configured at Jenkins configuration file.
//     tools {
//       maven 'maven3'
//     }

//     // Define Variable globally
//     environment {
//       DOCKER_TAG = getVersion()
//     }
//     stages{

//         // Get code from github
//         stage('SCM'){
//             steps{
//                 git credentialsId: 'github',
//                     url: 'https://github.com/javahometech/dockeransiblejenkins'
//             }
//         }

//         // Build code via Maven
//         stage('Maven Build'){
//             steps{
//                 sh "mvn clean package"
//             }
//         }

//         // Docker build image using Dockerfile in code directory
//         stage('Docker Build'){
//             steps{
//                 sh "docker build . -t kammana/hariapp:${DOCKER_TAG} "
//             }
//         }

//         // Push build docker image to docker hub
//         stage('DockerHub Push'){
//             steps{
//                 withCredentials([string(credentialsId: 'docker-hub', variable: 'dockerHubPwd')]) {
//                     sh "docker login -u kammana -p ${dockerHubPwd}"
//                 }
//                 sh "docker push kammana/hariapp:${DOCKER_TAG} "
//             }
//         }

//         // Deploy docker image of remote server using Ansible playbook present in code directory
//         stage('Docker Deploy'){
//             steps{
//               ansiblePlaybook credentialsId: 'dev-server', disableHostKeyChecking: true, extras: "-e DOCKER_TAG=${DOCKER_TAG}", installation: 'ansible', inventory: 'dev.inv', playbook: 'deploy-docker.yml'
//             }
//         }
//     }
// }

// Get dynamically git commit-id and use in code as docker image tags number
// def getVersion(){
//     def commitHash = sh label: '', returnStdout: true, script: 'git rev-parse --short HEAD'
//     return commitHash
// }