# Create Development Server

This repository is a reference for setting up a basic development server running
Docker swarm on CentOS. It can be used to quickly deploy containerised projects
for tools, development and testing.

**This configuration is not intended to run, consumer facing, production
systems.** If you want to run production systems you might want to consider
Kubernetes as a managed service like
[GKE](https://cloud.google.com/kubernetes-engine/),
[AKS](https://azure.microsoft.com/en-us/services/kubernetes-service/) or
[EKS](https://aws.amazon.com/eks/)

## Host Machine

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

## Public internet access

#### DNS

You might want to setup up a wildcard DNS record on a public domain or sub
domain that you own pointing to the public IP address of your server. e.g
`*.example.com` or `*.myserver.example.com`.

## Continuous Integration

### Terraform

We'll use Terrafrom to
[apply insfastructure changes using CI](https://learn.hashicorp.com/terraform/development/running-terraform-in-automation).
This means infrascructure changes are not made interactivly from developers
macheines but, instead are applied by the CI server as the result of changes
being made to the description of the infrastructure in version control.

Terraform maintains
[it's own representation of state in a remote store](https://www.terraform.io/docs/state/remote.html).
When the desired state of the infrastructure is changed, it compares the desired
state with it's own version of the state to determine what actions to take to
reach the desired state.

Terraform can kinda' bootstrap the creation of the remote store itself and then
start using it for state storage.

#### Cloud platfrom automation user

A cloud platfrom provider like AWS to can be used for Terraform remote state and
services like DNS, or starage. We want to use terrafrom to manage as much of our
infrastructure as possable so we'll need to give terrafrom the permissions it
needs to make changes in our cloud platform provider.

Create a user in your cloud provider that will be used by the CI server to apply
terrafrom and create, update and delete resources. We'll call the user
`automation` for consistancy.

- [Amazon Web Services](./docs/aws-automation-user.md)
- [Microsoft Azure](./docs/azure-automation-user.md)
- [Google Cloud Platform](./docs/gcp-automation-user.md)

#### Docker automation user

We also have the `automation` user on the Docker swarm host machine. The
credentials of this user are used to connect and apply changes to the docker
services configuration.

```
docker_ssh_user = "automation"
docker_ssh_host = "example.com"
docker_ssh_port = 22
```
