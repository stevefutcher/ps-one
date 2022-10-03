## This script installs Chocolatey & Common.NET Dev Tools including:
# .NET Frameworks at all current / LTS versions
# SQL Server
# Git
# Visual Studio
# Many other common & useful tools

$policy = Get-ExecutionPolicy -Scope CurrentUser
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser 

# Self-elevate the script if required (https://blog.expta.com/2017/03/how-to-self-elevate-powershell-script.html)
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}


#Install Chocolatey
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))


#Frameworks
choco install dotnetfx -y # .NET 4.8
choco install dotnetcore-sdk -y # .NET Core 3.1
choco install dotnet-sdk -y # .NET 6.0

#SQL Server
choco install sql-server-2019 -y --params "'/SECURITYMODE=SQL /SAPWD=n0b0dyMUSTknow! /ROLE=AllFeatures_WithDefaults'" #Change pasword, write it down
choco install sql-server-management-studio -y


#Common Tools
choco install git -y --params "/GitAndUnixToolsOnPath /DefaultBranchName:main"
choco install notepadplusplus -y
New-Item C:\NuGet -ItemType Directory -ErrorAction SilentlyContinue
Invoke-WebRequest -Uri https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile C:\NuGet\nuget.exe
iex "& { $(irm https://aka.ms/install-artifacts-credprovider.ps1) } -AddNetfx" # Azure Artifacts credential provider



