# Windows 2022 - Microsft SQL 2022 Developer

#Logging Script for Packer build
Write-Host "Script Starting - $(Get-Date)"
Write-Host "Current working directory: $(Get-Location)"

$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$configFilePath = "A:\ConfigurationFile.ini"
(Get-Content $configFilePath) -replace 'YourDomain\\YourUsername', $currentUser | Set-Content $configFilePath

# Define the path to your configuration file
$configFilePath = "A:\ConfigurationFile.ini"

# Path to the setup executable on the mounted ISO
$setupPath = "D:\setup.exe"

# Installing SQL Server
Write-Host "Installing SQL Server..."
Start-Process -FilePath $setupPath -ArgumentList "/ConfigurationFile=$configFilePath" -Wait -NoNewWindow

# Define the URL for the SSMS installer
$ssmsInstallerUrl = "https://aka.ms/ssmsfullsetup"

# Define the path where the installer will be downloaded
$installerPath = "C:\Temp\SSMS-Setup-ENU.exe"

# Download the installer
Invoke-WebRequest -Uri $ssmsInstallerUrl -OutFile $installerPath

# Install SSMS
Write-Host "Installing SQL Server Management Studio..."
Start-Process -FilePath $installerPath -ArgumentList "/quiet /norestart" -Wait -NoNewWindow

Write-Host "Script Completed - $(Get-Date)"