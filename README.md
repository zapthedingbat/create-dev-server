# Create Development Server

This repository is a reference for setting up a basic development server running
Docker swarm on CentOS. It can be used to quickly deploy containerised projects
for tools, development and testing.

> **This configuration is not intended to run, consumer facing, production
> systems.** If you want to run production systems you might want to consider
> Kubernetes as a managed service like
> [GKE](https://cloud.google.com/kubernetes-engine/),
> [AKS](https://azure.microsoft.com/en-us/services/kubernetes-service/) or
> [EKS](https://aws.amazon.com/eks/)

## Host

The host machine will run the docker engine in swarm mode. This can be a
virtualised or physical server. Add an `automation` user with SSH access and
`sudo` permissions.

- [Bare Metal](./docs/bare-metal-host.md)
- [EC2 Instance](./docs/ec2-host.md)
- [Hyper-V](./docs/hyper-v-host.md)

## Docker Engine

Install Docker engine community edition on the server.

At the time of writing there is no official Centos 8 docker package. So we are
following the steps to work around this here
[How to Install Docker on CentOS 8](https://linoxide.com/linux-how-to/how-to-install-docker-on-centos/).
The official instructions for installing docker on older versions of Centos can
be found here https://docs.docker.com/install/linux/docker-ce/centos/

```
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf -y install docker-ce --nobest
```

Start docker service and confirm that it has started

```
sudo systemctl enable --now docker
systemctl status docker
```

Add the `automation` user to the `docker` group so it can execute `docker`
commands without `sudo`

```
sudo usermod -aG docker automation
```

Now log out and back in as the `automation` user for the group membership to
take effect.

You might need to disable the firewall service

```
sudo systemctl disable firewalld
```

Initialize a swarm mode

```
docker swarm init
```

### Public access

#### DNS

You might want to setup up a wildcard DNS record on a public domain or sub
domain that you own pointing to the public IP address of your server. e.g
`*.example.com` or `*.myserver.example.com`.

## CI

The CI server uses the `automation` user to connect to the server and apply our
docker configuration using terraform. The configuration that's used to connect
to the server is configured in [terraform.tfvars](./terraform/terraform.tfvars)

```
docker_ssh_user = "automation"
docker_ssh_host = "example.com"
docker_ssh_port = 22
```

### Terraform

Terraform writes the state data to
[a remote data store](https://www.terraform.io/docs/state/remote.html) so that
it can be persisted in a central location. For this we need a
"[backend](https://www.terraform.io/docs/backends/)"
