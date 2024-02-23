{
  description = "Realtime Vulkan ray tracing";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay,... }: let
    lib = {
      inherit (flake-utils.lib) defaultSystems eachSystem;
    };
    supportedSystems = [ "x86_64-linux" ];
  in lib.eachSystem supportedSystems (system: let
    nightlyVersion = "2024-01-30";

    #pkgs = mars-std.legacyPackages.${system};
    pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (import rust-overlay)
          #(import ./pkgs)
        ];
      };
    pinnedRust = pkgs.rust-bin.nightly.${nightlyVersion}.default.override {
      extensions = ["rustc-dev" "rust-src" "rust-analyzer-preview" ];
      targets = [ "x86_64-unknown-linux-gnu" ];
    };
    rustPlatform = pkgs.makeRustPlatform {
      rustc = pinnedRust;
      cargo = pinnedRust;
    };
    #cargoPlay = pkgs.cargo-feature.override { inherit rustPlatform; };
  in {
    
devShell = pkgs.mkShell rec {
  hardeningDisable = [
    "fortify"
  ];
  nativeBuildInputs = with pkgs; [
    #cargoPlay 
    pkg-config

    # openssl
  ];
  buildInputs = with pkgs; [
    aflplusplus
    bear
    gnumake
    gnuplot


    libb2

    # glibc

    zlib
    bzip2
    lz4
    zstd
    cmake
    gcc
  ];

  # ZLIB_LIBRARY= "${pkgs.lib.makeLibraryPath [pkgs.zlib-ng]}";
  # BZIP2_LIBRARIES = "${pkgs.lib.makeLibraryPath [pkgs.bzip2]}";

  shellHook = ''
    # export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath buildInputs}";
  '';
};

  });
}
