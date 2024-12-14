{ lib, appimageTools, fetchurl, gitUpdater }:
let
  pname = "zen-browser";
  version = "1.0.2-b.1";
  sha256 = "sha256-MjY7LamqmCAP/In9ycW18jjqGSafM7tS5vYCjflbb3E=";
  url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-specific.AppImage";
  src = fetchurl {
    inherit url sha256;
  };
  extracted = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
  install -m 444 -D ${extracted}/zen.desktop $out/share/applications/zen.desktop
  install -m 444 -D ${extracted}/usr/share/icons/hicolor/128x128/apps/zen.png $out/share/icons/hicolor/128x128/apps/zen.png
  substituteInPlace $out/share/applications/zen.desktop --replace 'Exec=zen' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Experience tranquillity while browsing the web without people tracking you!";
    homepage = "https://zen-browser.app";
    license = licenses.mpl20;
    platforms = [ "x86_64-linux" ];
  };

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    odd-unstable = false;
    patchlevel-unstable = false;
    url = "https://github.com/zen-browser/desktop.git";
  };
}
