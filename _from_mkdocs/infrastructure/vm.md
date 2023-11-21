#  VM

[Virtualization](wiki:Virtualisation)

## VirtualBox

[VirtualBox](https://www.virtualbox.org/wiki/VirtualBox) is a general-purpose
full virtualizer for x86 hardware, targeted at server, desktop and embedded
use.

### Installation

Binaries, extension and source code can be installed from the
[wiki](https://www.virtualbox.org/wiki/Downloads).


A handy feature is the ability to run common commands for managing VM from the
cli after installing the [extension
pack](https://www.virtualbox.org/wiki/Downloads)

### Basic command for running VM

The extension pack cli entry point `VBoxManage` can be aliased as:
```bash
alias vbm=VBoxManage
```

List VM's:
```bash
vbm list vms
# List running vms
vbm list runningvms
```

Change the name of a VM:
```bash
vbm modifyvm "VirtualMachine provided for test purpose" --name "MyVM"
```

Start a VM in headless mode:
```bash
vbm startvm "MyVM" --type headless
```

Once started, a VM in headless mode can be controlled (pause/resume/poweroff):
```bash
vbm controlvm "MyVM" pause --type headless
vbm controlvm "MyVM" resume --type headless
vbm controlvm "MyVM" poweroff --type headless
```

View VM properties with `vboxmanage guestproperty` <badge-doc
href='https://docs.oracle.com/en/virtualization/virtualbox/6.1/user/vboxmanage.html#vboxmanage-guestproperty'
logo='VirtualBox'></badge-doc> ```bash
# Enumerate all properties of the VM named MyVM
vbm guestproperty enumerate MyVM

# Get the IP address of the VM named Cloudera
vbm guestproperty get Cloudera /VirtualBox/GuestInfo/Net/0/V4/IP
# or
vbm guestproperty enumerate Cloudera | grep IP | awk '{print $4}' | sed -e 's/,//'
```

??? info "Install an OS"

    **Virtual box creation**

    ```shell
    vbm createvm --name <VM> --ostype <OSTYPE> --basefolder <BASEFOLDER> --register
    # OSTYPE can be set from a list, e.g. RedHat_64
    vbm list ostypes
    ```

    **System settings**

    ```console
    # RAM and video memory
    vbm modifyvm <VM> --memory 2048 --vram 128

    # Disable audio
    vbm modifyvm <VM> --audio none

    # Set network
    vbm modifyvm <VM> --nic1 nat

    # Create a disk with size 100G, default format vdi
    vbm createhd --filename <DISK_NAME>.vdi --size 100000

    vbm storagectl <VM> --name "SATA Controller" --add sata --controller IntelAhci
    vbm storageattach <VM> --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium <DISK_NAME>.vdi
    # None: to remove a storage, set the medium to none, e.g.
    vbm storageattach <VM> --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium none


    vbm storagectl <VM> --name "IDE Controller" --add ide --controller PIIX4
    vbm storageattach <VM> --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium <ISO>

    # Set boot order
    vbm modifyvm <VM> --boot1 dvd --boot2 disk --boot3 none --boot4 none

    # [Enabling the I/O APIC is required](http://www.virtualbox.org/manual/ch03.html#settings-motherboard), especially for 64-bit Windows guest OSes. It is also required if you want to use more than one virtual CPU in a virtual machine.

    vbm modifyvm <VM> --ioapic on
    ```

## Vagrant

### Installation on Debian based systems

deb package can be found at [download](https://www.vagrantup.com/downloads.html)

```
curl -LO https://releases.hashicorp.com/vagrant/2.2.17/vagrant_2.2.17_x86_64.deb
sudo apt install ./vagrant_2.2.17_x86_64.deb
# or dpkg -i
```

### `vagranfile`

Vagrant climbs up the directory tree looking for the first
[Vagrantfile](https://www.vagrantup.com/docs/vagrantfile) it can
find, starting first in the current directory (or using `$VAGRANT_CWD` value).
See [load oder and
merging](https://www.vagrantup.com/docs/vagrantfile#load-order).

[Customizing Vagrant VMware Fusion Virtual Machines with VMX Parameters](https://thornelabs.net/posts/customizing-vagrant-vmware-fusion-virtual-machines-with-vmx-parameters.html)

[How to create a Vagrant Box running Red Hat Enterprise Linux](https://medium.com/@severi/how-to-create-a-vagrant-box-running-red-hat-enterprise-linux-55410f8cfa7d)

### Troubleshooting on hosts with secure mode enabled

UEFI[^1] Secure Boot[^2] (SB) is a verification mechanism for ensuring that
code launched by a computer's UEFI firmware is trusted. Unsigned drivers are
therefor not allowed to load.

2 kernels modules are compiled at installation time and must be loaded. If the
host provides the proper kernel headers and gcc, these two modules will be
built silently. The progress is logged into /tmp/vmware-root/vmware-PID.log[^3].

On error type like:

> Cannot open `/dev/vmmon`: No such file or directory. Please make sure that the kernel module `vmmon` is loaded

The modules must be signed and the keys added to a database recognised by the first stage of the bootloader, the **Machine Owner Key**


```console
# Modules must be signed by a CA (Certificate Authority), here self-signed
openssl req -new -x509 -newkey rsa:2048 -keyout <MOK.priv> -outform DER -out <MOK.der> -nodes -days 36500 -subj "/CN=VMware/"
sudo /usr/src/linux-headers-``uname -r``/scripts/sign-file sha256 <MOK.priv> <MOK.der> $(modinfo -n vmmon)
sudo /usr/src/linux-headers-``uname -r``/scripts/sign-file sha256 <MOK.priv> <MOK.der> $(modinfo -n vmnet)

sudo mokutil --test-key <MOK.der>
# cert should not be currently enrolled

sudo mokutil --import <MOK.der>
# mokutil should request pwd

sudo mokutil --test-key <MOK.der>
# cert should be enrolled now

sudo mokutil --list-new
# your cert should be displayed

reboot
```

## Links

[Controlling VirtualBox from the Command Line](https://www.oracle.com/technical-resources/articles/it-infrastructure/admin-manage-vbox-cli.html)

## Footnotes

[^1]: Unified Extensible Firmware Interface - https://wiki.debian.org/UEFI
[^2]: [Debian secure boot documentation page](https://wiki.debian.org/SecureBoot)
[^3]: [VMware knowledge base](https://kb.vmware.com/s/article/2146460)
