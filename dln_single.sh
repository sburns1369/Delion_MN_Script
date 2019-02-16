NODESL=One
NODESN=1
WALLET=Dq92A8mAmqG5tjVKe7ADVD3ApSjbqGYxLD
BLUE='\033[0;96m'
GREEN='\033[0;92m'
RED='\033[0;91m'
YELLOW='\033[0;93m'
CLEAR='\033[0m'
if [[ $(lsb_release -d) != *16.04* ]]; then
"echo -e ${RED}"The operating system is not Ubuntu 16.04. You must be running on ubuntu 16.04."${CLEAR}"
exit 1
fi
echo
echo
echo -e ${GREEN}"Are you sure you want to continue installation of ${NODESL} DeLion Masternode(s)?"
echo -e "type y/n followed by [ENTER]:"${CLEAR}
read AGREE
if [[ $AGREE =~ "y" ]] ; then
echo
echo
echo
echo
echo -e ${BLUE}"May this script will store a small amount data in /usr/local/nullentrydev/ ?"${CLEAR}
echo -e ${BLUE}"This information is for version updates and later implimentation"${CLEAR}
echo -e ${BLUE}"Zero Confidental information or Wallet keys will be stored in it"${CLEAR}
echo -e ${YELLOW}"Press y to agree followed by [ENTER], or just [ENTER] to disagree"${CLEAR}
read NULLREC
echo
echo
echo
echo
echo
echo -e ${RED}"Your Masternode Private Key is needed,"${CLEAR}
echo -e ${GREEN}" -which can be generated from the local wallet"${CLEAR}
echo
echo -e ${YELLOW}"You can edit the config later if you don't have this"${CLEAR}
echo -e ${YELLOW}"Masternode may fail to start with invalid key"${CLEAR}
echo
echo -e ${YELLOW}"Right Click to paste in some SSH Clients"${CLEAR}
echo
echo -e ${GREEN}"Please Enter Your First Masternode Private Key:"${CLEAR}
read privkey
echo
cho
echo "Creating ${NODESN} DeLion system users with no-login access:"
sudo adduser --system --home /home/delion delion
cd ~
if [[ $NULLREC = "y" ]] ; then
if [ ! -d /usr/local/nullentrydev/ ]; then
echo -e ${YELLOW}"Making /usr/local/nullentrydev"${CLEAR}
sudo mkdir /usr/local/nullentrydev
else
echo -e ${YELLOW}"Found /usr/local/nullentrydev"${CLEAR}
fi
if [ ! -f /usr/local/nullentrydev/dln.log ]; then
echo -e ${YELLOW}"Making /usr/local/nullentrydev/dln.log"${CLEAR}
sudo touch /usr/local/nullentrydev/dln.log
else
echo -e ${YELLOW}"Found /usr/local/nullentrydev/dln.log"${CLEAR}
fi
if [ ! -f /usr/local/nullentrydev/mnodes.log ]; then
echo -e ${YELLOW}"Making /usr/local/nullentrydev/mnodes.log"${CLEAR}
sudo touch /usr/local/nullentrydev/mnodes.log
else
echo -e ${YELLOW}"Found /usr/local/nullentrydev/mnodes.log"${CLEAR}
fi
fi
echo -e ${RED}"Updating Apps"${CLEAR}
sudo apt-get -y update
sudo apt-get -y upgrade
if grep -Fxq "dependenciesInstalled: true" /usr/local/nullentrydev/mnodes.log
then
echo
echo -e ${RED}"Skipping... Dependencies & Software Libraries - Previously installed"${CLEAR}
echo
else
echo ${RED}"Installing Dependencies & Software Libraries"${CLEAR}
sudo apt-get -y install software-properties-common
sudo apt-get -y install build-essential
sudo apt-get -y install libtool autotools-dev autoconf automake
sudo apt-get -y install libssl-dev
sudo apt-get -y install libevent-dev
sudo apt-get -y install libboost-all-dev
sudo apt-get -y install pkg-config
echo -e ${RED}"Press ENTER when prompted"${CLEAR}
sudo add-apt-repository -yu ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get -y install libdb4.8-dev
sudo apt-get -y install libdb4.8++-dev
echo -e ${YELLOW} "Here be dragons"${CLEAR}
sudo apt-get -y install libminiupnpc-dev libzmq3-dev libevent-pthreads-2.0-5
sudo apt-get -y install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev
sudo apt-get -y install libqrencode-dev bsdmainutils unzip
if [[ $NULLREC = "y" ]] ; then
echo "dependenciesInstalled: true" >> /usr/local/nullentrydev/mnodes.log
fi
fi
cd /var
sudo touch swap.img
sudo chmod 600 swap.img
sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=4096
sudo mkswap /var/swap.img
sudo swapon /var/swap.img
cd ~
if [ ! -d /root/dln ]; then
sudo mkdir /root/dln
fi
cd /root/dln
echo "Downloading latest DeLion binaries"
wget https://github.com/delioncoin/delioncore/releases/download/v1.0/Linux.zip
unzip Linux.zip
sleep 3
sudo mv /root/dln/deliond /root/dln/delion-cli /usr/local/bin
sudo chmod 755 -R /usr/local/bin/delion*
rm -rf /root/dln
echo -e "${GREEN}Configuring First DeLion Node${CLEAR}"
sudo mkdir /home/delion/.delion
sudo touch /home/delion/.delion/delion.conf
echo "rpcuser=user"`shuf -i 100000-9999999 -n 1` >> /home/delion/.delion/delion.conf
echo "rpcpassword=pass"`shuf -i 100000-9999999 -n 1` >> /home/delion/.delion/delion.conf
echo "rpcallowip=127.0.0.1" >> /home/delion/.delion/delion.conf
echo "server=1" >> /home/delion/.delion/delion.conf
echo "daemon=1" >> /home/delion/.delion/delion.conf
echo "maxconnections=250" >> /home/delion/.delion/delion.conf
echo "masternode=1" >> /home/delion/.delion/delion.conf
echo "rpcport=15959" >> /home/delion/.delion/delion.conf
echo "listen=0" >> /home/delion/.delion/delion.conf
echo "externalip=$(hostname -I | cut -f1 -d' '):15858" >> /home/delion/.delion/delion.conf
echo "masternodeprivkey=$privkey" >> /home/delion/.delion/delion.conf
if [[ $NULLREC = "y" ]] ; then
echo "masterNode1 : true" >> /usr/local/nullentrydev/dln.log
echo "walletVersion1 : 1.0" >> /usr/local/nullentrydev/dln.log
echo "scriptVersion1 : 0.8a" >> /usr/local/nullentrydev/dln.log
fi
sleep 5
echo
echo -e ${YELLOW}"Launching First DLN Node"${CLEAR}
deliond -datadir=/home/delion/.delion -daemon
echo
echo -e ${YELLOW}"Looking for a Shared Masternode Service? Check out Crypto Hash Tank" ${CLEAR}
echo -e ${YELLOW}"Support my Project, and put your spare crypto change to work for you!" ${CLEAR}
echo -e ${GREEN}"             https://www.cryptohashtank.com/TJIF "${CLEAR}
echo
sleep 60
echo
echo -e ${BOLD}"All ${NODESN} DLN Nodes Launched, please wait for it to synchronize".${CLEAR}
echo
echo -e ${YELLOW}"Your Masternodes are synchronize this will take some time."${CLEAR}
echo -e ${YELLOW}"While you wait you can configure your masternode.conf in your local wallet"${CLEAR}
echo -e ${YELLOW}"The data below needs to be in your local masternode configuration file:${CLEAR}"
echo -e ${YELLOW}" Masternode - \#1 IP: $(hostname -I | cut -f1 -d' '):15858${CLEAR}"
echo
echo -e ${BOLD} "If you become disconnected, you can check the status of sync ing with"${CLEAR}
echo -e "${YELLOW}For delion-cli -datadir=/home/delion/.delion mnsync status"${CLEAR}
echo -e "${BOLD}You can check the status of your DLN Masternode with"${CLEAR}
echo -e "${YELLOW}For delion-cli -datadir=/home/delion/.delion masternode status"${CLEAR}
echo
fi
echo -e ${BLUE}" Your patronage is apprappreciated, tipping addresses"${CLEAR}
echo -e ${BLUE}" DeLion address: ${WALLET}"${CLEAR}
echo -e ${BLUE}" LTC address: MUdDdVr4Az1dVw47uC4srJ31Ksi5SNkC7H"${CLEAR}
echo -e ${BLUE}" BTC address: 32FzghE1yUZRdDmCkj3bJ6vJyXxUVPKY93"${CLEAR}
echo
echo -e ${YELLOW}"Need help? Find Sburns1369\#1584 one Discord - https://discord.gg/YhJ8v3g"${CLEAR}
echo
echo -e ${RED}"The END."${CLEAR};
