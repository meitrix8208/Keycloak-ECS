# Keycloak-ECS

## In AWS ECS

> [!CAUTION]
>
> - Target Group: Port 8443 in https
> - Health Check: /health/ready in https
> - Security Group: Port 8443
> - __ENV VARIABLES:__
> - - PROXY_ADDRESS_FORWARDING=true
> - - KC_PROXY=passthrough
> - - KC_HOSTNAME_STRICT_HTTPS=false

## Keycloak Dev all-in-one

```bash
docker compose up -d
```

## Keycloak docker image

```bash
docker build -t keycloak:local .
```

## keycloak docker command

```bash
docker run --name keycloak -d -p 8443:8443 keycloak:local
```

## Postgres docker command

```bash
docker run --name kc-postgres -d -p 5432:5432 -e POSTGRES_USER=admin -e POSTGRES_DB=keycloak -e POSTGRES_PASSWORD=passwd1244 postgres:16.3-alpine
```

> [!TIP]
>
> ## Caddy server for https
>
> ```bash
>  caddy run -c Caddyfile
> ```
