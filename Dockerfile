#
# Docker image for logging service olog.
#
# Gustavo Ciotto Pinton
# Controls Group - Brazilian Synchrotron Light Source Laboratory - LNLS
#

FROM openjdk:8-jdk

MAINTAINER Gustavo Ciotto

ENV GLASSFISH_CONF_FOLDER /opt/glassfish
ENV GLASSFISH_HOME /glassfish4
ENV GLASSFISH_VERSION 4.1.1
ENV PATH=$PATH:${GLASSFISH_HOME}/bin

RUN mkdir -p ${GLASSFISH_HOME}

RUN wget -P ${GLASSFISH_CONF_FOLDER} http://download.oracle.com/glassfish/${GLASSFISH_VERSION}/release/glassfish-${GLASSFISH_VERSION}.zip
RUN unzip ${GLASSFISH_CONF_FOLDER}/glassfish-${GLASSFISH_VERSION}.zip -d /
RUN rm ${GLASSFISH_CONF_FOLDER}/glassfish-${GLASSFISH_VERSION}.zip


# Sets postgresql connector jar
ENV POSTGRES_CONNECTOR postgresql-42.1.4
RUN mkdir -p ${GLASSFISH_HOME}/glassfish/lib
RUN wget -P ${GLASSFISH_HOME}/glassfish/lib https://jdbc.postgresql.org/download/${POSTGRES_CONNECTOR}.jar

# Sets mysql connector jar
ENV MYSQL_CONNECTOR mysql-connector-java-5.1.41
RUN wget -P ${GLASSFISH_CONF_FOLDER} https://dev.mysql.com/get/Downloads/Connector-J/${MYSQL_CONNECTOR}.tar.gz
RUN tar -C ${GLASSFISH_CONF_FOLDER} -xvf ${GLASSFISH_CONF_FOLDER}/${MYSQL_CONNECTOR}.tar.gz
RUN rm ${GLASSFISH_CONF_FOLDER}/${MYSQL_CONNECTOR}.tar.gz
RUN mv ${GLASSFISH_CONF_FOLDER}/${MYSQL_CONNECTOR}/${MYSQL_CONNECTOR}-bin.jar ${GLASSFISH_HOME}/glassfish/lib
RUN rm -R ${GLASSFISH_CONF_FOLDER}/${MYSQL_CONNECTOR}

# RUN apt-get update && apt-get install nano

# Clones olog web client
RUN git clone https://github.com/Olog/logbook.git ${GLASSFISH_CONF_FOLDER}/logbook

# Retrieves wait-for-it.sh script

RUN mkdir -p /opt/wait-for-it
RUN git clone https://github.com/vishnubob/wait-for-it.git /opt/wait-for-it

COPY bin/olog-service-2.2.9.war ${GLASSFISH_CONF_FOLDER}/olog-service-2.2.9.war

COPY setup-olog.sh index.html ${GLASSFISH_CONF_FOLDER}/

CMD ["sh", "-c", "${GLASSFISH_CONF_FOLDER}/setup-olog.sh"]
