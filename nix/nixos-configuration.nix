{
  config,
  lib,
  pkgs,
  system,
  hostName,
  user,
  ...
}:
{
  environment.systemPackages =
    import ./common-packages.nix { inherit pkgs; }
    ++ import ./nixos-packages.nix { inherit pkgs; };
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      kernelModules = [ "dm-snapshot" ];
    };
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
    extraModulePackages = [ config.boot.kernelPackages.tp_smapi ];
    kernel.sysctl = {
      "vm.laptop_mode" = 5;
      "kernel.nmi_watchdog" = 60;
    };
    extraModprobeConfig = ''
      options snd_hda_intel index=1,0 power_save=1
      options iwlwifi power_save=1 d0i3_disable=0 uapsd_disable=0
    '';
    initrd.luks.devices = {
      "root" = {
        device = "/dev/vg/root";
        preLVM = false;
      };
    };
    tmp.cleanOnBoot = true;
  };
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/D5FE-BECB";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/mapper/root";
      fsType = "ext4";
    };
  };
  swapDevices = [ { device = "/dev/vg/swap"; } ];
  networking = {
    hostName = "${hostName}";
    hostId = "6B1548AD";
    enableIPv6 = true;
    networkmanager = {
      enable = true;
      insertNameservers = [
        "1.1.1.1"
        "1.0.0.1"
      ];
    };
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
      ];
      allowedUDPPorts = [
      ];
    };
  };
  console = {
    keyMap = "us";
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };
  fonts = {
    fontconfig.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      corefonts
      dejavu_fonts
    ];
  };
  time.timeZone = "Asia/Manila";
  security.sudo = {
    enable = true;
    configFile = ''
      Defaults env_reset
    '';
    wheelNeedsPassword = false;
  };
  nixpkgs = {
    hostPlatform = "${system}";
    config = {
      allowUnfree = true;
      pulseaudio = true;
      permittedInsecurePackages = [
      ];
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
        ];
    };
  };
  nix = {
    gc.automatic = false;
    gc.options = "--delete-older-than 30d";
    settings = {
      max-jobs = lib.mkDefault 4;
      trusted-substituters = [
        "http://cache.nixos.org"
        "https://devenv.cachix.org"
      ];
      trusted-users = [
        "root"
        "${user}"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
  programs = {
    ssh.startAgent = true;
    command-not-found.enable = true;
    adb.enable = false;
    gnupg.agent.enable = true;
  };
  documentation = {
    man.enable = true;
  };
  hardware = {
    cpu.intel.updateMicrocode = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        libvdpau-va-gl
        intel-media-driver
      ];
    };
    trackpoint = {
      enable = true;
      emulateWheel = false;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    sane = {
      enable = false;
      extraBackends = with pkgs; [ hplipWithPlugin ];
    };
  };
  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";
    extraUsers.${user} = {
      uid = 1000;
      name = "${user}";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "docker"
        "scanner"
        "lp"
        "kvm"
        "vboxusers"
        "audio"
      ];
    };
  };
  services = {
    acpid.enable = true;
    logind.extraConfig = ''
      HandleLidSwitch=suspend
      HandleSuspendKey=suspend
      HandleHibernateKey=hibernate
      HandlePowerKey=suspend
    '';
    xserver = {
      enable = true;
      autorun = true;
      defaultDepth = 24;
      xkb = {
        layout = "us";
      };
      displayManager = {
        startx.enable = true;
      };
      desktopManager.xfce = {
        enable = true;
        enableXfwm = true;
      };
      wacom.enable = true;
    };
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    ntp = {
      enable = true;
      servers = [
        "asia.pool.ntp.org"
        "0.pool.ntp.org"
        "1.pool.ntp.org"
        "2.pool.ntp.org"
      ];
    };
    udev.extraRules = ''
      SUBSYSTEM=="net", KERNEL=="eth*", RUN+="${pkgs.ethtool}/bin/ethtool -s %k wol d"
      SUBSYSTEM=="net", KERNEL=="enp*", RUN+="${pkgs.ethtool}/bin/ethtool -s %k wol d"
      ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*", RUN+="${pkgs.iw}/bin/iw dev %k set power_save on"
      ACTION=="add", SUBSYSTEM=="pci", ATTR{power/control}="auto"
      SUBSYSTEM=="video4linux", KERNEL=="video[0-9]*", ATTRS{product}=="Logitech Webcam C930e", ATTRS{serial}=="DD8C417E", ATTR{index}=="0", RUN+="${pkgs.v4l-utils}/bin/v4l2-ctl -d $devnode --set-ctrl=zoom_absolute=140"
    '';
    printing = {
      enable = false;
      drivers = with pkgs; [
        gutenprint
        hplipWithPlugin
      ];
      browsing = true;
      defaultShared = true;
    };
    avahi = {
      enable = true;
      hostName = config.networking.hostName;
      ipv4 = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
    flatpak.enable = true;
    tomcat = {
      enable = false;
      webapps = [ ./dat/tomcat/rr.war ];
    };
    fail2ban.enable = true;
    tlp.enable = true;
    saned.enable = false;
    upower.enable = true;
  };
  virtualisation = {
    virtualbox = {
      host = {
        enable = false;
        enableExtensionPack = true;
      };
    };
    docker = {
      enable = true;
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
      serviceConfig = {
        Type = "oneshot";
      };
      unitConfig.RequiresMountsFor = "/sys";
      script = ''
        echo -1 > /sys/module/usbcore/parameters/autosuspend
      '';
    };
    screenlock = {
      description = "Lock screen when system sleeps or hibernates";
      before = [
        "sleep.target"
        "hibernate.target"
      ];
      wantedBy = [
        "sleep.target"
        "hibernate.target"
      ];
      environment = {
        DISPLAY = ":0";
      };
      serviceConfig = {
        SyslogIdentifier = "screenlock";
        ExecStart = "${pkgs.xscreensaver}/bin/xscreensaver-command -l";
        Type = "forking";
        User = "${user}";
      };
    };
  };
  system.stateVersion = "25.11";
  xdg.portal = {
    config.common.default = "*";
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
