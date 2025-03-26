FROM jenkins/jenkins:lts

USER root

# Install git and docker
RUN apt-get update && \
    apt-get install -y git docker.io

USER jenkins