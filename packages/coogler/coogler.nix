{
  inputs,
  libclang,
  rustPlatform,
  ...
}:
# NOTE:: Find a way to sanitize lockfile generation
rustPlatform.buildRustPackage {
  pname = "coogler";
  version = "0.1.0";
  src = inputs.Coogler;
  cargoLock = ./Cargo.lock;
  nativeBuildInputs = [libclang.lib]; # Avoid having it GC'd
  cargoHash = "sha256-LjjJAE304cG7l2nii47APRL8LqUKOZY3oTv/XdeYD6s=";
  LIBCLANG_PATH = "${libclang.lib}/lib";
  RUST_BACKTRACE = 1;
}
