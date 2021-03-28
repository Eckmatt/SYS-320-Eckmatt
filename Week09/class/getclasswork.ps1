# Storyline: Using the Get-process and Get-service
#Get-process |Select-Object ProcessName, Path, ID | `
#Export-Csv -Path "C:\users\meckh\Documents\myProcesses.csv"
#Get-Service |Where {$_.Status -eq "Running" }
ps | Where {$_.ProcessName -eq "Slack" } | select ProcessName, ID, Path