# Docker images for the Olog logging service

Docker image which wraps an Olog system instance.

## Building

1) Edit `env-vars.sh` parameters accordingly.
2) Execute `build-docker-olog-server.sh` to build the image. Before doing that, change `setup-olog.sh` to reflect your LDAP settings.

## Running

To run this image, use Docker Compose, Swarm or Kubernetes configuration files provided in this [project](https://github.com/lnls-sirius/docker-olog-compose). Enjoy!

## Dockerhub

The image described by this project was pushed into [this Dockerhub repo](https://hub.docker.com/r/lnlscon/olog-server/).
