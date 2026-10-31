_:

{
  flake.modules.homeManager.desktop =
    {
      pkgs,
      lib,
      ...
    }:
    let
      tmuxCmd =
        if pkgs.stdenv.isDarwin then
          "/bin/bash -l -c '${pkgs.tmux}/bin/tmux new-session -A -s main'"
        else
          "${pkgs.tmux}/bin/tmux new-session -A -s main";
    in
    {
      home.packages =
        with pkgs;
        lib.optionals (!pkgs.stdenv.isDarwin) [
          ghostty
          kitty
        ];

      xdg.configFile."ghostty/config".text = ''
        command = ${tmuxCmd}
        theme = Catppuccin Macchiato
        background-opacity=1.0
        window-theme=dark
        font-thicken = true
        ${lib.optionalString pkgs.stdenv.isDarwin "font-size = 16"}
        macos-titlebar-style = native
        keybind = cmd+grave_accent=toggle_quick_terminal
      '';

      # Upstream unit uses Type=notify-reload; ghostty sometimes sends READY=1
      # before installing its SIGUSR2 handler, so systemd refuses startup.
      xdg.configFile."systemd/user/app-com.mitchellh.ghostty.service.d/override.conf" =
        lib.mkIf (!pkgs.stdenv.isDarwin)
          {
            text = ''
              [Service]
              Type=dbus
            '';
          };
    };
}
