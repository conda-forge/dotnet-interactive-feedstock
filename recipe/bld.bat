setlocal enableextensions
setlocal enabledelayedexpansion


dotnet pack %SRC_DIR%/src/dotnet-interactive/dotnet-interactive.csproj
dotnet tool install --add-source %SRC_DIR%/src/dotnet-interactive/bin/Debug --tool-path %DOTNET_TOOLS% Microsoft.dotnet-interactive

mkdir "%PREFIX%\share\jupyter"
xcopy "%RECIPE_DIR%\kernels" "%PREFIX%\share\jupyter\kernels" /E /I /F /Y
