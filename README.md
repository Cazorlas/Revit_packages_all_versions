# Revit_packages_all_versions

NuGet packaging project for bundling one or more Revit API DLL sets into one package.

## What this package does

- Ships multiple Autodesk Revit DLL folders in one NuGet package
- Lets the consuming project choose a version through `RevitVersion`
- Adds all `*.dll` files from `revit/<RevitVersion>/` as references
- Sets those references to `Copy Local = false`

## Repo layout

```text
.github/
  workflows/
build/
  Revit_packages_all_versions.targets
revit/
  2019/
  2020/
  2021/
  2022/
  2023/
  2024/
  2025/
  2026/
  2027/
RevitPackagesAllVersions/
  RevitPackagesAllVersions.csproj
RevitPackagesAllVersions.sln
```

## Consumer usage

```xml
<PropertyGroup>
  <RevitVersion>2023</RevitVersion>
</PropertyGroup>

<ItemGroup>
  <PackageReference Include="Revit_packages_all_versions" Version="$(RevitVersion).*-*" IncludeAssets="build; compile" PrivateAssets="All" />
</ItemGroup>
```

Versioning convention:

- `2023.0.1`: current package release for Revit 2023
- `2024.0.1`: next package line for Revit 2024 when that DLL set is ready
- `2025.0.1`: same pattern for Revit 2025 and later

Important:

- You can reserve the same year-based versioning pattern for other Revit years.
- Do not publish a year line until that year folder actually contains the required DLLs, especially `RevitAPI.dll`.
- At any given time, it is fine if only one year folder is populated with real DLLs.

## Current DLL inventory

- `2019`: no DLLs yet
- `2020`: no DLLs yet
- `2021`: no DLLs yet
- `2022`: `AdWindows.dll`, `DynamoCore.dll`, `DynamoRevitDS.dll`, `RevitAPI.dll`, `RevitAPIIFC.dll`, `RevitAPIUI.dll`, `UIFramework.dll`
- `2023`: `AdWindows.dll`, `DynamoCore.dll`, `DynamoRevitDS.dll`, `RevitAPI.dll`, `RevitAPIIFC.dll`, `RevitAPIUI.dll`, `UIFramework.dll`
- `2024`: `AdWindows.dll`, `DynamoCore.dll`, `DynamoRevitDS.dll`, `RevitAPI.dll`, `RevitAPIIFC.dll`, `RevitAPIUI.dll`, `UIFrameworkRes.resources.dll`
- `2025`: `AdWindows.dll`, `DynamoCore.dll`, `DynamoRevitDS.dll`, `RevitAPI.dll`, `RevitAPIIFC.dll`, `RevitAPIUI.dll`, `UIFramework.dll`
- `2026`: `AdWindows.dll`, `DynamoCore.dll`, `DynamoRevitDS.dll`, `RevitAPI.dll`, `RevitAPIIFC.dll`, `RevitAPIUI.dll`
- `2027`: no DLLs yet

## Pack locally

```powershell
dotnet pack .\RevitPackagesAllVersions\RevitPackagesAllVersions.csproj -c Release
```

Package output:

- `.\artifacts\`

## Publish workflow

The repo includes GitHub Actions workflows for:

- CI build and pack on push/PR
- publish to `nuget.org` on tag or manual dispatch

The publish workflow is prepared for NuGet trusted publishing with OIDC.

## Notes

- Check Autodesk redistribution/licensing constraints yourself before pushing to a public feed.
- This package uses a custom embedded license file, which NuGet supports for non-SPDX/custom license terms.
