# Setting Up a NixOS Environment for Workshops

To fully participate in the workshops, a NixOS environment is required. Some exercises may be completed using Nix on a non-NixOS system, but full participation typically necessitates NixOS, installed either natively or within a virtual machine. Here are your options:

## **1. Install NixOS on Your Laptop**

- For detailed instructions, refer to the [NixOS Installation Guide](https://nixos.wiki/wiki/NixOS_Installation_Guide).

## **2. Install NixOS in a Virtual Machine with VirtualBox**

- You can find instructions for this setup at the [NixOS download page](https://nixos.org/download/#nixos-virtualbox).
- Test that the vm is connected to the internet for example by running `ping 8.8.8.8` in the terminal.
- Test that you are able to rebuild the system by running `sudo nixos-rebuild switch` in the terminal.

## **3. Setting Up NixOS on UTM for Mac M* Users**

If you're using a Mac with an M* chip and cannot use VirtualBox, you can set up NixOS using UTM by following these steps:

1. [Install UTM](https://mac.getutm.app/)

2. [Download Nixos ISO](https://nixos.org/download/) (in this guide used minimal 64-bit ARM iso)

3. Create new VM on UTM

    - Select Virtualize
    - Select Custom / Other
    - Browse to select path to downloaded ISO
    - Set memory & CPUs (here used 4096MB & default for cores)
    - Set disk size (here used 64GB)
    - Optional: select shared path to share between host and VM (will require some additional setup once NixOS is installed)
    - Save settings

4. Start new VM, boots to installer

    - For manual installation, follow this guide: <https://nixos.org/manual/nixos/stable/#sec-installation-manual>
    - In short, run these commands:

    ```bash
    sudo -i
    lsblk # to check name of disk, here /dev/vda
    # Partition
    parted /dev/vda -- mklabel gpt
    parted /dev/vda -- mkpart root ext4 512MB -8GB
    parted /dev/vda -- mkpart swap linux-swap -8GB 1
    parted /dev/vda -- mkpart ESP fat32 1MB 512MB
    parted /dev/vda -- set 3 esp on
    # Install
    mkfs.ext4 -L nixos /dev/vda1
    mkswap -L swap /dev/vda2
    swapon /dev/vda2
    mkfs.fat -F 32 -n boot /dev/vda3
    mount /dev/disk/by-label/nixos /mnt
    mkdir -p /mnt/boot
    mount /dev/disk/by-label/boot /mnt/boot
    nixos-generate-config --root /mnt
    nixos-install # at the end of installation provide new password for root user
    reboot
    ```

    - Reboots back to installer, now select to shut down
    - In UTM settings, go to your VM -> Edit -> Reorder drives by dragging to move VirtIO Drive as the first one
    - Start the VM -> should boot to the installed NixOS -> login as root user

5. Enable SSH & permit root login momentarily to connect to VM on command line

    - First config modification & rebuild: enable ssh and permit root user to login
        - Nano /etc/nixos/configuration.nix
        - Find the commented line `# services.openssh.enable = true`, uncomment and add below `services.openssh.permitRootLogin = "yes";`
        - Save and exit, run `nixos-rebuild switch`
        - Check your VM's IP address with `ip a`, now you can ssh to the VM from command line with `ssh root@IP` and continue to customize your setup

6. Finalize directory sharing setup

    - Add following to /etc/nixos/hardware-configuration.nix to make your previously selected shared directory to show up at `/host` on the VM:

    ```nix
    fileSystems."/host" =
    {
        device = "share";
        fsType = "9p";
        options = [ "trans=virtio" "version=9p2000.L" "rw" "_netdev" "nofail" ];
    };
    ```

    - Fixing permission issues: <https://docs.getutm.app/guest-support/linux/#fixing-permission-errors>
