{ ... }:

{
  # Override system steam.desktop to remove PrefersNonDefaultGPU=true, which
  # causes GLib (wofi) to set DRI_PRIME=1, sending Steam to the iGPU instead
  # of the RX 9070 XT, crashing steamwebhelper in a loop.
  xdg.desktopEntries.steam = {
    name = "Steam";
    comment = "Application for managing and playing games on Steam";
    exec = "steam %U";
    icon = "steam";
    terminal = false;
    categories = [ "Network" "FileTransfer" "Game" ];
    mimeType = [ "x-scheme-handler/steam" "x-scheme-handler/steamlink" ];
    actions = {
      "Store"       = { exec = "steam steam://store"; name = "Store"; };
      "Community"   = { exec = "steam steam://url/CommunityHome/"; name = "Community"; };
      "Library"     = { exec = "steam steam://open/games"; name = "Library"; };
      "Servers"     = { exec = "steam steam://open/servers"; name = "Servers"; };
      "Screenshots" = { exec = "steam steam://open/screenshots"; name = "Screenshots"; };
      "News"        = { exec = "steam steam://openurl/https://store.steampowered.com/news"; name = "News"; };
      "Settings"    = { exec = "steam steam://open/settings"; name = "Settings"; };
      "BigPicture"  = { exec = "steam steam://open/bigpicture"; name = "Big Picture"; };
      "Friends"     = { exec = "steam steam://open/friends"; name = "Friends"; };
    };
  };
}
