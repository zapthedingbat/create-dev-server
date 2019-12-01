# Server Configuration

Development server configuration

This repository is a reference for setting up a basic development server running
Docker swarm on CentOS

### DNS

Setup a wildcard DNS record pointing to the public IP address of your server.
e.g `*.server1.zapthedingbat.com`.

### Ports

If we're running this on a physical machine ensure ports 80 and 443 are
forwarded to the machines NIC so it can serve traffic to the public internet.
You might also want ot open up other ports like 22 for SSH access.

### SSH access

Get the server running OpenSSH server and get yourself SSH access to it.

### Docker swarm

Install Docker engine https://docs.docker.com/install/linux/docker-ce/centos/

Start docker on boot

```
$ sudo systemctl enable docker
```

Start docker

```
$ sudo systemctl start docker
```

Initialize a swarm mode

```
docker swarm init
```

### Traefik

To to route requests to our docker services we will use Traefik. THis runs as a
service in docker.

- Copy `/srv/traefik/docker-compose.yml` to the server _NB_ _You will need to
  update the host rule in this file to match your DNS_

- Deploy the service
  ```
  docker stack deploy -c /srv/docker/traefik/docker-compose.yml traefik
  ```

You should now be able to navigate to the domain configured in the
`docker-compose.yml` and see the traefik dashboard. E.g
[traefik.server1.zapthedingbat.com](https://traefik.server1.zapthedingbat.com/)
