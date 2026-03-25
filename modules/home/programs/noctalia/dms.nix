{
  pkgs,
  inputs,
  unstable,
  ...
}:
{
  programs.dank-material-shell = {
    enable = false;
    quickshell.package = inputs.quickshell.packages."${pkgs.stdenv.hostPlatform.system}".default;
    dgop.package = unstable.dgop;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    # enableSystemMonitoring = true;
    # enableSystemMonitoring = true;
    # enableVPN = true;
    # enableDynamicTheming = false;
    # enableAudioWavelength = true;
    # enableCalendarEvents = true;
    # enableClipboardPaste = true;
  };
}
