{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  coreutils,
  llvmPackages,
  libxml2,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "zig";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "ziglang";
    repo = pname;
    rev = "b677b3627818edc24828f36f8269a3c3843703a1";
    hash = "sha256-gMiRWoHHWYQ2ewrewnpSAVIh35w9C06GFnQWd+pEnjI=";
  };

  nativeBuildInputs = [
    cmake
    llvmPackages.llvm.dev
  ];

  buildInputs =
    [
      coreutils
      libxml2
      zlib
    ]
    ++ (with llvmPackages; [
      libclang
      lld
      llvm
    ]);

  preBuild = ''
    export HOME=$TMPDIR;
  '';

  postPatch = ''
    # Zig's build looks at /usr/bin/env to find dynamic linking info. This
    # doesn't work in Nix' sandbox. Use env from our coreutils instead.
    substituteInPlace lib/std/zig/system/NativeTargetInfo.zig --replace "/usr/bin/env" "${coreutils}/bin/env"
  '';

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"

    # always link against static build of LLVM
    "-DZIG_STATIC_LLVM=ON"

    # ensure determinism in the compiler build
    "-DZIG_TARGET_MCPU=baseline"
  ];

  doCheck = false;

  installCheckPhase = ''
    $out/bin/zig test --cache-dir "$TMPDIR" -I $src/test $src/test/behavior.zig
  '';

  meta = with lib; {
    homepage = "https://ziglang.org/";
    description = "General-purpose programming language and toolchain for maintaining robust, optimal, and reusable software";
    license = licenses.mit;
    maintainers = with maintainers; [aiotter andrewrk AndersonTorres];
    platforms = platforms.unix;
  };
}
