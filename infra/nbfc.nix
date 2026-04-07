{
  pkgs,
  lib,
  role ? "desktop",
  ...
}:
{
  environment.etc."nbfc/nbfc.json".text = ''
    {
      "SelectedConfigId": "HP EliteBook 8470p"
    }
  '';

  systemd.services.nbfc-linux = {
    description = "NoteBook FanControl service";
    path = [ pkgs.nbfc-linux ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.nbfc-linux}/bin/nbfc_service --config /etc/nbfc/nbfc.json";
      Restart = "always";
      RestartSec = 5;
    };
    wantedBy = [ "multi-user.target" ];
  };
}
