_:

{
  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        rusty-path-of-building
      ];

      programs.mangohud = {
        enable = true;
        settings = {
          legacy_layout = 0;
          background_alpha = 0.6;
          round_corners = 0;
          background_color = "000000";
          font_size = 24;
          text_color = "FFFFFF";
          position = "top-left";
          gpu_list = 0;
          table_columns = 3;
          gpu_text = "GPU";
          gpu_stats = true;
          gpu_load_change = true;
          gpu_load_value = "50,90";
          gpu_load_color = "FFFFFF,FFAA7F,CC0000";
          vram = true;
          vram_color = "AD64C1";
          gpu_temp = true;
          gpu_power = true;
          gpu_color = "2E9762";
          cpu_text = "CPU";
          cpu_stats = true;
          cpu_load_change = true;
          cpu_load_value = "50,90";
          cpu_load_color = "FFFFFF,FFAA7F,CC0000";
          cpu_mhz = true;
          cpu_temp = true;
          cpu_power = true;
          cpu_color = "2E97CB";
          ram = true;
          ram_color = "C26693";
          fps = true;
          frame_timing = true;
          frametime_color = "00FF00";
          engine_version = true;
          engine_color = "EB5B5B";
          fps_limit_method = "late";
          toggle_fps_limit = "Shift_L+F1";
          fps_limit = 0;
          hdr = true;
          gamemode = true;
          vsync = 4;
          fps_color_change = true;
          fps_color = "B22222,FDFD09,39F900";
          fps_value = "30,60";
          output_folder = "/home/wake/";
          log_duration = 30;
          log_interval = 100;
          toggle_logging = "Shift_L+F2";
        };
      };
    };
}
