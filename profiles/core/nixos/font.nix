{ pkgs, ... }:
{
  fonts = {
    fonts = with pkgs; [ powerline-fonts dejavu_fonts ];
    fontconfig.defaultFonts = {
      monospace = [ "DejaVu Sans Mono for Powerline" ];
      sansSerif = [ "DejaVu Sans" ];
    };
  };
}
