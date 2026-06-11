# RevitPackagesAllVersions

NuGet packaging project for bundling multiple Revit API DLL sets into one package.

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
  RevitPackagesAllVersions.targets
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
scripts/
  Sync-RevitDlls.ps1
RevitPackagesAllVersions/
  RevitPackagesAllVersions.csproj
RevitPackagesAllVersions.sln
```

## Consumer usage

```xml
<PropertyGroup>
  <RevitVersion>2024</RevitVersion>
</PropertyGroup>

<ItemGroup>
  <PackageReference Include="RevitPackagesAllVersions" Version="0.1.0" />
</ItemGroup>
```

## Sync DLLs from a local Revit install

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\Sync-RevitDlls.ps1 -Version 2024 -Clean
```

Defaults:

- source: `C:\Program Files\Autodesk\Revit <Version>`
- target: `.\revit\<Version>\`

The script includes the common top-level Revit DLLs and a few optional extras. You can extend its file map if your package needs more assemblies.

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

- Update `PackageId`, `Authors`, and `Description` before first public publish.
- Check Autodesk redistribution/licensing constraints yourself before pushing to a public feed.
