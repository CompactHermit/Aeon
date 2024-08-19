{
  lib,
  stdenv,
  fetchurl,
  curl,
  bcrypt,
  build,
  buildPythonPackage,
  cargo,
  chroma-hnswlib,
  fastapi,
  fetchFromGitHub,
  grpcio,
  httpx,
  hypothesis,
  jsonschema,
  importlib-resources,
  kubernetes,
  mmh3,
  nixosTests,
  numpy,
  onnxruntime,
  openssl,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-grpc,
  opentelemetry-instrumentation-fastapi,
  opentelemetry-sdk,
  orjson,
  overrides,
  pkg-config,
  posthog,
  protobuf,
  psutil,
  pulsar-client,
  pydantic,
  pypika,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  rustc,
  rustPlatform,
  setuptools-scm,
  setuptools,
  tenacity,
  tokenizers,
  tqdm,
  typer,
  typing-extensions,
  uvicorn,
  zstd,
}:
let
  fastapi' = fastapi.overrideAttrs (oa: {
    version = "0.115.9";
    src = fetchFromGitHub {
      owner = "tiangolo";
      repo = "fastapi";
      tag = "0.115.9";
      hash = "sha256-ImrkrZbYTozwVDryp0OqdMGGvMgot19yoJcaN5inQsM=";
    };
  });
  opentelemetry-instrumentation-fastapi' = opentelemetry-instrumentation-fastapi.override {
    fastapi = fastapi';
  };
in
buildPythonPackage rec {
  pname = "chromadb";
  version = "1.0.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "chroma-core";
    repo = "chroma";
    tag = version;
    hash = "sha256-nCzV9ttm21ETVusstnN7lA+XtEsWIXv3rsikw0l3EnQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-6M6Vs5sCDx6aQTkv45XzECEBcytyjDvOVSIzwDvz5S8=";
  };

  pythonRelaxDeps = [
    "chroma-hnswlib"
    "orjson"
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    cargo
    pkg-config
    protobuf
    rustc
    curl
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = [
    openssl
    zstd
  ];

  dependencies = [
    bcrypt
    build
    chroma-hnswlib
    fastapi'
    grpcio
    httpx
    importlib-resources
    kubernetes
    jsonschema
    mmh3
    numpy
    onnxruntime
    opentelemetry-api
    opentelemetry-exporter-otlp-proto-grpc
    opentelemetry-instrumentation-fastapi'
    opentelemetry-sdk
    orjson
    overrides
    posthog
    pulsar-client
    pydantic
    pypika
    pyyaml
    requests
    tenacity
    tokenizers
    tqdm
    typer
    typing-extensions
    uvicorn
  ];

  nativeCheckInputs = [
    hypothesis
    psutil
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "chromadb" ];

  env = {
    #ZSTD_SYS_USE_PKG_CONFIG = true;

    SWAGGER_UI_DOWNLOAD_URL =
      let
        # When updating:
        # - Look for the version of `utoipa-swagger-ui` at:
        #   https://github.com/EricLBuehler/mistral.rs/blob/v<MISTRAL-RS-VERSION>/mistralrs-server/Cargo.toml
        # - Look at the corresponding version of `swagger-ui` at:
        #   https://github.com/juhaku/utoipa/blob/utoipa-swagger-ui-<UTOPIA-SWAGGER-UI-VERSION>/utoipa-swagger-ui/build.rs#L21-L22
        swaggerUiVersion = "5.17.12";

        swaggerUi = fetchurl {
          url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v${swaggerUiVersion}.zip";
          hash = "sha256-HK4z/JI+1yq8BTBJveYXv9bpN/sXru7bn/8g5mf2B/I=";
        };
      in
      "file://${swaggerUi}";

  };

  pytestFlagsArray = [ "-x" ];

  preCheck = ''
    (($(ulimit -n) < 1024)) && ulimit -n 1024
    export HOME=$(mktemp -d)
  '';

  doCheck = false;
  # disabledTests = [
  #   # Tests are laky / timing sensitive
  #   "test_fastapi_server_token_authn_allows_when_it_should_allow"
  #   "test_fastapi_server_token_authn_rejects_when_it_should_reject"
  #   # Issue with event loop
  #   "test_http_client_bw_compatibility"
  #   # Issue with httpx
  #   "test_not_existing_collection_delete"
  # ];

  # disabledTestPaths = [
  #   # Tests require network access
  #   # "chromadb/test/auth/test_simple_rbac_authz.py"
  #   "chromadb/test/db/test_system.py"
  #   "chromadb/test/ef/test_default_ef.py"
  #   "chromadb/test/property/"
  #   "chromadb/test/property/test_cross_version_persist.py"
  #   "chromadb/test/stress/"
  #   "chromadb/test/test_api.py"
  # ];

  passthru.tests = {
    inherit (nixosTests) chromadb;
  };

  meta = with lib; {
    description = "AI-native open-source embedding database";
    homepage = "https://github.com/chroma-core/chroma";
    changelog = "https://github.com/chroma-core/chroma/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "chroma";
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
}
