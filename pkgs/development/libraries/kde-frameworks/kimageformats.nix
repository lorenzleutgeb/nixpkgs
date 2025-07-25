{
  mkDerivation,
  lib,
  extra-cmake-modules,
  ilmbase,
  karchive,
  openexr,
  libavif,
  libheif,
  libjxl,
  libraw,
  qtbase,
}:

let
  inherit (lib) getDev;
in

mkDerivation {
  pname = "kimageformats";

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    karchive
    openexr
    # FIXME: cmake files are broken, disabled for now
    # libavif
    libheif
    libjxl
    libraw
    qtbase
  ];
  outputs = [ "out" ]; # plugins only
  cmakeFlags = [
    "-DKIMAGEFORMATS_HEIF=ON"
  ];
}
