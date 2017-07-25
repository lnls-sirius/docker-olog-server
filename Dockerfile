#
# Docker image for logging service olog.
#
# Gustavo Ciotto Pinton
# Controls Group - Brazilian Synchrotron Light Source Laboratory - LNLS
#

FROM oracle/glassfish:latest

MAINTAINER Gustavo Ciotto

ENV GLASSFISH_CONF_FOLDER /opt/glassfish
ENV DERBY_RELEASE db-derby-10.12.1.1

RUN yum -y install wget

# Sets mysql connector jar
# ENV MYSQL_CONNECTOR mysql-connector-java-5.1.41
# RUN mkdir -p {GLASSFISH_CONF_FOLDER}/mysql
# RUN wget -P ${GLASSFISH_CONF_FOLDER}/mysql https://dev.mysql.com/get/Downloads/Connector-J/${MYSQL_CONNECTOR}.tar.gz
# RUN tar -C ${GLASSFISH_CONF_FOLDER}/mysql -xvf ${GLASSFISH_CONF_FOLDER}/mysql/${MYSQL_CONNECTOR}.tar.gz
# RUN cp ${GLASSFISH_CONF_FOLDER}/mysql/${MYSQL_CONNECTOR}/${MYSQL_CONNECTOR}-bin.jar ${GLASSFISH_HOME}/glassfish/lib
# RUN rm -R ${GLASSFISH_CONF_FOLDER}/mysql

# Sets postgresql connector jar
ENV POSTGRES_CONNECTOR postgresql-42.1.3.jre7
RUN mkdir -p ${GLASSFISH_HOME}/glassfish/lib
RUN wget -P ${GLASSFISH_HOME}/glassfish/lib https://jdbc.postgresql.org/download/${POSTGRES_CONNECTOR}.jar

# Fixes derby db bugs
RUN wget -P ${GLASSFISH_CONF_FOLDER} http://mirror.nbtelecom.com.br/apache//db/derby/db-derby-10.12.1.1/${DERBY_RELEASE}-bin.tar.gz
RUN tar -xvzf ${GLASSFISH_CONF_FOLDER}/${DERBY_RELEASE}-bin.tar.gz
RUN cp -r ${DERBY_RELEASE}-bin/* ${GLASSFISH_HOME}/javadb

COPY setup-olog.sh ${GLASSFISH_CONF_FOLDER}/setup-olog.sh
COPY olog-service-2.2.9.war ${GLASSFISH_CONF_FOLDER}/olog-service-2.2.9.war

CMD ["sh", "-c", "${GLASSFISH_CONF_FOLDER}/setup-olog.sh"]
