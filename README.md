# Server Configuration

Development server configuration

This repository is a reference for setting up a basic development server running
Docker swarm on CentOS

## Host

The host machine will run the docker engine in swarm mode

### Setup Steps

- [Download](https://www.centos.org/download/) and install CentOS
  - Select minimal software installation options. Don't install UI features.
  - Set a strong root password and record it securly.
  - Restart after installation.  
    `# shutdown now`
- Login as root and create an `automation` user in the group `wheel`. Set a
  secure password for the automation user and record it securly.

  ```
  adduser automation
  passwd automation
  usermod -aG wheel automation
  ```

### SSH access

- On a client machine create a keypair for the automation user and copy it to
  the server. Record the private key securly, so it can be used in future by a
  CI server to access the server remotely.

  ```
  ssh-keygen -q -t RSA -N '' -f ~/.ssh/id_rsa_automation
  ssh-copy-id -i ~/.ssh/id_rsa_automation automation@${server_hostname}
  ```

- Connect to the server as the `automation` user using SSH.
  ```
  ssh automation@<Your server hostname/IP address>
  ```
- Update the sshd coniguration to only allow ssh connections using public key
  authentication.  
  Run `sudo vi /etc/ssh/sshd_config` and update the following values.

  ```
  PermitRootLogin no
  ```

  ```
  PubkeyAuthentication yes
  ```

  ```
  PasswordAuthentication no
  ```

  ```
  ChallengeResponseAuthentication no
  ```

- Reload ssh server configuration

  ```
  sudo systemctl reload sshd
  ```

### Docker swarm

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

YOu might want to setup up a wildcard DNS record on a public domain or sub
domain that you own pointing to the public IP address of your server. e.g
`*.example.com` or `*.myserver.example.com`.

#### Firewalls / port forwarding

Ensure ports 80 and 443 are forwarded to new server's external IP address so it
can serve traffic to the public internet. You might also want ot open up other
ports like 22 for SSH access from the internet.
