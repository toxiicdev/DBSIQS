IP=$1 # 1st parameter, ip fail over
ROUTE=$2 # 2th paramter, route gateway (generally the dedicated server ending with .254 or .1)
echo -e "auto lo\niface lo inet loopback\n\nauto eth0\niface eth0 inet static\n\taddress $IP\n\tnetmask 255.255.255.0\n\tbroadcast $IP\n\tpost-up route add $ROUTE dev eth0\n\tpost-up route add default gw $ROUTE\n\tpre-down route del $ROUTE dev eth0\n\tpre-down route del default gw $ROUTE" > /etc/network/interfaces
ifup eth0
service networking restart
apt-get update -y && apt-get install openssh-server -y
sed -i 's/without-password/yes/g' /etc/ssh/sshd_config
service openssh-server -y
service networking restart
echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf
