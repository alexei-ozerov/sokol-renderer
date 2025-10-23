#!/bin/bash 

set -e 

RUN_MODE=$1
SHADERS=$(ls assets/shaders | grep -v compiled)

echo -e "Checking target directories exist."
mkdir -p target

echo -e "Cleaning compiled shader directory."
rm assets/shaders/compiled/*

echo -e "Recompiling shaders."
for F in $SHADERS; do
    SHADER_NAME=${F::-5}
    ./tools/sokol-shdc --input assets/shaders/${SHADER_NAME}.glsl -o assets/shaders/compiled/${SHADER_NAME}_shader.odin -f sokol_odin -l hlsl5:glsl430
done

echo -e "Cleaning build artifacts."
rm target/*

if [[ ${RUN_MODE} == "debug" ]]; then
    echo -e "Running core in debug mode."
    odin run ./core -debug -out:target/core
    rm core.bin
elif [[ ${RUN_MODE} == "run" ]]; then
    echo -e "Running core."
    odin run ./core -out:target/core
    rm core.bin
else
    echo -e "Building core."
    odin build ./core -out:target/core
fi

echo -e "Done."

exit 0
