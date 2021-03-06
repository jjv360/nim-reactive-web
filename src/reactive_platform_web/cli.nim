import reactivepkg/utils
import std/os
import std/osproc
import std/strutils
import std/json

# Fetch build args
let buildInfo = getReactiveBuildOptions()

# Begin building
let returnCode = startProcess("nim", options={poUsePath, poParentStreams}, args=[
    "js", 
    "--app:gui",
    "--define:release",
    "--define:ReactivePlatformWeb",
    "--define:ReactiveInjectImports:reactive_platform_web",
    # "--define:debugclasses",
    "--out:" & absolutePath(buildInfo["projectRoot"].getStr() / "dist" / "web" / "app.js"),
    buildInfo["entrypoint"].getStr()
]).waitForExit()

# Write a wrapper HTML file
writeFile(absolutePath(buildInfo["projectRoot"].getStr() / "dist" / "web" / "app.html"), """
    <!DOCTYPE html>
    <html>
    <head>
        <title>App Title</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    </head>
    <body>

        <!-- Web app default styling -->
        <style>
            html, body {
                margin: 0px;
                padding: 0px;
            }
        </style>

        <!-- App code -->
        <script src="app.js"></script>
        
    </body>
    </html>
""".strip())