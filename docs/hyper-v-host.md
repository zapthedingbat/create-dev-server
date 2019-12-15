# Hyper-V host

- [Download](https://www.centos.org/download/) the latest CentOS iso image.
- Create a new Hyper-V virtual machine and boot to the CentOS iso you just
  downloaded.
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

## Network

Connect the VM to an External virtual switch. Find the IP address of the machine

```
ip a
```

You can use this IP address to connect to the VM from the host machine (or other
machines on your local newtwork).

### Firewall & port forwarding

Ensure ports 80 and 443 are forwarded to new server's external IP address so it
can serve traffic to the public internet. You might also want ot open up other
ports like 22 for SSH access from the internet.

## SSH access

- On a the host machine, create a keypair for the `automation` user and copy it
  to the server. Record the private key securly, so it can be used in future by
  a CI server to access the server remotely.

  ```
  ssh-keygen -q -t RSA -N '' -f ~/.ssh/id_rsa_automation
  ssh-copy-id -i ~/.ssh/id_rsa_automation automation@<your VM server ip>
  ```

- Connect to the server as the `automation` user using SSH.
  ```
  ssh automation@<your VM server ip>
  ```
- Update the sshd configuration to only allow ssh connections using public key
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
