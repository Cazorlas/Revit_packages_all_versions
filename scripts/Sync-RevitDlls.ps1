param(
    [Parameter(Mandatory = $true)]
    [string]$Version,

    [string]$SourceDir,

    [string]$PackageRoot,

    [switch]$Clean
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($PackageRoot)) {
    $PackageRoot = Split-Path -Parent $PSScriptRoot
}

if ([string]::IsNullOrWhiteSpace($SourceDir)) {
    $SourceDir = "C:\Program Files\Autodesk\Revit $Version"
}

$targetDir = Join-Path $PackageRoot "revit\$Version"

if (-not (Test-Path -LiteralPath $SourceDir)) {
    throw "SourceDir does not exist: $SourceDir"
}

if ($Clean -and (Test-Path -LiteralPath $targetDir)) {
    Remove-Item -LiteralPath $targetDir -Recurse -Force
}

New-Item -ItemType Directory -Path $targetDir -Force | Out-Null

$files = @(
    @{ RelativePath = "AdWindows.dll"; TargetName = "AdWindows.dll" },
    @{ RelativePath = "UIFramework.dll"; TargetName = "UIFramework.dll" },
    @{ RelativePath = "RevitAPI.dll"; TargetName = "RevitAPI.dll" },
    @{ RelativePath = "RevitAPI.xml"; TargetName = "RevitAPI.xml" },
    @{ RelativePath = "RevitAPIUI.dll"; TargetName = "RevitAPIUI.dll" },
    @{ RelativePath = "RevitAPIUI.xml"; TargetName = "RevitAPIUI.xml" },
    @{ RelativePath = "RevitAPIIFC.dll"; TargetName = "RevitAPIIFC.dll" },
    @{ RelativePath = "RevitAPIIFC.xml"; TargetName = "RevitAPIIFC.xml" },
    @{ RelativePath = "RevitAddInUtility.dll"; TargetName = "RevitAddInUtility.dll" },
    @{ RelativePath = "RevitAddInUtility.xml"; TargetName = "RevitAddInUtility.xml" },
    @{ RelativePath = "AddIns\DynamoForRevit\DynamoCore.dll"; TargetName = "DynamoCore.dll" },
    @{ RelativePath = "AddIns\DynamoForRevit\Revit\DynamoRevitDS.dll"; TargetName = "DynamoRevitDS.dll" },
    @{ RelativePath = "AddIns\GltfExporter\PackageContentsParser.dll"; TargetName = "PackageContentsParser.dll" }
)

foreach ($file in $files) {
    $sourceFile = Join-Path $SourceDir $file.RelativePath
    if (-not (Test-Path -LiteralPath $sourceFile)) {
        Write-Warning "Missing file: $sourceFile"
        continue
    }

    $targetFile = Join-Path $targetDir $file.TargetName
    Copy-Item -LiteralPath $sourceFile -Destination $targetFile -Force
    Write-Host "Copied $($file.TargetName) -> $targetDir"
}

Write-Host ""
Write-Host "Done."
Write-Host "Version: $Version"
Write-Host "Source : $SourceDir"
Write-Host "Target : $targetDir"
