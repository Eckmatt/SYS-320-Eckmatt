
#Task : Grab the network adapter information using WMI classes
#get IP address, default gateway, DNS server, and DHCP server.
#Export running processes and services to seperate files


# USe the Get-WMI cmdlet
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | where {$_.IPenabled -eq "TRUE"} | select Index, IPAddress, DNSDomain, DefaultIPGateway, DnsServerSearchOrder, DHCPServer

#Use Get-Process and Get-Service and export their output to csv files
Get-process |Select-Object ProcessName, Path, ID | `
Export-Csv -Path "C:\users\meckh\SYS-320-Eckmatt\Week09\homework\Processes.csv"

Get-Service |Where {$_.Status -eq "Running" } | `
Export-Csv -Path "C:\users\meckh\SYS-320-Eckmatt\Week09\homework\running_services.csv"


#Starts the windows calculator
Start-Process calc.exe

#suspends the script for 4 seconds while calculator app starts
Start-Sleep -s 4

#Stop Calculator Process
Get-Process | where {$_.ProcessName -ilike "Calculator"} |Stop-Process