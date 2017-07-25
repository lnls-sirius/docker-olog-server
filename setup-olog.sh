#!/bin/sh

POSTGRES_DATASOURCE=org.postgresql.ds.PGConnectionPoolDataSource
MYSQL_DATASOURCE=com.mysql.jdbc.jdbc2.optional.MysqlConnectionPoolDataSource

RESOURCE_TYPE=javax.sql.ConnectionPoolDataSource
CONNECTION_POOL_NAME=OlogPool

DB_MYSQL_URL=jdbc:mysql://192.168.7.4:3306/
DB_POSTGRES_URL=jdbc:postgresql://192.168.7.3:5432/

DB_USER=lnls_olog_user
DB_PASSWORD=controle
DB_NAME=olog

REALM_CLASS_NAME=com.sun.enterprise.security.auth.realm.ldap.LDAPRealm
REALM_JAAS_CTX=ldapRealm
REALM_BASE_DN="\"OU=LNLS,DC=abtlus,DC=org,DC=br\""
REALM_URL="\"ldap://ad1.abtlus.org.br:389\""
REALM_SEARCH_FILTER="\"sAMAccountName=%s\""
REALM_SEARCH_BIND_DN="\"***REMOVED***\""
REALM_SEARCH_BIND_PASS="\"***REMOVED***\""

# Start asadmin console and the domain
asadmin start-domain

# Derby Connection Pool
asadmin start-database

echo "AS_ADMIN_PASSWORD=${ADMIN_PASSWORD}" > /tmp/glassfishpwd

#### POSTGRES
# Configures connection pool
asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
                create-jdbc-connection-pool \
                --datasourceclassname ${POSTGRES_DATASOURCE} \
                --restype ${RESOURCE_TYPE} \
                --property user=${DB_USER}:password=${DB_PASSWORD}:url=\"${DB_POSTGRES_URL}\":databaseName=${DB_NAME} \
                ${CONNECTION_POOL_NAME}

# Configures connection resource
asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
                create-jdbc-resource \
                --connectionpoolid ${CONNECTION_POOL_NAME} \
                jdbc/olog

#### MYSQL
# Configures connection pool
#asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
#                create-jdbc-connection-pool \
#                --datasourceclassname ${MYSQL_DATASOURCE} \
#                --restype ${RESOURCE_TYPE} \
#                --property user=${DB_USER}:password=${DB_PASSWORD}:url=\"${DB_MYSQL_URL}\":databaseName=${DB_NAME} \
#                ${CONNECTION_POOL_NAME}

# Configures connection resource
#asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
#                create-jdbc-resource \
#                --connectionpoolid ${CONNECTION_POOL_NAME} \
#                jdbc/olog

# Configures security realm

asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
                create-auth-realm \
                --classname ${REALM_CLASS_NAME} \
                --property jaas-context=${REALM_JAAS_CTX}:base-dn=${REALM_BASE_DN}:directory=${REALM_URL}:search-filter=${REALM_SEARCH_FILTER}:search-bind-dn=${REALM_SEARCH_BIND_DN}:search-bind-password=${REALM_SEARCH_BIND_PASS} \
                ologRealm

# Copies olog service to the server's directory
asadmin --user=admin --passwordfile=/tmp/glassfishpwd \
                deploy ${GLASSFISH_CONF_FOLDER}/olog-service-2.2.9.war

asadmin --user=admin stop-domain

rm -f /tmp/glassfishpwd

asadmin start-domain -v
