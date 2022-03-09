setlocal enableextensions
setlocal enabledelayedexpansion


set DisableArcade=1

dotnet pack --configuration Release --runtime win-x64 %SRC_DIR%/src/dotnet-interactive/dotnet-interactive.csproj
dotnet tool install --framework net6.0 --add-source %SRC_DIR%/src/dotnet-interactive/bin/X64/Release --tool-path %DOTNET_TOOLS% Microsoft.dotnet-interactive

mkdir "%PREFIX%\share\jupyter"
xcopy "%RECIPE_DIR%\kernels" "%PREFIX%\share\jupyter\kernels" /E /I /F /Y


mkdir "%PREFIX%/etc/conda/activate.d"
mkdir "%PREFIX%/etc/conda/deactivate.d"
xcopy "%RECIPE_DIR%/activate.d" "%PREFIX%/etc/conda/activate.d" /E /I /F /Y
xcopy "%RECIPE_DIR%/deactivate.d" "%PREFIX%/etc/conda/deactivate.d" /E /I /F /Y
