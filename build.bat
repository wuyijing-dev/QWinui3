@echo off
call "D:\vsproduct\VC\Auxiliary\Build\vcvars64.bat" || exit /b 1
set "PATH=D:\Qt\Tools\Ninja;D:\Qt\6.8.0\msvc2022_64\bin;%PATH%"
where cl
where ninja
if exist "D:\QWinui3\build" rmdir /s /q "D:\QWinui3\build"
cmake -S "D:\QWinui3" -B "D:\QWinui3\build" -G Ninja -DCMAKE_PREFIX_PATH=D:/Qt/6.8.0/msvc2022_64 -DCMAKE_BUILD_TYPE=Debug
if errorlevel 1 exit /b 1
cmake --build "D:\QWinui3\build" --parallel
