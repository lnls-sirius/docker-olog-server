# Docker images for the Olog logging service

Docker image which wraps an Olog system instance.

## Building

1) Edit `env-vars.sh` parameters accordingly.
2) Execute `build-docker-olog-server.sh` to build the image. Before doing that, change `setup-olog.sh` to reflect your LDAP settings.

## Running

To run this image, use Docker Compose, Swarm or Kubernetes configuration files provided in this [project](https://github.com/lnls-sirius/docker-olog-compose). Enjoy!

### Environment variables

This image expects that the following variables be overriden when it is executed: 

1) `ADMIN_PASSWORD` is the password used for administrative functions. It must used to access the web interface through the port 4848 or with any `asadmin` command inside the container. By default, it is set to `controle`.
2) `CERTIFICATE_PASSWORD` is the password which will be used to create the auto-signed certificate for secure connections. The default value for this parameter is `controle`.

Database's environment variables: 

1) `DB_USER` is the username used to connect to the database.
2) `DB_PASSWORD` is the password.
3) `DB_NAME` is the database's name. The default value is `olog`.
4) `DB_URL` is the database's hostname or IP address. The default value for this parameter is set to the hostname of the [MySQL database container](https://github.com/lnls-sirius/docker-olog-compose/blob/master/swarm/docker-swarm.yml), i.e, `olog-mysql-db`.

LDAP authentication server's environment variables:

1) `REALM_BASE_DN` is the user base distinguished name. 
2) `REALM_URL` is the server's URL.
3) `REALM_SEARCH_FILTER` is the user search filter.
4) `REALM_GROUP_FILTER` is the group search filter.
4) `REALM_SEARCH_BIND_DN` is the binding distinguished name. Optional parameter.
5) `REALM_SEARCH_BIND_PASS` is the binding password. Optional parameter.

## Dockerhub

The image described by this project was pushed into [this Dockerhub repo](https://hub.docker.com/r/lnlscon/olog-server/).
