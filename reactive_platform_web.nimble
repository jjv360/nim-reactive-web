# Package

version                                 = "0.1.7"
author                                  = "jjv360"
description                             = "Plugin for Reactive which provides deployment to Web"
license                                 = "MIT"
srcDir                                  = "src"
installExt                              = @["nim"]
namedBin["reactive_platform_web/cli"]   = "reactive_platform_web"


# Dependencies

requires "nim >= 1.6.2"
requires "classes >= 0.2.12"
requires "https://github.com/jjv360/nim-reactive >= 0.1.7"