{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.availableKernelModules = [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
      "rtsx_pci_sdmmc"
    ];

    kernelModules = [
      "kvm-intel"
      "fbcon"
      "tun"
      "virtio"
      "coretemp"
      "psmouse"
      "fuse"
      "tp_smapi"
      "hdaps"
      "bluetooth"
      "btusb"
      "uvcvideo"
    ];

    blacklistedKernelModules = [
      "pcpskr"
      "snd_pcsp"
      "xpad"
      "uhci_hcd"
      "pcmcia"
      "yenta_socket"
      "sierra_net"
      "cdc_mbim"
      "cdc_ncm"
    ];

    extraModulePackages = [
      config.boot.kernelPackages.tp_smapi
    ];

    kernel.sysctl = {
      "vm.laptop_mode" = 5;
      "kernel.nmi_watchdog" = 60;
    };

    extraModprobeConfig = ''
      options snd_hda_intel index=1,0 power_save=1
      options iwlwifi power_save=1 d0i3_disable=0 uapsd_disable=0
    '';

    initrd.luks.devices = [
      {
        device = "/dev/vg/root";
        name = "root";
        preLVM = false;
      }
    ];

    cleanTmpDir = true;
  };

  fileSystems = [
    {
      device = "/dev/disk/by-uuid/6106-6BF8";
      fsType = "vfat";
      mountPoint = "/boot";
    }

    {
      device = "/dev/mapper/root";
      fsType = "ext4";
      mountPoint = "/";
    }
  ];

  swapDevices = [
    {
      device = "/dev/vg/swap";
    }
  ];

  networking = {
    hostName = "vulpo";
    hostId = "6B1548AD";
    enableIPv6 = true;
    networkmanager = {
      enable = true;
    };

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  console = {
    consoleKeyMap = "dvorak";
  };

  i18n = {
    defaultLocale = "eo.utf8";
    supportedLocales = [
      "eo/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  environment = {
    systemPackages = with pkgs; [ zsh ];
  };

  fonts = {
    fontconfig.enable = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;

    fonts = with pkgs; [
      dejavu_fonts
      liberation_ttf
      ttf_bitstream_vera
      terminus_font
      cantarell_fonts
      noto-fonts
      dosemu_fonts
      powerline-fonts
      proggyfonts
      ucsFonts
      google-fonts
    ];
  };

  time.timeZone = "Asia/Manila";

  security.sudo = {
    enable = true;
    configFile = ''
      Defaults env_reset
      root ALL = (ALL:ALL) ALL
    '';
    wheelNeedsPassword = false;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    maxJobs = lib.mkDefault 4;
    gc.automatic = false;
    package = pkgs.nix;

    trustedBinaryCaches = [
      "http://cache.nixos.org"
    ];
  };

  programs = {
    ssh.startAgent = true;
    command-not-found.enable = true;
    adb.enable = true;
    gnupg.agent.enable = true;
  };

  documentation = {
    man.enable = true;
  };

  hardware = {
    cpu.intel.updateMicrocode = true;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiIntel
        libvdpau-va-gl
        intel-media-driver
      ];
    };

    trackpoint = {
      enable = false;
      emulateWheel = false;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
      support32Bit = true;
    };

    sane = {
      enable = true;
      extraBackends = with pkgs; [ hplipWithPlugin ];
    };
  };

  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";

    extraUsers.ebzzry = {
      uid = 1000;
      name = "ebzzry";
      description = "Rommel MARTINEZ";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "docker" "scanner" "lp" "kvm" "vboxusers" "adbusers" ];
    };
  };

  services = {
    xserver = {
      enable = true;
      autorun = true;
      defaultDepth = 24;
      layout = "dvorak";

      displayManager.lightdm = {
        enable = true;
        extraSeatDefaults = ''
        '';
      };

      wacom.enable = true;

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
    };

    ntp = {
      enable = true;
      servers = [ "asia.pool.ntp.org" "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
    };

    acpid = {
      enable = true;
      powerEventCommands = "echo 2 > /proc/acpi/ibm/beep";
      lidEventCommands = "echo 3 > /proc/acpi/ibm/beep";
      acEventCommands = "echo 4 > /proc/acpi/ibm/beep";
    };

    udev.extraRules = ''
      ## kurenton ŝparu
      SUBSYSTEM=="net", KERNEL=="eth*", RUN+="${pkgs.ethtool}/bin/ethtool -s %k wol d"
      SUBSYSTEM=="net", KERNEL=="enp*", RUN+="${pkgs.ethtool}/bin/ethtool -s %k wol d"
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*", RUN+="${pkgs.iw}/bin/iw dev %k set power_save on"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"
    '';

    printing = {
      enable = true;
      drivers = with pkgs; [ gutenprint hplipWithPlugin ];
      browsing = true;
      defaultShared = true;
    };

    avahi = {
      enable = true;
      hostName = config.networking.hostName;
      ipv4 = true;
      nssmdns = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    duplicati = {
      enable = true;
      interface = "127.0.0.1";
      port = 8200;
      user = "root";
    };

    fail2ban.enable = true;
    tlp.enable = true;
    saned.enable = true;
    keybase.enable = true;
  };

  virtualisation = {
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
    };

  docker = {
      enable = true;
      extraOptions = "-H tcp://0.0.0.0:2375 -s overlay2";
    };
  };

  systemd.services = {
    tune-power-management = {
      description = "Tune Power Management";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = false;
      };

      unitConfig.RequiresMountsFor = "/sys";
      script = ''
        echo 6000 > /proc/sys/vm/dirty_writeback_centisecs
        echo 1 > /sys/module/snd_hda_intel/parameters/power_save

        for knob in \
            /sys/bus/i2c/devices/i2c-0/device/power/control \
            /sys/bus/i2c/devices/i2c-1/device/power/control \
            /sys/bus/i2c/devices/i2c-2/device/power/control \
            /sys/bus/i2c/devices/i2c-3/device/power/control \
            /sys/bus/i2c/devices/i2c-4/device/power/control \
            /sys/bus/i2c/devices/i2c-5/device/power/control \
            /sys/bus/i2c/devices/i2c-6/device/power/control \
            /sys/bus/pci/devices/0000:00:00.0/power/control \
            /sys/bus/pci/devices/0000:00:02.0/power/control \
            /sys/bus/pci/devices/0000:00:16.0/power/control \
            /sys/bus/pci/devices/0000:00:19.0/power/control \
            /sys/bus/pci/devices/0000:00:1b.0/power/control \
            /sys/bus/pci/devices/0000:00:1c.0/power/control \
            /sys/bus/pci/devices/0000:00:1c.1/power/control \
            /sys/bus/pci/devices/0000:00:1d.0/power/control \
            /sys/bus/pci/devices/0000:00:1f.0/power/control \
            /sys/bus/pci/devices/0000:00:1f.2/power/control \
            /sys/bus/pci/devices/0000:00:1f.3/power/control \
            /sys/bus/pci/devices/0000:00:1f.6/power/control \
            /sys/bus/pci/devices/0000:03:00.0/power/control \
        ; do echo auto > $knob; done

        for knob in \
            /sys/class/scsi_host/host0/link_power_management_policy \
            /sys/class/scsi_host/host1/link_power_management_policy \
            /sys/class/scsi_host/host2/link_power_management_policy \
        ; do echo min_power > $knob; done
      '';
    };

    tune-usb-autosuspend = {
      description = "Disable USB autosuspend";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = { Type = "oneshot"; };
      unitConfig.RequiresMountsFor = "/sys";
      script = ''
        echo -1 > /sys/module/usbcore/parameters/autosuspend
      '';
    };
  };

  system = {
    autoUpgrade = {
      enable = false;
      channel = https://nixos.org/channels/nixos-20.03;
      dates = "00:00";
    };
  };
}
