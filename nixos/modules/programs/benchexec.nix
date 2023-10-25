{ lib
, pkgs
, config
, options
, ...
}:
let
  cfg = config.programs.benchexec;
  opt = options.programs.benchexec;
in
{
  options.programs.benchexec = {
    enable = lib.options.mkEnableOption "BenchExec";
    package = lib.options.mkPackageOption pkgs "benchexec" { };

    users = lib.options.mkOption {
      type = lib.types.listOf lib.types.str;
      description = lib.mdDoc ''
        Users that intend to use BenchExec. Control group delegation will be configured via systemd.
        For more information, see <https://github.com/sosy-lab/benchexec/blob/3.18/doc/INSTALL.md#setting-up-cgroups>.
      '';
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = map
      (user: {
        assertion = config.users.users ? ${user};
        message = ''
          The user '${user}' intends to use BenchExec (via `${opt.users}`), but is not configured via `${options.users.users}`.
        '';
      })
      cfg.users;

    environment.systemPackages = [ cfg.package ];
    security.unprivilegedUsernsClone = true;
    systemd = {
      enableUnifiedCgroupHierarchy = true;

      # See <https://github.com/sosy-lab/benchexec/blob/3.18/doc/INSTALL.md#setting-up-cgroups>.
      services = builtins.listToAttrs
        (user: {
          name = "user@${builtins.toString config.users.users.${user}.uid}";
          value.serviceConfig.Delegate = "yes";
        })
        cfg.users;
    };

    programs = {
      cpu-energy-meter.enable = lib.mkDefault true;
      pqos-wrapper.enable = lib.mkDefault true;
    };
  };

  meta = with lib; {
    maintainers = with maintainers; [ lorenzleutgeb ];
  };
}
