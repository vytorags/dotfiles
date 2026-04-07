{
  config,
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.system}.default
  ];
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  age.secrets."id_ed25519_github" = {
    file = ./ages/id_ed25519_github.age;
    owner = "vitor";
    mode = "600";
  };

  environment.etc = {
    "agenix/id_ed25519_github" = {
      source = config.age.secrets."id_ed25519_github".path;
      mode = "0600";
      user = "vitor";
    };
    "agenix/id_ed25519_github.pub" = {
      text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqZBKKbF5Q1+a6xDfwRbtmNYSojS4wJ30KplklOzKGg vitor@gh0stk";
      mode = "0644";
      user = "vitor";
    };
  };

  programs.ssh.extraConfig = ''
    Host github.com
      IdentityFile /etc/agenix/id_ed25519_github
  '';

  # age.secrets."gpg_private" = {
  #   file = ./gpg_private.age;
  #   path = "/home/vitor/.gnupg/private.key";
  #   owner = "vitor";
  #   mode = "600";
  # };
}
