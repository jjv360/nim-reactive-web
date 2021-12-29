import reactive/utils
import std/os
import std/osproc
import std/strutils

# Fetch command line
let args = processCommandLine()

# Fetch input file
let appEntryPath = absoluteInputFilePath(args)

# Begin building
echo "Building app for web: " & appEntryPath
let returnCode = startProcess("nim", workingDir=absolutePath(appEntryPath / ".."), options={poUsePath, poParentStreams}, args=[
    "js", 
    "--app:gui",
    "--define:release",
    "--define:ReactivePlatformWeb",
    "--define:ReactiveAppEntryFile:" & appEntryPath,
    # "--define:debugclasses",
    "--out:" & absolutePath(appEntryPath / ".." / "dist" / "app.js"),
    appEntryPath
]).waitForExit()

# Write a wrapper HTML file
writeFile(appEntryPath / ".." / "dist" / "app.html", """
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