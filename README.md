# Owncloud with Docker Compose

Run your Owncloud with Docker Compose.

## Quick Setup

1. Make sure Docker and Docker Compose are installed on your machine, see http://docs.docker.com/compose/install/
2. `mkdir -p /usr/share/webapps/owncloud` or wherever you want to put you configuration
3. `curl https://raw.githubusercontent.com/pwintermantel/owncloud-docker/master/docker-compose.yml -o docker-compose.yml`
4. `cd /usr/share/webapps/owncloud`
5. Optional: Customize the docker-compose.yml, you should at least change `POSTGRES_PASSWORD`.
6. `docker-compose up`

From there you can access the Web interface running on port 8001 and start with the Owncloud Installation Wizard. If you choose the Postgres Backend make sure you enter `db` as your database host and credentials provided in the docker-compose.yml.

Your data is persisted within the storage container and the owncloud image can be updated easily.

## Nginx SSL Proxy

This particular configuration is intended to sit behind a Nginx proxy. You can use the following configuration:

```
server {
  listen 80;
  server_name cloud.host.tld;
  rewrite ^ https://$server_name$request_uri? permanent;
}

server {
  server_name cloud.host.tld;
  listen 443 ssl;

  ssl_certificate      /etc/ssl/certs/cloud.host.tld.crt;
  ssl_certificate_key  /etc/ssl/private/cloud.host.tld.crt;

  location / {
    proxy_set_header X-Forwarded-Proto https;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_pass http://localhost:8001;
  }
}
```

Make sure you block the port `8001` in your firewall or bind the docker-compose.yml port configuration to "127.0.0.1:8001:80" to prevent bypassing the ssl proxy.

## Other settings

### Standalone

Of course you can run the container without proxy and bind port 80 directly to the host. If you want to use SSL you can add a volume `/etc/nginx/`, change the config files provide your crt/key files.


### Host Volumes
If you prefer to have direct access to the data form the host you can change the volumes of the storage container to be mounted from host e.g.

```
storage:
  image: busybox
  volumes:
    - ./db:/var/lib/postgresql/data 
    - ./data:/usr/share/webapps/owncloud/data
    - ./config:/etc/webapps/owncloud/config
```

If you change it after the creation of the container you will have to backup and restore the files.

