#!/bin/bash 

set -e 

RUN_MODE=$1
SHADERS=$(ls assets/shaders | grep -v archive)

echo -e "Checking target directories exist."
mkdir -p target

echo -e "Recompiling shaders."
for F in $SHADERS; do
    SHADER_NAME=${F::-5}
    ./tools/sokol-shdc --input assets/shaders/${SHADER_NAME}.glsl -o core/${SHADER_NAME}_shader.odin -f sokol_odin -l hlsl5:glsl430
done

echo -e "Cleaning build artifacts."
if [[ $(ls target) != "" ]]; then
    rm target/*
fi

if [[ ${RUN_MODE} == "debug" ]]; then
    echo -e "Running core in debug mode."
    odin run ./core -debug -out:target/core
    if [[ $(ls | grep bin) != "" ]]; then
        rm core.bin
    fi
elif [[ ${RUN_MODE} == "run" ]]; then
    echo -e "Running core."
    odin run ./core -out:target/core
    if [[ $(ls | grep bin) != "" ]]; then
        rm core.bin
    fi
elif [[ ${RUN_MODE} == "shader" ]]; then 
    echo -e "Rebuild shaders, exiting."
else
    echo -e "Building core."
    odin build ./core -out:target/core
fi

echo -e "Done."

exit 0