#Visual Studio 2022 Enterprise - Customise Components as required
New-Item C:\VS-Config -ItemType "directory" -ErrorAction SilentlyContinue
Write-Output '{"version":"1.0","components":["Microsoft.VisualStudio.Component.NuGet","Microsoft.VisualStudio.Component.Roslyn.Compiler","Microsoft.Component.MSBuild","Microsoft.NetCore.Component.Runtime.6.0","Microsoft.NetCore.Component.SDK","Microsoft.Net.Component.4.7.2.TargetingPack","Microsoft.VisualStudio.Component.Roslyn.LanguageServices","Microsoft.VisualStudio.Component.FSharp","Microsoft.ComponentGroup.ClickOnce.Publish","Microsoft.NetCore.Component.DevelopmentTools","Microsoft.VisualStudio.Component.MSODBC.SQL","Microsoft.VisualStudio.Component.MSSQL.CMDLnUtils","Microsoft.VisualStudio.Component.SQL.LocalDB.Runtime","Microsoft.VisualStudio.Component.SQL.CLR","Microsoft.VisualStudio.Component.CoreEditor","Microsoft.VisualStudio.Workload.CoreEditor","Microsoft.Net.Component.4.8.SDK","Microsoft.Net.ComponentGroup.DevelopmentPrerequisites","Microsoft.VisualStudio.Component.TypeScript.TSServer","Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions","Microsoft.VisualStudio.Component.JavaScript.TypeScript","Microsoft.VisualStudio.Component.JavaScript.Diagnostics","Microsoft.VisualStudio.Component.TextTemplating","Component.Microsoft.VisualStudio.RazorExtension","Microsoft.VisualStudio.Component.IISExpress","Microsoft.VisualStudio.Component.Common.Azure.Tools","Microsoft.Component.ClickOnce","Microsoft.VisualStudio.Component.ManagedDesktop.Core","Microsoft.VisualStudio.Component.SQL.SSDT","Microsoft.VisualStudio.Component.SQL.DataSources","Component.Microsoft.Web.LibraryManager","Component.Microsoft.WebTools.BrowserLink.WebLivePreview","Microsoft.VisualStudio.ComponentGroup.Web","Microsoft.VisualStudio.Component.FSharp.WebTemplates","Microsoft.VisualStudio.Component.DockerTools","Microsoft.NetCore.Component.Web","Microsoft.VisualStudio.Component.WebDeploy","Microsoft.VisualStudio.Component.AppInsights.Tools","Microsoft.VisualStudio.Component.Web","Microsoft.Net.Component.4.8.TargetingPack","Microsoft.Net.ComponentGroup.4.8.DeveloperTools","Microsoft.VisualStudio.Component.AspNet45","Microsoft.VisualStudio.Component.AspNet","Component.Microsoft.VisualStudio.Web.AzureFunctions","Microsoft.VisualStudio.ComponentGroup.AzureFunctions","Microsoft.VisualStudio.Component.Debugger.Snapshot","Microsoft.VisualStudio.ComponentGroup.Web.CloudTools","Microsoft.VisualStudio.Component.IntelliTrace.FrontEnd","Microsoft.VisualStudio.Component.DiagnosticTools","Microsoft.VisualStudio.Component.EntityFramework","Microsoft.VisualStudio.Component.LiveUnitTesting","Microsoft.VisualStudio.Component.Debugger.JustInTime","Component.Microsoft.VisualStudio.LiveShare.2022","Microsoft.VisualStudio.Component.WslDebugging","Microsoft.VisualStudio.Component.IntelliCode","Microsoft.VisualStudio.Component.Wcf.Tooling","Microsoft.VisualStudio.Component.ClassDesigner","Microsoft.VisualStudio.Component.GraphDocument","Microsoft.VisualStudio.Component.CodeMap","Microsoft.VisualStudio.Workload.NetWeb","Microsoft.VisualStudio.Component.VC.CoreIde","Microsoft.VisualStudio.Component.VC.Tools.x86.x64","Microsoft.VisualStudio.Component.Graphics.Tools","Microsoft.VisualStudio.Component.VC.DiagnosticTools","Microsoft.VisualStudio.Component.Windows10SDK.19041","Microsoft.VisualStudio.Component.ManagedDesktop.Prerequisites","Microsoft.ComponentGroup.Blend","Microsoft.VisualStudio.Component.DotNetModelBuilder","Microsoft.VisualStudio.Component.FSharp.Desktop","Microsoft.VisualStudio.Workload.ManagedDesktop","Microsoft.VisualStudio.Component.VC.Redist.14.Latest","Microsoft.VisualStudio.ComponentGroup.ArchitectureTools.Native","Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Core","Microsoft.VisualStudio.ComponentGroup.WebToolsExtensions.CMake","Microsoft.VisualStudio.Component.VC.CMake.Project","Microsoft.VisualStudio.Component.VC.ATL","Microsoft.VisualStudio.Component.VC.TestAdapterForBoostTest","Microsoft.VisualStudio.Component.VC.TestAdapterForGoogleTest","Microsoft.VisualStudio.Component.VC.ASAN","Microsoft.VisualStudio.Component.VC.v141.x86.x64","Microsoft.VisualStudio.Workload.NativeDesktop","Microsoft.Net.ComponentGroup.TargetingPacks.Common","Microsoft.NetCore.Component.Runtime.3.1"]}' > C:\VS-Config\Enterprise2022.vsconfig
choco install visualstudio2022enterprise -y --package-parameters "--config C:\VS-Config\Enterprise2022.vsconfig --passive"
# alternatives = visualstudio2022professional & visualstudio2022community

#Azure Development
choco install azure-cli -y
choco install microsoftazurestorageexplorer -y


#JetBrains Tools - Licences available on request
choco install resharper-ultimate-all -y --params "/NoCpp /NoTeamCityAddin" # Don't install for C++ or TeamCity - remove /NoCpp if desired
choco install jetbrains-rider -y


#Other Software
choco install vscode -y #Yaml / Nant & more
choco install openssl -y #Certificate Creation
choco install bloomrpc -y #gRPC client
choco install postman -y #ReST Client
choco install googlechrome -y --ignore-checksums #In case not already installed
choco install firefox -y #Alternative browser that isn't IE :)
choco install keepass -y #Password manager
choco install 7zip -y #Archive tool
choco install docker-desktop -y #Containers
choco install gimp -y #Image Manipulation
choco install winscp -y #FTP Client


#Show file extensions and hidden folders
$RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
Set-ItemProperty "$RegPath" -Name "HideFileExt" -Value 0 -Type Dword
Set-ItemProperty "$RegPath" -Name "Hidden" -Value 1 -Type Dword 

Set-ExecutionPolicy -ExecutionPolicy $policy -Scope CurrentUser 

# SQL Server & several others require a restart
Restart-Computer
