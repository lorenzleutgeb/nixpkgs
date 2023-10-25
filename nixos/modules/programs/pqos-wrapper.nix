{ config
, lib
, pkgs
, ...
}: {
  options.programs.pqos-wrapper = with lib.options; {
    enable = mkEnableOption "pqos-wrapper";
    package = mkPackageOption pkgs "pqos-wrapper" { };
  };

  config =
    let
      cfg = config.programs.pqos-wrapper;
    in
    lib.mkIf cfg.enable {
      hardware.cpu.x86.msr.enable = true;

      security.wrappers.${cfg.package.meta.mainProgram} = {
        owner = "nobody";
        group = config.hardware.cpu.x86.msr.group;
        source = lib.getExe cfg.package;
        capabilities = "cap_sys_rawio=eip";
      };
    };

  meta = with lib; {
    maintainers = with maintainers; [ lorenzleutgeb ];
  };
}
