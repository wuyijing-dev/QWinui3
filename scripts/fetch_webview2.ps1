# Fetch Microsoft.Web.WebView2 NuGet into third_party/webview2 (gitignored).
param(
    [string]$Version = "1.0.2903.40",
    [string]$OutRoot = (Join-Path $PSScriptRoot "..\third_party\webview2")
)

$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Force -Path $OutRoot | Out-Null
$zip = Join-Path $OutRoot "wv2.zip"
$pkg = Join-Path $OutRoot "pkg"
$uri = "https://api.nuget.org/v3-flatcontainer/microsoft.web.webview2/$Version/microsoft.web.webview2.$Version.nupkg"

Write-Host "Downloading $uri"
Invoke-WebRequest -Uri $uri -OutFile $zip -UseBasicParsing
if (Test-Path $pkg) { Remove-Item -Recurse -Force $pkg }
Expand-Archive -LiteralPath $zip -DestinationPath $pkg -Force
Write-Host "SDK ready at $pkg\build\native"
Write-Host "Reconfigure CMake with -DQWINUI3_BUILD_WEBVIEW2=ON"
