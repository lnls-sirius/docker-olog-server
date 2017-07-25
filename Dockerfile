#
# Docker image for logging service olog.
#
# Gustavo Ciotto Pinton
# Controls Group - Brazilian Synchrotron Light Source Laboratory - LNLS
#

FROM openjdk:6-jdk

MAINTAINER Gustavo Ciotto

ENV GLASSFISH_CONF_FOLDER /opt/glassfish
ENV GLASSFISH_HOME /glassfish3
ENV GLASSFISH_VERSION glassfish-3.1.2.2
ENV PATH=$PATH:${GLASSFISH_HOME}/bin

RUN mkdir -p ${GLASSFISH_HOME}

RUN wget -P ${GLASSFISH_CONF_FOLDER} http://download.oracle.com/glassfish/3.1.2.2/release/${GLASSFISH_VERSION}.zip
RUN unzip ${GLASSFISH_CONF_FOLDER}/${GLASSFISH_VERSION}.zip -d /
RUN rm ${GLASSFISH_CONF_FOLDER}/${GLASSFISH_VERSION}.zip

# Sets postgresql connector jar
ENV POSTGRES_CONNECTOR postgresql-42.1.3.jre6
RUN mkdir -p ${GLASSFISH_HOME}/glassfish/lib
RUN wget -P ${GLASSFISH_HOME}/glassfish/lib https://jdbc.postgresql.org/download/${POSTGRES_CONNECTOR}.jar

COPY setup-olog.sh ${GLASSFISH_CONF_FOLDER}/setup-olog.sh
COPY olog-service-2.2.9.war ${GLASSFISH_CONF_FOLDER}/olog-service-2.2.9.war

CMD ["sh", "-c", "${GLASSFISH_CONF_FOLDER}/setup-olog.sh"]
