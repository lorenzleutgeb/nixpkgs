{ lib, fetchurl, buildDunePackage, ppx_sexp_conv, ppx_cstruct, cstruct
, cstruct-sexp, sexplib, mirage-crypto, mirage-crypto-pk, mirage-crypto-rng
, x509, domain-name, fmt, cstruct-unix, ounit2, ocaml_lwt, ptime
, hacl_x25519, fiat-p256, hkdf, logs, alcotest }:

buildDunePackage rec {
  minimumOCamlVersion = "4.08";

  version = "0.12.2";
  pname = "tls";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-tls/releases/download/v${version}/tls-v${version}.tbz";
    sha256 = "1wpgs0cd79wl4lnn1i44xjn8prha793nrbyv68zjiqpq3gmpyy3k";
  };

  useDune2 = true;

  doCheck = true;
  checkInputs = [ cstruct-unix ounit2 alcotest ];

  propagatedBuildInputs = [ ppx_sexp_conv ppx_cstruct cstruct cstruct-sexp
                            sexplib mirage-crypto mirage-crypto-pk mirage-crypto-rng
                            x509 domain-name fmt ocaml_lwt ptime hacl_x25519 fiat-p256
                            hkdf logs ];

  meta = with lib; {
    homepage = "https://github.com/mirleft/ocaml-tls";
    description = "TLS in pure OCaml";
    license = licenses.bsd2;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
