#!/bin/sh

export PATH=${PATH}:${GLASSFISH_HOME}/bin

POSTGRES_DATASOURCE=org.postgresql.ds.PGConnectionPoolDataSource
MYSQL_DATASOURCE=com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource

RESOURCE_TYPE=javax.sql.ConnectionPoolDataSource
CONNECTION_POOL_NAME=OlogPool

DB_POSTGRES_URL=jdbc:postgresql://192.168.7.3:5432/olog
DB_MYSQL_URL=192.168.7.3

DB_USER=lnls_olog_user
DB_PASSWORD=controle
DB_NAME=olog

REALM_CLASS_NAME=com.sun.enterprise.security.auth.realm.ldap.LDAPRealm

REALM_JAAS_CTX=ldapRealm
REALM_BASE_DN="\"cn=users,dc=lnls,dc=br\""
REALM_GROUP_DN="\"cn=olog-admin,dc=lnls,dc=br\""
REALM_URL="\"ldap://10.0.4.57:389\""
REALM_SEARCH_FILTER="\"uid=%s\""
REALM_GROUP_FILTER="\"memberuid=%s\""

# REALM_BASE_DN="\"OU=LNLS,DC=abtlus,DC=org,DC=br\""
# REALM_URL="\"ldap://ad1.abtlus.org.br:389\""
# REALM_SEARCH_FILTER="\"sAMAccountName=%s\""
# REALM_SEARCH_BIND_DN="\"***REMOVED***\""
# REALM_SEARCH_BIND_PASS="\"***REMOVED***\""

JNDI_RESOURCE_TYPE="javax.naming.directory.Directory"
JNDI_FACTORY_CLASS="com.sun.jndi.ldap.LdapCtxFactory"
JNDI_URL="\"ldap://10.0.4.57:389/cn=users,dc=lnls,dc=br\""
JNDI_PRINCIPAL="\"cn=olog-admin,dc=lnls,dc=br\""

DERBY_CLASSPATH="/glassfish3/javadb/lib/derby.jar:/glassfish3/javadb/lib/derbynet.jar:/glassfish3/javadb/lib/derbytools.jar:/glassfish3/javadb/lib/derbyclient.jar"
DERBY_POLICIES=${GLASSFISH_CONF_FOLDER}/server.policy

echo "AS_ADMIN_PASSWORD=" > /tmp/glassfishpwd
echo "AS_ADMIN_NEWPASSWORD=${ADMIN_PASSWORD}" >> /tmp/glassfishpwd

asadmin --user=admin --passwordfile=/tmp/glassfishpwd change-admin-password --domain_name domain1

# Start asadmin console and the domain
asadmin start-domain

echo "AS_ADMIN_PASSWORD=${ADMIN_PASSWORD}" > /tmp/glassfishpwd

asadmin --user=admin --passwordfile=/tmp/glassfishpwd --host localhost --port 4848 enable-secure-admin

asadmin --user=admin --passwordfile=/tmp/glassfishpwd delete-ssl --type http-listener http-listener-2

asadmin restart-domain

# Grant derby socket permissions and starts derby connection pool
#java -Djava.security.manager -Djava.security.policy=${DERBY_POLICIES} -classpath ${DERBY_CLASSPATH} org.apache.derby.drda.NetworkServerControl start &
asadmin --user=admin --passwordfile=/tmp/glassfishpwd start-database

#### POSTGRES
# Configures connection pool
# asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
#                 create-jdbc-connection-pool \
#                 --datasourceclassname ${POSTGRES_DATASOURCE} \
#                 --restype ${RESOURCE_TYPE} \
#                 --property User=${DB_USER}:Password=${DB_PASSWORD}:Url=\"${DB_POSTGRES_URL}\":DatabaseName=${DB_NAME} \
#                 ${CONNECTION_POOL_NAME}
#
# # Configures connection resource
# asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
#                 create-jdbc-resource \
#                 --connectionpoolid ${CONNECTION_POOL_NAME} \
#                 jdbc/olog

#### MYSQL
# Configures connection pool
asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
               create-jdbc-connection-pool \
               --datasourceclassname ${MYSQL_DATASOURCE} \
               --restype ${RESOURCE_TYPE} \
               --property User=${DB_USER}:Password=${DB_PASSWORD}:ServerName=\"${DB_MYSQL_URL}\":DatabaseName=${DB_NAME} \
               ${CONNECTION_POOL_NAME}

#Configures connection resource
asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
               create-jdbc-resource \
               --connectionpoolid ${CONNECTION_POOL_NAME} \
               jdbc/olog

# Configures security realm
# Local LDAP
asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
                create-auth-realm \
                --classname ${REALM_CLASS_NAME} \
                --property jaas-context=${REALM_JAAS_CTX}:base-dn=${REALM_BASE_DN}:directory=${REALM_URL}:search-filter=${REALM_SEARCH_FILTER}:group-base-dn=${REALM_GROUP_DN}:group-search-filter=${REALM_GROUP_FILTER}:assign-groups="Administrator, TagMod, LogbookMod, LogMod" \
                olog

# CNPEM's LDAP
# asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
#                 create-auth-realm \
#                 --classname ${REALM_CLASS_NAME} \
#                 --property jaas-context=${REALM_JAAS_CTX}:base-dn=${REALM_BASE_DN}:directory=${REALM_URL}:search-filter=${REALM_SEARCH_FILTER}:search-bind-dn=${REALM_SEARCH_BIND_DN}:search-bind-password=${REALM_SEARCH_BIND_PASS}:assign-groups="Administrator, TagMod, LogbookMod, LogMod" \
#                 olog

# Configures JNDI resource
asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
                create-custom-resource \
                --restype ${JNDI_RESOURCE_TYPE} \
                --factoryclass ${JNDI_FACTORY_CLASS} \
                --property URL=${JNDI_URL}:javax.naming.security.principal=${JNDI_PRINCIPAL} \
                ologGroups

asadmin --user=admin restart-domain

# Copies olog service to the server's directory
asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
                deploy ${GLASSFISH_CONF_FOLDER}/olog-service-2.2.9.war

# Copies web client
cp -r ${GLASSFISH_CONF_FOLDER}/logbook/Olog/public_html/* ${GLASSFISH_HOME}/glassfish/domains/domain1/applications/olog-service-2.2.9

# Changes web manager settings
sed -i "s/allowDeletingLogs = false/allowDeletingLogs = true/" ${GLASSFISH_HOME}/glassfish/domains/domain1/applications/olog-service-2.2.9/static/js/configuration.js
sed -i "s/logId = \$log.attr('id');/logId = xml.log[0].id;/" ${GLASSFISH_HOME}/glassfish/domains/domain1/applications/olog-service-2.2.9/static/js/rest.js


asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
                stop-domain

rm -f /tmp/glassfishpwd

asadmin start-domain -v
