# Storyline: View the services, and either all of them, the running ones, or the stopped ones.
# Liberally copied from the get event log script in the classwork

function ServiceClient() { 
    # List all services
    Get-Service | select Name | Out-Host

    #Prompt user to view services or quit or quit
    $servicePrompt = read-host -Prompt "What services do you want to view, All, Running or Stopped? or q to quit the program"

    # Store possible values
    $validResponse =@('All', 'Stopped', 'Running')

        
    #check if the user wants to quit.
    if ($servicePrompt -match "^[qQ]$") {
        #stop the program
        break

    }


    if ($validResponse -match $servicePrompt) {
        
        if ($servicePrompt -eq 'All') {

            Get-Service | select Name, Status | Out-Host


        } else {

            Get-Service | where {$_.Status -eq $servicePrompt} | select Name, Status | Out-Host
        }


    } else {
        ServiceClient

    }



  



}


ServiceClient
