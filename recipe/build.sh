#!/bin/bash

export DisableArcade=1
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

dotnet run --project $SRC_DIR/src/interface-generator --out-file $SRC_DIR/src/dotnet-interactive-vscode/common/interfaces/contracts.ts
npm_dirs=(
    "$SRC_DIR/src/dotnet-interactive-npm"
    "$SRC_DIR/src/dotnet-interactive-vscode/stable"
    "$SRC_DIR/src/dotnet-interactive-vscode/insiders"
    "$SRC_DIR/src/Microsoft.DotNet.Interactive.Js"
)
for npm_dir in ${npm_dirs[@]}; do
    pushd $npm_dir
    echo $npm_dir
    npm ci
    npm run compile
    popd
done
dotnet pack --configuration Release --runtime linux-x64 $SRC_DIR/src/dotnet-interactive/dotnet-interactive.csproj
dotnet tool install --framework net6.0 --add-source $SRC_DIR/src/dotnet-interactive/bin/Release --tool-path $DOTNET_TOOLS Microsoft.dotnet-interactive

mkdir "$PREFIX/share/jupyter"
cp -Rv "$RECIPE_DIR/kernels" "$PREFIX/share/jupyter/kernels"

mkdir -p "${PREFIX}/etc/conda/activate.d"
mkdir -p "${PREFIX}/etc/conda/deactivate.d"
cp -r "${RECIPE_DIR}/activate.d/." "${PREFIX}/etc/conda/activate.d/"
cp -r "${RECIPE_DIR}/deactivate.d/." "${PREFIX}/etc/conda/deactivate.d/"
