FROM quay.io/keycloak/keycloak:24.0.5-0 as builder

#* Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

#* Configure a database vendor
ENV KC_DB=postgres

#* Configure the working directory
WORKDIR /opt/keycloak
#* for demonstration purposes only, please make sure to use proper certificates in production instead
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
#* Add the custom plugin to the Keycloak server
#// ADD --chown=keycloak:keycloak --chmod=644 https://github.com/wadahiro/keycloak-discord/releases/download/v0.5.0/keycloak-discord-0.5.0.jar /opt/keycloak/providers/keycloak-discord-0.5.0.jar
#! Build the Keycloak server
RUN /opt/keycloak/bin/kc.sh build

#* Second stage, copy the built artifacts from the previous stage
FROM quay.io/keycloak/keycloak:24.0.5-0
COPY --from=builder /opt/keycloak/ /opt/keycloak/

#! change these values to point to a running postgres instance
ENV KC_DB_URL=jdbc:postgresql://kc-postgres:5432/keycloak
#~ username and password for the postgres instance
ENV KC_DB_USERNAME=admin
ENV KC_DB_PASSWORD=passwd1244
#~ username and password for the keycloak admin user
ENV KEYCLOAK_ADMIN=admin
ENV KEYCLOAK_ADMIN_PASSWORD=admin

#~ conf for the keycloak server
# MariaDB config needed to start
# ENV KC_TRANSACTION_XA_ENABLED=false
ENV KC_HOSTNAME_STRICT=false
ENV KC_HOSTNAME_STRICT_BACKCHANNEL=false
ENV KC_PROXY=passthrough
ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
CMD ["start", "--optimized"]