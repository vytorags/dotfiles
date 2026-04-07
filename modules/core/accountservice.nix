{
  services.accounts-daemon.enable = true;
  system.activationScripts.script.text = ''
    cp /home/vitor/.face /var/lib/AccountsService/icons/orion
  '';
}
