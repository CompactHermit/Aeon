{ inputs, lib, buildGoModule, testers, carapace, }:

buildGoModule rec {
  pname = "carapace";
  version = "1.0.1";
  src = inputs.carapace;
  vendorHash = "sha256-HWczvkItE9SVGGQkddnb7/PBkTWrDAdKHjMOztlYV9M=";
  ldflags = [ "-s" "-w" "-X main.version=${version}" ];
  subPackages = [ "./cmd/carapace" ];
  tags = [ "release" ];
  preBuild = ''
    GOOS= GOARCH= go generate ./...
  '';
  passthru.tests.version = testers.testVersion { package = carapace; };
}
