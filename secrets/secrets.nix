let
  vitor = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqZBKKbF5Q1+a6xDfwRbtmNYSojS4wJ30KplklOzKGg vitor@gh0stk";
  gh0stk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJkDzuKgbHg4BXVIKeQxavxf4iFdhrDPqwaz8RjdVN9 root@gh0stk";
  slime = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFCiEPjzDHZKm5ISg3RuL3EGTN/s/49Mxu2W1ftx8s6v root@slime";
in
{
  "id_ed25519_github.age".publicKeys = [
    vitor
    gh0stk
    slime
  ];
  # "gpg_private.age".publicKeys = [
  #   vitor
  #   gh0stk
  #   slime
  # ];
}
