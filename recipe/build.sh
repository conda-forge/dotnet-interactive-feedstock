#!/bin/bash
set -euox pipefail

export DisableArcade=1
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

dotnet run --project $SRC_DIR/src/interface-generator --out-file $SRC_DIR/src/microsoft-dotnet-interactive/src/contracts.ts

# https://github.com/dotnet/interactive/blob/d0aa0c06e25ba19cb6085d7a9641c1ecb1a9ee59/eng/build.sh#L45-L48
npm_dirs=(
    "$SRC_DIR/src/microsoft-dotnet-interactive"
    "$SRC_DIR/src/microsoft-dotnet-interactive-browser"
    "$SRC_DIR/src/dotnet-interactive-vscode"
    "$SRC_DIR/src/dotnet-interactive-vscode-insiders"
)
for npm_dir in ${npm_dirs[@]}; do
    pushd $npm_dir
    echo $npm_dir
    npm ci
    npm run compile
    popd
done
dotnet pack --configuration Release --runtime linux-x64 $SRC_DIR/src/dotnet-interactive/dotnet-interactive.csproj /p:Version=$PKG_VERSION
dotnet tool install --framework net7.0 --version $PKG_VERSION --add-source $SRC_DIR/src/dotnet-interactive/bin/Release --tool-path $DOTNET_TOOLS Microsoft.dotnet-interactive

mkdir "$PREFIX/share/jupyter"
cp -Rv "$RECIPE_DIR/kernels" "$PREFIX/share/jupyter/kernels"

mkdir -p "${PREFIX}/etc/conda/activate.d"
mkdir -p "${PREFIX}/etc/conda/deactivate.d"
cp -r "${RECIPE_DIR}/activate.d/." "${PREFIX}/etc/conda/activate.d/"
cp -r "${RECIPE_DIR}/deactivate.d/." "${PREFIX}/etc/conda/deactivate.d/"
