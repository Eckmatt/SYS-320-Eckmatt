# Storyline: View the event logs, check for a valid log, and print the results


function select_log() {

    # List all event logs
    $theLogs = Get-Eventlog -list | select Log
    $theLogs | Out-Host

    # Initialize the array to store logs
    $arrLog = @()

    foreach ($tempLog in $theLogs) {
        
        # Add each log to array
        # NOTE: These are stored in the array as a hashtable in the formate:
        # @{Log=LOGNAME}
        $arrLog += $tempLog 


    }
    #TEST array
    #$arrLog[0]

    #Prompt user to view a log or quit
    $readLog = read-host -Prompt "Please enter a log from the list above or q to quit the program"

    #check if the user wants to quit.
    if ($readLog -match "^[qQ]$") {
        #stop the program
        break

    }

    log_check -logToSearch $readLog


} #ends the select_log()





function log_check() {


    # String the user types in within the select_log function
    Param([string]$logToSearch)

    # Format the user input
    # Example: @{Log=Security}
    $theLog = "^@{Log=" + $logToSearch + "}$"

    # Search the array for the exact hashtable string
    if ($arrLog -match $theLog){
    
    write-host -BackgroundColor Green -ForegroundColor White "Please wait, it may take a few moments..."
    sleep 2

    # Call view_log to see the log
    view_log -logToSearch $logToSearch

    } else {

        write-host -BackgroundColor Red -ForegroundColor White "The log specified doesn't exist."
        sleep 2

        select_log

    }



} #ends of log_check()





function view_log() {
    cls


    # Get the logs
    Get-EventLog -Log $logToSearch -Newest 10 -After "1/18/2020"

    #Go back to select log
    select_log


} # ends view_log()


# Run select_log
select_log