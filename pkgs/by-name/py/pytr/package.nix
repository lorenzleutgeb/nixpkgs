{
  fetchFromGitHub,
  installShellFiles,
  lib,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "pytr";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytr-org";
    repo = "pytr";
    tag = "v${version}";
    hash = "sha256-7554su1bR3m6wcIcmT64O+x/kvVlDMsG/hkTym25B/Q=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-babel
  ];

  dependencies = with python3Packages; [
    babel
    certifi
    coloredlogs
    ecdsa
    packaging
    pathvalidate
    pygments
    requests-futures
    shtab
    websockets
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd pytr \
      --bash <($out/bin/pytr completion bash) \
      --zsh <($out/bin/pytr completion zsh)
  '';

  nativeCheckInputs = [
    versionCheckHook
    python3Packages.pytestCheckHook
  ];

  versionCheckProgramArg = "--version";

  pythonImportsCheck = [ "pytr" ];

  meta = {
    changelog = "https://github.com/pytr-org/pytr/releases/tag/${src.tag}";
    description = "Use TradeRepublic in terminal and mass download all documents";
    homepage = "https://github.com/pytr-org/pytr";
    license = lib.licenses.mit;
    mainProgram = "pytr";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
