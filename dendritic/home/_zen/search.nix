{pkgs, ...}:

let
  nixSnowflakeIcon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
in
{
  force = true;
  default = "Kagi";

  engines = {
    # Primary

    "Kagi" = {
      urls = [{
        template = "https://kagi.com/search?token=68CWV7HQnJ4RurPC2hI35JA_NsX0lx0jTwZ2yrkvq1Q.Pvaaky1T-zie73tIYisacuFPe_NJ32iuqT1mDOdgcvg";
        params = [{ name = "q"; value = "{searchTerms}"; }];
      }];
      definedAliases = [ "@k" "k" ];
    };

    # Nix

    "Nix Packages" = {
      urls = [{
        template = "https://search.nixos.org/packages";
        params = [
          { name = "type"; value = "packages"; }
          { name = "channel"; value = "unstable"; }
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];
      icon = nixSnowflakeIcon;
      definedAliases = [ "@np" "p" ];
    };

    "Nix Options" = {
      urls = [{
        template = "https://search.nixos.org/options";
        params = [
          { name = "channel"; value = "unstable"; }
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];
      icon = nixSnowflakeIcon;
      definedAliases = [ "@no" "o" ];
    };

    "Home Manager Options" = {
      urls = [{
        template = "https://home-manager-options.extranix.com/";
        params = [
          { name = "query"; value = "{searchTerms}"; }
          { name = "release"; value = "master"; }
        ];
      }];
      icon = nixSnowflakeIcon;
      definedAliases = [ "@hm" "hm" ];
    };

    # Academic

    "Google Scholar" = {
      urls = [{
        template = "https://scholar.google.com/scholar";
        params = [{ name = "q"; value = "{searchTerms}"; }];
      }];
      definedAliases = [ "@gs" "gs" ];
    };

    "arXiv" = {
      urls = [{
        template = "https://arxiv.org/search/";
        params = [
          { name = "searchtype"; value = "all"; }
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];
      definedAliases = [ "@ax" "ax" ];
    };

    "Semantic Scholar" = {
      urls = [{
        template = "https://www.semanticscholar.org/search";
        params = [
          { name = "q"; value = "{searchTerms}"; }
          { name = "sort"; value = "Relevance"; }
        ];
      }];
      definedAliases = [ "@ss" "ss" ];
    };

    "IEEE Xplore" = {
      urls = [{
        template = "https://ieeexplore.ieee.org/search/searchresult.jsp";
        params = [{ name = "queryText"; value = "{searchTerms}"; }];
      }];
      definedAliases = [ "@ieee" "ieee" ];
    };



    "google".metaData.hidden = true;
    "bing".metaData.hidden = true;
    "amazondotcom-us".metaData.hidden = true;
    "ebay".metaData.hidden = true;
  };
}
