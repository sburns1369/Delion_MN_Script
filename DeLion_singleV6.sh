#!/bin/bash
#0.9d-- NullEntryDev Script
NODESL=One
NODESN=1
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
echo -e ${GREEN}"Are you sure you want to continue the installation of a DeLion Masternode?"
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
echo -e ${YELLOW}"And the script installation will hang and fail"${CLEAR}
echo
echo -e ${YELLOW}"Right Click to paste in some SSH Clients"${CLEAR}
echo
echo -e ${GREEN}"Please Enter Your Masternode Private Key:"${CLEAR}
read privkey
echo
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
echo -e ${RED}"Upgrading Apps"${CLEAR}
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
echo -e ${RED}"Press [ENTER] if prompted"${CLEAR}
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
echo -e ${YELLOW} "Building IP Tables"${CLEAR}
sudo touch ip.tmp
IP=$(hostname -I | cut -f2 -d' '| cut -f1-7 -d:)
for i in {15361..15375}; do printf "${IP}:%.4x\n" $i >> ip.tmp; done
MNIP1=$(sed -n '1p' < ip.tmp)
if [[ $NULLREC = "y" ]] ; then
sudo touch /usr/local/nullentrydev/iptable.log
sudo cp ip.tmp >> /usr/local/nullentrydev/iptable.log
fi
rm -rf ip.tmp
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
echo -e "${GREEN}Configuring DeLion Node${CLEAR}"
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
echo "externalip=[${MNIP1}]:15858" >> /home/delion/.delion/delion.conf
echo "masternodeprivkey=$privkey" >> /home/delion/.delion/delion.conf
echo "addnode=66.42.113.222:15858" >> /home/delion/delion.conf
if [[ $NULLREC = "y" ]] ; then
echo "masterNode1 : true" >> /usr/local/nullentrydev/dln.log
echo "walletVersion1 : 1.0.0" >> /usr/local/nullentrydev/dln.log
echo "scriptVersion1 : 0.9d" >> /usr/local/nullentrydev/dln.log
fi
sleep 5
echo
echo -e ${YELLOW}"Launching DLN Node"${CLEAR}
deliond -datadir=/home/delion/.delion -daemon
echo
echo -e ${YELLOW}"Looking for a Shared Masternode Service? Check out Crypto Hash Tank" ${CLEAR}
echo -e ${YELLOW}"Support my Project, and put your loose change to work for you!" ${CLEAR}
echo -e ${YELLOW}" https://www.cryptohashtank.com/TJIF "${CLEAR}
echo
echo -e ${YELLOW}"Special Thanks to the BitcoinGenX (BGX) Community" ${CLEAR}
sleep 20
echo -e "${RED}This process can take a while!${CLEAR}"
echo -e "${YELLOW}Waiting on Masternode Block Chain to Synchronize${CLEAR}"
until delion-cli -datadir=/home/delion/.delion mnsync status | grep -m 1 'IsBlockchainSynced" : true'; do
delion-cli -datadir=/home/delion/.delion getblockcount
sleep 60
done

echo
echo -e ${BOLD}"Your DLN Node has Launched."${CLEAR}
echo

echo -e "${GREEN}You can check the status of your DLN Masternode with"${CLEAR}
echo -e "${YELLOW} delion-cli -datadir=/home/delion/.delion masternode status"${CLEAR}
echo
echo -e "${RED}Status 29 may take a few minutes to clear while the daemon processes the chainstate"${CLEAR}
echo -e "${GREEN}The data below needs to be in your local masternode configuration file:${CLEAR}"
echo -e "${BOLD} Masternode - IP: [${MNIP1}]:15858${CLEAR}"
fi
echo -e ${BLUE}" Your patronage is appreciated, tipping addresses"${CLEAR}
echo -e ${BLUE}" DeLion address: Dq92A8mAmqG5tjVKe7ADVD3ApSjbqGYxLD"${CLEAR}
echo -e ${BLUE}" XGS address: BayScFpFgPBiDU1XxdvozJYVzM2BQvNFgM"${CLEAR}
echo -e ${BLUE}" LTC address: MUdDdVr4Az1dVw47uC4srJ31Ksi5SNkC7H"${CLEAR}
echo
echo -e ${YELLOW}"Need help? Find Sburns1369\#1584 on Discord - https://discord.gg/YhJ8v3g"${CLEAR}
echo -e ${YELLOW}"If Direct Messaged please verify by clicking on the profile!"${CLEAR}
echo -e ${YELLOW}"it says Sburns1369 in bigger letters followed by a little #1584" ${CLEAR}
echo -e ${YELLOW}"Anyone can clone my name, but not the #1384".${CLEAR}
echo
echo -e ${RED}"The END."${CLEAR};
