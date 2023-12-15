# Run PowerShell as an administrator

# Install the Web Server (IIS) role with default features
Install-WindowsFeature -Name Web-Server

# Install common IIS features
Install-WindowsFeature -Name Web-Mgmt-Tools, Web-Mgmt-Console, Web-Scripting-Tools, Web-Stat-Compression, Web-Dyn-Compression, Web-Basic-Auth, Web-Windows-Auth, Web-Url-Auth, Web-WebSockets, Web-AppInit, Web-Net-Ext45, Web-Asp-Net45, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Health, Web-Http-Logging, Web-Custom-Logging, Web-Log-Libraries, Web-Request-Monitor, Web-Http-Tracing, Web-Security, Web-Filtering, Web-Performance, WAS-Process-Model, WAS-Config-APIs, Web-Dir-Browsing, Web-Http-Errors, Web-Static-Content, Web-Http-Redirect, Web-DAV-Publishing, Web-ASP, Web-CGI

# Install additional features based on the specific needs
# Install-WindowsFeature -Name <Additional-Feature-Name>

# Check if a restart is needed
if ((Get-WindowsFeature Web-Server).InstallState -eq "InstallPending") {
    # Optionally, prompt for restart or automate it
    # Restart-Computer -Force
    Write-Host "A restart is required to complete the installation."
}

# Output the installation status
Get-WindowsFeature Web-Server, Web-Mgmt-Tools, Web-Asp-Net45 | Format-Table -Property Name, InstallState