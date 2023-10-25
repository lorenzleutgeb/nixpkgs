{ lib
, fetchFromGitHub
, python3
, libseccomp
, nixosTests
}:
python3.pkgs.buildPythonApplication rec {
  pname = "benchexec";
  version = "3.18";

  src = fetchFromGitHub {
    owner = "sosy-lab";
    repo = "benchexec";
    rev = version;
    hash = "sha256-7A8B6PCDHVAl3FavB6YXLLFgAFJXn45Pp+sJgdpp5do=";
  };

  format = "pyproject";

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs =
    [
      # CPU Energy Meter is not added here, because BenchExec should call the
      # wrapper configured via `security.wrappers.cpu-energy-meter`
      # in `programs.cpu-energy-meter`, which will have the required
      # capabilities to access MSR.
      # If we add `cpu-energy-meter` here, BenchExec will instead call an executable
      # without `CAP_SYS_RAWIO` and fail.
      #pkgs.cpu-energy-meter
      libseccomp.lib
    ]
    ++ (with python3.pkgs; [
      coloredlogs
      lxml
      pystemd
      pyyaml
    ]);

  makeWrapperArgs = [ "--set-default LIBSECCOMP ${lib.getLib libseccomp}/lib/libseccomp.so" ];

  meta = with lib; {
    description = "A Framework for Reliable Benchmarking and Resource Measurement.";
    homepage = "https://github.com/sosy-lab/benchexec";
    maintaners = with maintaners; [ lorenzleutgeb ];
    license = licenses.asl20;
    mainProgram = "benchexec";
  };
}
