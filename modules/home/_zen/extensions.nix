let
  mkPluginUrl = slug: "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";

  mkExt = { slug, pinned ? false }: {
    install_url = mkPluginUrl slug;
    installation_mode = "force_installed";
  } // (if pinned then { default_area = "navbar"; } else {});
in
{
  "{446900e4-71c2-419f-a6a7-df9c091e268b}" = mkExt {
    slug = "bitwarden-password-manager";
    pinned = true;
  };

  "uBlock0@raymondhill.net" = mkExt {
    slug = "ublock-origin";
    pinned = false;
  };

  "addon@darkreader.org" = mkExt {
    slug = "darkreader";
    pinned = false;
  };

  "@testpilot-containers" = mkExt {
    slug = "multi-account-containers";
    pinned = false;
  };

  "zotero@chnm.gmu.edu" = {
    install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
    installation_mode = "force_installed";
  };

  "clipper@obsidian.md" = mkExt {
    slug = "web-clipper-obsidian";
    pinned = false;
  };

  # "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = mkExt { slug = "refined-github-"; };

  # "github-repository-size@pranavmangal" = mkExt { slug = "gh-repo-size"; };
}
