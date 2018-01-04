# Docker images for the Olog logging service

Docker image which wraps an Olog system instance.

## Building

1) Edit `env-vars.sh` parameters accordingly.
2) Execute `build-docker-olog-server.sh` to build the image. Before doing that, change `setup-olog.sh` to reflect your LDAP settings.

## Running

Execute `run-docker-olog.sh` to start a container with this image. This script should be used only during development. For production, use this image with Docker Compose, Swarm or Kubernetes, according to this [project](https://github.com/lnls-sirius/docker-olog-compose). Enjoy!

## Dockerhub

The image described by this project was pushed into [this Dockerhub repo](https://hub.docker.com/r/lnlscon/olog-server/).
