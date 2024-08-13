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
