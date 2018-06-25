{config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.sndiod;
  alsaCfg = config.sound;

  # We use sndio's ALSA backend, thus it is mandatory we have ALSA enabled.
  enabled = cfg.enable && alsaCfg.enable;
  sndioRuntimePath = "/var/run/sndiod";
in {
  options = {
    hardware.sndiod = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the sndio daemon.
        '';
      };
      daemon-options = mkOption {
        type = types.str;
        default = "";
        description = ''
          Arguments to pass to the sndio daemon.
        '';
      };
    };

  };

  config = mkIf enabled {
    users.extraUsers.sndiod = {
      home = sndioRuntimePath;
      isSystemUser = true;
      description = "sndio daemon";
      shell = "${pkgs.shadow}/bin/nologin";
      group = "audio";
    };

    systemd = {
      services.sndiod = {
        path = [ pkgs.sndio ];
        unitConfig = {
          Description = "sndio audio and MIDI server";
          After = [ "network.target" ];
        };
        preStart = ''
          mkdir -p --mode 755 ${sndioRuntimePath}
          chown -R sndiod:audio ${sndioRuntimePath}
        '';
        serviceConfig = {
          Type = "forking";
          Restart = "on-abort";
          ExecStart = "${pkgs.sndio}/bin/sndiod ${cfg.daemon-options}";
        };
      };
    };

    environment.systemPackages = [ pkgs.sndio ];
  };
}
