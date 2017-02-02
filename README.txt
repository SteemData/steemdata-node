apt update && apt upgrade
apt install docker.io tmux htop -y

# mount external ssd
mkfs -t ext4 /dev/sda
mkdir -p /mnt/data
mount /dev/sda /mnt/data

# add swap
fallocate -l 32G /swapfile
chmod 600 /swapfile
mkswap /swapfile 
swapon /swapfile


vim /etc/fstab

/swapfile none swap defaults 0 0
/dev/sda /mnt/data auto defaults,nobootwait,errors=remount-ro 0 2

