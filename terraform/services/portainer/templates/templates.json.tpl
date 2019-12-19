[
  {
    "type": 2,
    "title": "Web Application",
    "description": "Generic web application",
    "image": "nginx",
    "name": "Web application",
    "network": "public-network",
    "labels": [
      {
        "name": "traefik.enable",
        "value": "true"
      },
      {
        "name": "traefik.http.routers.${dns-name}.entrypoints",
        "value": "https"
      },
      {
        "name": "traefik.http.routers.${dns-name}.rule",
        "value": "Host(`${dns-name}.${domain}`)"
      },
      {
        "name": "traefik.http.routers.${dns-name}.tls.certresolver",
        "value": "le-dns"
      },
      {
        "name": "traefik.http.routers.${dns-name}.tls.domains[0].main",
        "value": "${domain}"
      },
      {
        "name": "traefik.http.routers.${dns-name}.tls.domains[0].sans",
        "value": "*.${domain}"
      },
      {
        "name": "traefik.http.services.${dns-name}.loadbalancer.server.port",
        "value": "${port}"
      }
    ],
    "restart_policy": "unless-stopped",
    "platform": "linux"
  }
]
