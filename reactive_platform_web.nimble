# Package

version       = "0.1.3"
author        = "jjv360"
description   = "Plugin for Reactive which provides deployment to Web"
license       = "MIT"
srcDir        = "src"
namedBin      = @{"reactive_platform_web/cli": "reactive_platform_web"}.toTable

# Dependencies

requires "nim >= 1.6.2"
requires "https://github.com/jjv360/nim-reactive >= 0.1.2"