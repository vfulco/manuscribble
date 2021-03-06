# Install Docker https://docs.docker.com/engine/installation/linux/ubuntulinux/
## Add docker GPG key
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
## Add docker APT Repository
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main\n"> /etc/apt/sources.list.d/docker.list
apt-get update
## purge the old repo if it exists
apt-get purge lxc-docker
## verify that APT is pulling from the right repo
apt-cache policy docker-engine
## install the main docker package
apt-get install docker engine
service docker start


# Add vagrant user to docker
#   https://docs.oracle.com/cd/E52668_01/E54669/html/section_rdz_hmw_2q.html
groupadd docker
service docker restart
usermod -a -G docker vagrant
