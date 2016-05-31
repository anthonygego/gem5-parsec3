#!/bin/bash
HOME_FOLDER=$(pwd)

apt-get -y install make gcc g++ pkg-config gettext libx11-dev x11proto-xext-dev libgl1-mesa-dev libxt-dev libxi-dev libxmu-dev libtbb2 libtbb-dev

# Copy rcS
cp rcS /etc/init.d/rcS.gem5
chmod +x /etc/init.d/rcS.gem5

# Compile m5 tool
cd m5
make
cp m5 /sbin/m5

# Download and extract parsec
cd /root

if [ ! -f parsec-3.0-core.tar.gz ]; then
  wget http://parsec.cs.princeton.edu/download/3.0/parsec-3.0-core.tar.gz
fi

if [ ! -f parsec-3.0-input-sim.tar.gz ]; then
  wget http://parsec.cs.princeton.edu/download/3.0/parsec-3.0-input-sim.tar.gz
fi

rm -rf parsec-3.0
tar xf parsec-3.0-core.tar.gz 
tar xf parsec-3.0-input-sim.tar.gz
cd parsec-3.0

# Patch hooks ROI for m5
git apply $HOME_FOLDER/gem5-parsec3.patch

# Build
source env.sh
parsecmgmt -a uninstall -p all -c gcc-hooks
parsecmgmt -a build -p all -c gcc-hooks

# Remove tar files
cd /root
rm parsec-3.0-core.tar.gz 
rm parsec-3.0-input-sim.tar.gz

echo "OK, when you're ready, swap /etc/init.d/rcS and /etc/init.d/rcS.gem5"
