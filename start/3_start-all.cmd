@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..") do set "ROOT=%%~fI"
set "PORT=8080"

net session >nul 2>&1
if not "%errorlevel%"=="0" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "& { $ErrorActionPreference = 'Stop'; $root = '%ROOT%'; $source = Join-Path $root 'Source'; $iisExpress = Join-Path $root 'tools\IISExpress\IIS Express\iisexpress.exe'; $port = %PORT%; $serviceName = 'MSSQL$SQLEXPRESS'; $dbName = 'BanSachPremium'; $masterConn = 'Data Source=.\SQLEXPRESS;Initial Catalog=master;Integrated Security=True;TrustServerCertificate=True'; $webUrl = 'http://localhost:' + $port + '/Default.aspx'; $adminUrl = 'http://localhost:' + $port + '/Admin/Login.aspx'; function Step([string]$message) { Write-Host ('[BanSach] ' + $message) }; if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { throw 'winget is not available on this machine.' }; $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue; if (-not $service) { Step 'Installing SQL Server Express...'; & winget install --id Microsoft.SQLServer.2022.Express -e --source winget --silent --accept-package-agreements --accept-source-agreements --disable-interactivity; Start-Sleep -Seconds 20; $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue }; if (-not $service) { throw 'SQL Server Express was not installed successfully.' }; if ($service.Status -ne 'Running') { Step 'Starting SQL Server service...'; Start-Service -Name $serviceName; $service.WaitForStatus('Running', '00:05:00') }; Step 'Ensuring database exists...'; $conn = New-Object System.Data.SqlClient.SqlConnection $masterConn; $conn.Open(); $cmd = $conn.CreateCommand(); $cmd.CommandText = ('IF DB_ID(N''{0}'') IS NULL CREATE DATABASE [{0}];' -f $dbName); [void]$cmd.ExecuteNonQuery(); $conn.Close(); Step ('Checking port ' + $port + '...'); Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue | ForEach-Object { Step ('Killing process ' + $_.OwningProcess + ' on port ' + $port + '...'); Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }; if (-not (Test-Path $iisExpress)) { throw ('IIS Express not found at ' + $iisExpress) }; Step 'Starting IIS Express...'; $args = '/path:' + [char]34 + $source + [char]34 + ' /port:' + $port + ' /clr:v4.0'; Start-Process -FilePath $iisExpress -ArgumentList $args -WorkingDirectory $root; Start-Sleep -Seconds 5; Start-Process $webUrl; Step ('Storefront: ' + $webUrl); Step ('Admin:      ' + $adminUrl); Step 'System is running.' }"

pause
