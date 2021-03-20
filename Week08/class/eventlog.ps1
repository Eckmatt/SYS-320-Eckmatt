#Storyline: Review the Security Event Log

#List all the the available Windows Event logs
Get-EventLog -list


#Directory to save files
$myDir = "C:\Users\meckh\Documents"



#Create a prompt to select the log to view
$readLog = Read-host -Prompt "Please select a log to review from the list above"

#Create a prompt to select the message to filter by
$readMessage = Read-host -Prompt "Please enter a filter"


#Print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$readMessage*"} | export-csv -NoTypeInformation -Path "$myDir\securityLogs.csv"