#!/bin/bash

export DisableArcade=1


pushd $SRC_DIR/src/microsoft-dotnet-interactive
npm ci
npm run compile
popd

dotnet pack --configuration Release --runtime linux-x64 $SRC_DIR/src/dotnet-interactive/dotnet-interactive.csproj
dotnet tool install --framework net6.0 --add-source $SRC_DIR/src/dotnet-interactive/bin/Release --tool-path $DOTNET_TOOLS Microsoft.dotnet-interactive

mkdir "$PREFIX/share/jupyter"
cp -Rv "$RECIPE_DIR/kernels" "$PREFIX/share/jupyter/kernels"

mkdir -p "${PREFIX}/etc/conda/activate.d"
mkdir -p "${PREFIX}/etc/conda/deactivate.d"
cp -r "${RECIPE_DIR}/activate.d/." "${PREFIX}/etc/conda/activate.d/"
cp -r "${RECIPE_DIR}/deactivate.d/." "${PREFIX}/etc/conda/deactivate.d/"
