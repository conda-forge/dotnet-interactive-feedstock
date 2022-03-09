#!/bin/bash

export DisableArcade=1


dotnet run -p $SRC_DIR/src/interface-generator --out-file $SRC_DIR/src/dotnet-interactive-vscode/src/interfaces/src/contracts.ts
dotnet run -p $SRC_DIR/src/interface-generator --out-file $SRC_DIR/src/dotnet-interactive-npm/src/dotnet-interactive/contracts.ts

dotnet pack --configuration Release --runtime linux-x64 $SRC_DIR/src/dotnet-interactive/dotnet-interactive.csproj
dotnet tool install --framework net6.0 --add-source $SRC_DIR/src/dotnet-interactive/bin/Release --tool-path $DOTNET_TOOLS Microsoft.dotnet-interactive

mkdir "$PREFIX/share/jupyter"
cp -Rv "$RECIPE_DIR/kernels" "$PREFIX/share/jupyter/kernels"

mkdir -p "${PREFIX}/etc/conda/activate.d"
mkdir -p "${PREFIX}/etc/conda/deactivate.d"
cp -r "${RECIPE_DIR}/activate.d/." "${PREFIX}/etc/conda/activate.d/"
cp -r "${RECIPE_DIR}/deactivate.d/." "${PREFIX}/etc/conda/deactivate.d/"
