# HDS
Acronym: Home Docker Services (Hades for readability) 

A docker-compose environment which is used in my home for hosting services

# Before starting:
# First make sure Docker is properly installed and configured

## Install docker

Install the `docker.io` package.
```bash
sudo apt install docker.io
```

Start the Docker service and enable it at boot.
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

Add the current user to the docker group
```bash
sudo usermod -a -G docker $USER
```
The effects are only visible after the user logs out and back in again.


## Install docker-compose

Download the `docker-compose` service
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/[VERSION]/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

Apply the correct permissions for `docker-compose`.
```bash
sudo chmod +x /usr/local/bin/docker-compose
```

Verify `docker-compose` version.
```bash
docker-compose --version
```

# After installing Docker:

## Free up the :53 UDP and TCP port

The DNS server which is used to resolve the custom domain names within your home network, needs to use the :53 UDP and TCP port. This port is in most cases already in use by the OS, but can be disabled by following these steps. This is just an internal DNS-resolver and can safeley be disabled.

Use your favorite editor (in my case Nano) and open the file:
```bash
sudo nano /etc/systemd/resolved.conf
```

Once you have opened this file, go ahead and uncomment `DNSStubListener` and change its value to `no`, so you end up with this line:
```
DNSStubListener=no
```

After changing this line, save and exit out of the editor, and restart the `systemd` service:
```bash
sudo systemctl restart systemd-resolved
```