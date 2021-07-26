$ErrorActionPreference = 'Stop';

$softwareName = 'wechat-devtools*'
[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -gt 0) {
    Invoke-Expression -Command $PSScriptRoot\chocolateyUninstall.ps1
}

$url = 'https://servicewechat.com/wxa-dev-logic/download_redirect?type=ia32&from=mpwiki&download_version=1052107090&version_type=1'
$checksum = '08062137302BE361B4819BEF0D53BA5D24ED7BF38E822090B9A442875C13F6CB'

$url64 = 'https://servicewechat.com/wxa-dev-logic/download_redirect?type=x64&from=mpwiki&download_version=1052107090&version_type=1'
$checksum64 = 'DA2E5BDFFA6CB858BBEAD21B1079512B1C15857B1EE79F0F8503C64EB0610CE7'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
if ([System.Environment]::Is64BitOperatingSystem) {
    $programFiles = $env:ProgramFiles
}
else {
    $programFiles = ${env:ProgramFiles(x86)}
}
$installDir = "$programFiles\win-rdm"

$pp = Get-PackageParameters
if ($pp.InstallDir) {
    $installDir = $pp.InstallDir
}

$silentArgs = "/S /D=$installDir"

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