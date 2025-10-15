# Build from Jenkins LTS (long-term support) release
FROM jenkins/jenkins:lts

# Default Jenkins image user is not root
USER root

RUN apt update -y \
    && apt upgrade -y

# Install minimum required to setup LANforge automation
RUN apt install -y python3 python3-virtualenv
