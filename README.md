# gem5 PARSEC3 disk scripts
The image disk can be produced with `qemu` by following the steps behind:

1. Create a qemu disk image for the OS files and swap. A size of 10GB is sufficient:

  ```
      qemu-img create -f raw linux-x86.img 10G
  ```
  
1. Donwload the Debian Wheezy netinstall kernel and ramdisk:

  ```
    wget http://ftp.debian.org/debian/dists/wheezy/main/installer-amd64/current/images/netboot/debian-installer/amd64/linux
    wget http://ftp.debian.org/debian/dists/wheezy/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz
  ```

1. Boot the downloaded kernel (not the gem5 kernel) and ramdisk using a default PC and serial output:

  ```
    qemu-kvm -M q35 -kernel linux -initrd initrd.gz -hda disks/linux-x86.img -m 2G -nographic -append "auto=true root=/dev/sda1 console=ttyS0 hostname=debian domain= url=<URL>"
  ```
  
  where `<URL>` is the HTTP link (netinstaller only support this) to the `debian-preseed` file. HTTPS is not supported neither. Uploading the file content on Pastebin and using the raw URL is a quick workaround.

  This will create the base image automatically with `root/root` and `tux/tux` sets of user/passwords.
1. Once the installation done, reboot QEMU with the freshly built kernel in Section \ref{appendix:kernel} and no ramdisk.

  ```
    qemu-kvm -M q35 -kernel binaries/bzImage -hda disks/linux-x86.img -m 2G -nographic -append "root=/dev/sda1 console=ttyS0"
  ```

1. On the target machine as root, clone the disk image repository:

  ```
    git clone https://github.com/anthonygego/gem5-parsec3.git
  ```

1. Launch the setup script located in the \texttt{disk} folder:
  ```
    cd gem5-parsec3/disk
    ./setup.sh
  ```
  This will automatically install PARSEC dependencies, build and copy the `m5` executable in the `/sbin` folder, copy the new `init` startup file and build the whole PARSEC suite.
1. When ready to launch on gem5, switch between the startup files:

  ```
    mv /etc/init.d/rcS /etc/init.d/rcS.orig
    mv /etc/init.d/rcS.gem5 /etc/init.d/rcS
  ```
