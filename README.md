# Jenkins Automation Example

Self-contained repository demonstrating basic Jenkins configuration for usage in LANforge test automation.

## Assumptions

- **Familiarity with Linux, Bash, and some familiarity with Docker**

- **Dedicated, non-LANforge test runner system to run Jenkins and test scripts**

    * Default Jenkins configuration runs automation jobs on same node as Jenkins WebUI.
  
    * Recommended to not run this directly on LANforge system, as configuration will
      be more difficult given assumptions made by LANforge software. LANforge is
      especially not designed to share a system which also runs Docker, which
      this example leverages to run Jenkins.

## Setup

**NOTE:** Many of these commands may require root permissions (e.g. using `sudo`) unless
you add the user to the `docker` group after installation. Doing so will require relogin
or reboot and effectively gives the user permanent root permissions. Use with care.

1. **Install Docker and Docker Compose on dedicated Jenkins system**

    Instructions will vary both in terms of platform as well as where you find them... For the
    purposes of this example, only the Docker Engine and Docker Compose plugin are required.

    Older documentation may reference a `docker-compose` package for older Docker Compose v1.
    Docker Compose v1 will work for this guide, but long-term use is not recommended.

    We recommend the following guides:

    - Install Docker Engine
        * [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
        * [Fedora](https://docs.docker.com/engine/install/fedora/)

    - Install Docker Compose plugin
        * [Ubuntu and Fedora](https://docs.docker.com/compose/install/linux/) (Fedora is an RPM-based distribution)

2. **Clone this repository to dedicated Jenkins system**

3. **Enter into the `jenkins/` directory**
  
   ```Bash
   cd jenkins
   ```

3. **Create dedicated volume for Jenkins data storage**

    For non-example use, we recommend redundant storage with backups

    * Create `.env` file base directory of repository
  
      ```Bash
      touch .env
      ```
  
    * Configure the `.env` file based on your system setup

      Example configuration is below. Adjust to your use case.
      You will need to create the `JENKINS_HOME_PATH` below, if it doesn't exist (e.g. `mkdir /opt/jenkins`).
      As this is used as a Docker volume, an absolute path is required (cannot use something like `./jenkins`).
  
      ```Bash
      JENKINS_HOME_PATH=/opt/jenkins/
      ```

3. **Build custom example LANforge Jenkins Docker image**

    Example LAnforge Jenkins Docker image is just the base Jenkins LTS image with Python3 support.
  
    ```Bash
    # The '-t' option 'tags' the image with a name and version, here the name is 'jenkins-lanforge' and the version is 'latest'
    docker build -t jenkins-lanforge:latest .
    ```
  
    Verify the image was built using the `docker image ls` command. For example:
    ```Bash
    [user@jenkins-system:~]$ docker image ls
    REPOSITORY          TAG       IMAGE ID       CREATED         SIZE
    jenkins-lanforge    latest    bfd232179979   20 hours ago    894MB
    ```

4. **Run Jenkins server**

    ```Bash
    # Remove the '-d' flag to not run in the background (daemon mode)
    docker compose up -d
    ```

    To stop the server, if run with `-d` run the following command *in the same directory as the
    [`docker-compose.yml`](./docker-compose.yml) file. Otherwise, just enter `CTRL+C`.

    ```Bash
    docker compose down
    ```

    See [this section](#useful-docker-commands) for more Docker commands.

## Useful Docker Commands

**NOTE:** Docker Compose commands must be run *in the same directory as the configuration file*

### Docker Compose Commands

- **Start Docker Compose services**

    * Run in foreground

      ```Bash
      docker compose up
      ```

    * Run in background (daemonized)

      ```Bash
      docker compose up -d
      ```

- **Stop Docker Compose services**

    * Run in foreground

      Enter `CTRL+C`

    * Run in background (daemonized)

      ```Bash
      docker compose up -d
      ```

- **Display Docker Compose service statistics**

    ```Bash
    docker compose stats
    ```

- **Display Docker Compose service running processes**

    ```Bash
    docker compose top
    ```

- **Display Docker Compose service running processes**

    ```Bash
    docker compose top
    ```

### Docker Commands

- **List Docker containers (running only)**

    ```Bash
    docker container ls
    ```

- **List Docker containers (all)**

    ```Bash
    docker container ls --all
    ```

- **List Docker images**

    ```Bash
    docker image ls
    ```

- **List Docker images (all)**

    ```Bash
    docker image ls --all
    ```

- **Remove Docker image**

    You must stop any running containers using this image to delete it.
    If using Docker Compose to define and run containers, strongly
    recommended to use Docker Compose to stop containers.

    ```Bash
    docker image rm jenkins-lanforge:latest
    ```
