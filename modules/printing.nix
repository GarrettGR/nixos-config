{ pkgs, ... }: 
{
  services = {  
    printing = {
      enable = true;
      browsing = true;
      drivers = with pkgs; [
        hplip
        brlaser
        gutenprint
      ];
      browsedConf = ''
        BrowseDNSSDSubTypes _cups,_print
        BrowseLocalProtocols all
        BrowseRemoteProtocols all
        CreateIPPPrinterQueues All
        BrowseProtocols all
      '';
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    cups = {
      enable = true;
      autoStart = true;
      extraConfig = ''
        DefaultEncryption IfRequested
        DefaultAuthType None
        DefaultPasswordFormat None
        DefaultShared Off
        DefaultPrinter @PRINTER@
      '';
      extraOptions = {
        "BrowseRemoteProtocols" = "all";
        "BrowseLocalProtocols" = "all";
        "BrowseDNSSDSubTypes" = "_printer,_ipp,_ipps,_print";
      };
    };
  };
}