#Storyline: create a script that retrieves:


#Filepath to save our output files
$myDir = read-host -Prompt "Please enter the full filepath of where you would like to save logs"

New-Item -Path "$myDir" -Name "results" -ItemType "directory" -Force
New-Item -Path "$myDir\results" -Name "hashes" -ItemType "directory" -Force


#1. Running Processes and the path for each process
Write-Output "Getting processes..."
$allProcesses = Get-Process | select Name, Path | Export-Csv -NoTypeInformation -Path "$myDir\results\processes.csv"



#2. All registered services and the path to the executable
Write-Output "Getting services..."
$allServices =  Get-WmiObject win32_service | select Name, PathName, State | Export-Csv -NoTypeInformation -Path "$myDir\results\services.csv"


#3. All TCP network sockets
Write-Output "Getting TCP Network Sockets..."
$allTCPSockets = Get-NetTCPConnection | select LocalPort | Export-Csv -NoTypeInformation -Path "$myDir\results\tcpConnections.csv"


#4. All user account information (you'll need to use WMI)
Write-Output "Getting User Account Info..."
$allUserInfo = Get-WmiObject -Class Win32_UserAccount | select Name, SID, AccountType | Export-Csv -NoTypeInformation -Path "$myDir\results\userInfo.csv"



#5. All NetworkAdapterConfiguration information.
Write-Output "Getting Network Adapter Configuration..."
$allNetworkConfig = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Export-Csv -NoTypeInformation -Path "$myDir\results\networkConf.csv"


#6. Powershell cmdlets to save other artifacts that would be useful

#Prompt user whether or not they want to comb appdata and downloads (this could take a while)
$GetRecent = read-host -Prompt "Do you want to comb APPDATA and Downloads? [Y/n]"

#If the user does want to look through $APPDATA and Downloads.

if ($GetRecent -match "^[yY]$") {
    #Grabs most recent changes to the $APPDATA directory
    Write-Output "Getting recent APPDATA changes..."
    Get-ChildItem -Path $Env:APPDATA -Force -Recurse | sort LastWriteTime | select -Last 20 | Export-Csv -NoTypeInformation -Path "$myDir\results\appdataRecent.csv"

    #Most recent changes in the Downloads folder
    Write-Output "Getting recent Downloads changes..."
    Get-ChildItem -Path C:\Users\$Env:UserName\Downloads -Force -Recurse | sort LastWriteTime | select -Last 20 | Export-Csv -NoTypeInformation -Path "$myDir\results\downloadsRecent.csv"

}


#Returns the execution policy
Write-Output "Getting current Execution Policy..."
Get-ExecutionPolicy | Out-File -FilePath "$myDir\results\executionPolicy.txt"

#Returns all user accounts in the Admin group
Write-Output "Getting all members of the Administrator group..."
Get-LocalGroupMember Administrators | Export-Csv -NoTypeInformation -Path "$myDir\results\adminMembers.csv"


#Get Hash Values for all of the csv files created
Write-Output "Getting hashes, be patient, this may take a while."
ls $myDir\results | Get-FileHash | Export-Csv -NoTypeInformation -Path "$myDir\results\hashes\hashes.csv"

#Compress all results into a zip file
Write-Output "Compressing Archive, be patient, this may (also) take a while."
Compress-Archive -Force -Path $myDir\results -DestinationPath C:\Users\$Env:UserName\results.zip

#Get hash for the zip file
Write-Output "Getting zip hash, this will take a second"
Get-FileHash C:\Users\$Env:UserName\results.zip | Out-File -FilePath "C:\Users\$Env:UserName\zipHash.txt" -Force


Write-Output "Incident Response Completed! Find results at C:\Users\$Env:UserName"