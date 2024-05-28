$ErrorActionPreference = 'Stop';

$softwareName = '微信开发者工具*'
[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -gt 0) {
    Invoke-Expression -Command $PSScriptRoot\chocolateyUninstall.ps1
}

$url = 'https://servicewechat.com/wxa-dev-logic/download_redirect?type=win32_ia32&from=mpwiki&download_version=1062402040&version_type=1'
$checksum = '9A2DAC58C444225141E2E51543057B00E3400E57B6D24998BF2BBEF0E7A86CA7'

$url64 = 'https://servicewechat.com/wxa-dev-logic/download_redirect?type=win32_x64&from=mpwiki&download_version=1062402040&version_type=1'
$checksum64 = '5F256797168CBACEC42FF1339BF741394CD64369A2FF012933D2DBCD1031F75B'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
if ([System.Environment]::Is64BitOperatingSystem) {
    $programFiles = $env:ProgramFiles
}
else {
    $programFiles = ${env:ProgramFiles(x86)}
}
$installDir = "$programFiles\tencent\wechat-devtools"

$pp = Get-PackageParameters
if ($pp.InstallDir) {
    $installDir = $pp.InstallDir
}

$silentArgs = "/qn /norestart /S /D=$installDir"

New-Item -ItemType Directory -Force -Path $installDir

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = $url
    url64bit       = $url64

    softwareName   = $softwareName

    checksum       = $checksum
    checksumType   = 'sha256'
    checksum64     = $checksum64
    checksumType64 = 'sha256'

    silentArgs     = $silentArgs
    validExitCodes = @(0, 1641, 3010)
}

Install-ChocolateyPackage @packageArgs