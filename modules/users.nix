{
  pkgs,
  lib,
  hostname,
  ...
}: {
  users = {
    mutableUsers = false;
    users = {
      garrettgr = {
        isNormalUser = true;
        hashedPassword = "$y$j9T$aJmECtPF9vQFrrcKekuiC.$GdBTLC1ly84/cIJik7AMhK2iy2lYHLJxvVe3ywu9wr8";
        shell = pkgs.zsh;
        extraGroups = ["wheel" "networkmanager" "lp"];
      };
      jgonnerman = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJLH0bT0g53Upvoq6+EVBJvcdfwZowgHpIo1TQddwB8N Jesse G. - JerseyCTF NixOs"
        ];
      };
      rkhan = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWWYka+zi77QwvAXEJ2S6zSp4uNzXZigHuF7qotoCcMFXEvT+vjmiOFYBdaRvdL8fMwjzOeDFSduARq4Byeb16fQiFY4BehphswP+cwu8T8H0sHxVYv66fYhE1rzUWne6Kvy/xkz04kcqA+Mhj31zocS+pagpxkO+2d21giYQzxtZfTlaZjq80CUWzCpkP1pCL4fzbVNOa7tJI2LIIboe5wjQWoFzv30bpc/lvED45f2b1yw1fa+hnVmn2u7KEVUBBcD5uZ1Q+VLyANlwzwJoZVX+7j73iuS4bLr6Jx0JlhotwWOyulHH4eOLW0flT+iN3KCLlUYJLsj/qeCS98laXEiNBg6cV3GBKWnKT88eScoMHoWVbOUmRFWdnR1eKdzvKVIQbUC/OmunxCZ/jZfKyM3LIKe3uJu22G+GAbmPA/ivLJ39gQMsZtdY2EoExYVrwccfssoxz2m/1QWPGd/9FVjVGyGRfRE7l76uVFITpUYvcKiLvrPmpR8MWieQUkIU= rayya@RayNZXT"
        ];
      };
    };
  };

  home-manager = {
    users.garrettgr.imports =
      [
        ../home/garrettgr
      ]
      ++ lib.optional (builtins.pathExists ./../hosts/${hostname}/home-manager/default.nix) ./../hosts/${hostname}/home-manager;
    useGlobalPkgs = true;
    useUserPackages = true;
  };
  programs.zsh.enable = true;
}
