#!/bin/bash

export DisableArcade=1

dotnet pack -p:TargetFrameworks=net5.0 --configuration Release --runtime linux-x64 $SRC_DIR/src/dotnet-interactive/dotnet-interactive.csproj
dotnet tool install --add-source $SRC_DIR/src/dotnet-interactive/bin/Release --tool-path $DOTNET_TOOLS Microsoft.dotnet-interactive

mkdir "$PREFIX/share/jupyter"
cp -Rv "$RECIPE_DIR/kernels" "$PREFIX/share/jupyter/kernels"
