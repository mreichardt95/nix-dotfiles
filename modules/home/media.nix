_:

{
  flake.modules.homeManager.media =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # nixpkgs vlc lacks the dav1d plugin; AV1 via avcodec stalls ("buffer deadlock prevented")
        (vlc.overrideAttrs (old: {
          buildInputs = old.buildInputs ++ [ dav1d ];
        }))
        davinci-resolve
        makemkv
      ];
    };
}
