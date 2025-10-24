# Sokol Renderer
An educational project to build a renderer on top of Sokol.

_**In order to run, make sure you compile the sokol libs inside of `vendor/sokol` by running the appropriate script for your operating system. **_

Then, execute the build script:

```
./build.sh <run (optional) | debug (optional) | shader (optional)>
```
Note: if no argument is passed, the script will output the build artifact to `target/core`.

The script will clean any build artifacts (shaders, executables), make sure the correct folders are present on your filesystem (`target/`), build the shaders using the tools under `tools`, and then execute the appropriate flavour of `odin run/build ./core -out:target/core`.
