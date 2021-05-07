cls

# Convert Json File into Powershell Object
$default_json = (Get-Content -Raw -Path "C:\Users\meckh\SYS-320-Eckmatt\Week15\homework\defaults.json" | `
ConvertFrom-Json) | select Feed


# CSV File
$filename = "C:\Users\meckh\SYS-320-Eckmatt\Week15\homework\threatIntell.csv"

# Headers for the CSV File
set-content -Value "`"name`",`"provider`",`"url`",`"source_format`"" $filename

# Array to store the data
$theV = @()

foreach ($vuln in $default_json.Feed) {

    # Get the Name
    $name = $vuln.name

    # Get the Provider
    $provider = $vuln.provider

    # Get the URL
    $url = $vuln.url

    # Get Source_Format
    $source_format = $vuln.source_format


    ##### I LEFT THIS LITTLE BIT IN BECAUSE I DECIDED THAT I WOULD MAKE THIS SCRIPT INTO A LITTLE TEMPLATE FOR PARSING JSON FILES. ITS PART OF THE TEMPLATE.

    #$keyword = 
    # Search for the keyword
    #if ($descript -imatch "$keyword"){
    #}
    #####

    #Format the CSV File
    $theV += "`"$name`",`"$provider`",`"$url`",`"$source_format`"`n"

}

# Covert the array to a string and append to the csv file
"$theV" | Add-Content -Path $filename