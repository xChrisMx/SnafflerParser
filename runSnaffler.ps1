#############################################################################
# Snaffler Autogeneration Script - Scheduled Task Optimized
# Author: Chris M. (Updated by Copilot)
# Version: 0.5
#
# Added Start-Transcript to add timestamped log entries & explicit success/fail 
# messages to log. This captures all console output and writes to errorLog file 
# which is C:\Tools\Snaffler-master\errorlog.txt
#############################################################################

# Utility function for timestamped logging
function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

# Set base paths
$basePath       = "C:\Tools\Snaffler-master"
$parserPath     = "C:\Tools\Snaffler-master\SnafflerParser-main\snafflerParser.ps1"
$errorLog       = Join-Path $basePath "errorlog.txt"

# Start transcript for logging
Start-Transcript -Path $errorLog -Append
Write-Log "Script started."

# Get today's date
$today          = Get-Date -Format "MM_yyyy"
$reportName     = "SnafflerReport_$today.txt"
$reportPath     = Join-Path $basePath $reportName

Write-Log "Using report date: $today"

# Confirm Snaffler executable exists
$snafflerExe = Join-Path $basePath "Snaffler.exe"
if (-not (Test-Path $snafflerExe)) {
    Write-Log "Snaffler.exe not found in $basePath" "ERROR"
    Stop-Transcript
    exit 1
}

# Run Snaffler
Write-Log "Running Snaffler directly..."
Start-Process -NoNewWindow -FilePath $snafflerExe -ArgumentList "-x 10 -o `"$reportPath`" -s -y" -Wait

Start-Sleep -Seconds 10

# Confirm report was created
if (-not (Test-Path $reportPath)) {
    Write-Log "Report file not created: $reportPath" "ERROR"
    Stop-Transcript
    exit 1
}
Write-Log "Snaffler report created successfully."

Start-Sleep -Seconds 10

# Confirm parser script exists
if (-not (Test-Path $parserPath)) {
    Write-Log "Parser script not found at $parserPath" "ERROR"
    Stop-Transcript
    exit 1
}

# Run parser
Write-Log "Running parser script..."
& $parserPath -in $reportPath -split

Start-Sleep -Seconds 10

# End logging
Write-Log "Script completed successfully."
Stop-Transcript