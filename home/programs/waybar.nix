{ config, pkgs, lib, ... }:

{
  xdg.configFile."waybar/config.jsonc" = lib.mkIf pkgs.stdenv.isLinux {
    text = ''
      {
          "layer": "top",
          "position": "top",
          "height": 30,
          "spacing": 0,

          "modules-left": [],
          "modules-center": ["clock"],
          "modules-right": ["pulseaudio", "memory", "battery", "temperature", "cpu"],

          "niri/workspaces": {
              "format": "{index}"
          },

          "clock": {
              "format": "{:%a %b %d %I:%M:%S %p}",
              "interval": 1,
              "tooltip-format": "<tt>{calendar}</tt>"
          },

          "cpu": {
              "format": " {usage}%",
              "interval": 2
          },

          "memory": {
              "format": " {used:0.1f}G",
              "tooltip-format": "{used:0.1f}G / {total:0.1f}G"
          },

          "temperature": {
              "format": " {temperatureC}°C",
              "critical-threshold": 80
          },

          "battery": {
              "states": {
                  "warning": 30,
                  "critical": 15
              },
              "format": "{icon} {capacity}%",
              "format-charging": "{icon} {capacity}%",
              "format-icons": ["", "", "", "", ""]
          },

          "pulseaudio": {
              "format": "{icon} {volume}%",
              "format-muted": " muted",
              "format-icons": {
                  "default": ["", "", ""]
              },
              "on-click": "pavucontrol",
              "on-scroll-up": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+",
              "on-scroll-down": "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          }
      }
    '';
  };

  xdg.configFile."waybar/style.css" = lib.mkIf pkgs.stdenv.isLinux {
    text = ''
      * {
          font-family: monospace;
          font-size: 13px;
          min-height: 0;
      }

      window#waybar {
          background-color: rgba(0, 0, 0, 0.5);
          color: #ffffff;
      }

      #clock,
      #cpu,
      #memory,
      #temperature,
      #battery,
      #pulseaudio {
          padding: 0 10px;
          color: #ffffff;
      }

      #clock {
          background-color: transparent;
      }

      #battery.charging {
          color: #26a65b;
      }

      #battery.warning:not(.charging) {
          color: #f0ad4e;
      }

      #battery.critical:not(.charging) {
          color: #e74c3c;
      }

      #temperature.critical {
          color: #e74c3c;
      }
    '';
  };
}
