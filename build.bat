@echo off
setlocal
REM Usage: build.bat [Debug|Release]
REM Default: Release (deploys Qt DLLs beside the gallery exe).
set "CONFIG=%~1"
if "%CONFIG%"=="" set "CONFIG=Release"

call "D:\vsproduct\VC\Auxiliary\Build\vcvars64.bat" || exit /b 1
set "PATH=D:\Qt\Tools\Ninja;D:\Qt\6.8.0\msvc2022_64\bin;%PATH%"
where cl
where ninja

if /I "%CONFIG%"=="Release" (
  set "DEPLOY_FLAG=--release"
) else if /I "%CONFIG%"=="Debug" (
  set "DEPLOY_FLAG=--debug"
) else (
  echo Unknown config "%CONFIG%". Use Debug or Release.
  exit /b 1
)

if exist "D:\QWinui3\build" rmdir /s /q "D:\QWinui3\build"
cmake -S "D:\QWinui3" -B "D:\QWinui3\build" -G Ninja -DCMAKE_PREFIX_PATH=D:/Qt/6.8.0/msvc2022_64 -DCMAKE_BUILD_TYPE=%CONFIG%
if errorlevel 1 exit /b 1
cmake --build "D:\QWinui3\build" --parallel
if errorlevel 1 exit /b 1

echo.
echo Deploying Qt runtime (%CONFIG%) next to qwinui3_gallery.exe ...
windeployqt %DEPLOY_FLAG% --qmldir "D:\QWinui3\src" --no-translations "D:\QWinui3\build\qwinui3_gallery.exe"
if errorlevel 1 exit /b 1

REM Multimedia backends are often missed by windeployqt — copy explicitly when present.
if exist "D:\Qt\6.8.0\msvc2022_64\plugins\multimedia" (
  if not exist "D:\QWinui3\build\plugins\multimedia" mkdir "D:\QWinui3\build\plugins\multimedia"
  copy /Y "D:\Qt\6.8.0\msvc2022_64\plugins\multimedia\*.dll" "D:\QWinui3\build\plugins\multimedia\" >nul
)
for %%F in (avcodec-61.dll avformat-61.dll avutil-59.dll swresample-5.dll swscale-8.dll) do (
  if exist "D:\Qt\6.8.0\msvc2022_64\bin\%%F" copy /Y "D:\Qt\6.8.0\msvc2022_64\bin\%%F" "D:\QWinui3\build\" >nul
)

REM Strip GPL/Commercial add-ons that windeployqt may have copied.
for %%D in (
  "qml\QtQuick\VirtualKeyboard"
  "qml\QtQuick\Scene2D"
  "qml\QtQuick\Scene3D"
  "qml\QtCharts"
  "qml\QtDataVisualization"
  "qml\QtWebEngine"
  "qml\QtWebView"
  "qml\QtQuick3D"
  "qml\QtGraphs"
) do if exist "D:\QWinui3\build\%%~D" rmdir /s /q "D:\QWinui3\build\%%~D"
for %%F in (
  Qt6VirtualKeyboard.dll
  Qt6VirtualKeyboardQml.dll
  Qt6Charts.dll
  Qt6ChartsQml.dll
  Qt6DataVisualization.dll
  Qt6DataVisualizationQml.dll
  Qt6WebEngineCore.dll
  Qt6WebEngineQuick.dll
  Qt6WebEngineWidgets.dll
  Qt6WebView.dll
  Qt6Quick3D.dll
  Qt6Quick3DRuntimeRender.dll
  Qt6Quick3DUtils.dll
  Qt6Graphs.dll
  platforminputcontexts\qtvirtualkeyboardplugin.dll
) do if exist "D:\QWinui3\build\%%F" del /f /q "D:\QWinui3\build\%%F"

> "D:\QWinui3\build\qt.conf" (
  echo [Paths]
  echo Prefix = .
  echo Libraries = .
  echo Binaries = .
  echo Plugins = plugins
  echo QmlImports = D:/QWinui3/build/src/platform/QWinUI3,D:/QWinui3/build/src/extras/QWinUI3,D:/QWinui3/build/src/theme/QWinUI3,qml
)

> "D:\QWinui3\build\run-gallery.cmd" (
  echo @echo off
  echo setlocal
  echo set "PATH=%%~dp0;D:\Qt\6.8.0\msvc2022_64\bin;%%PATH%%"
  echo cd /d "%%~dp0"
  echo start "" "%%~dp0qwinui3_gallery.exe" %%*
)

echo.
echo Done: D:\QWinui3\build\qwinui3_gallery.exe ^(%CONFIG%^)
echo Run via: D:\QWinui3\build\run-gallery.cmd
endlocal
