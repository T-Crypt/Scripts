######################################################################################################################################################################################
# Installs N-central Agent on Windows ( *.exe )
#
# Usage:
#    
#    - Get link from Google Drive for the specific N-Central Agent 
#    - Copy the Google File ID and paste the ID in the file URL on line 71 between ()
#            -  It is the combination of letters and numbers that appear after "d/" in the link: https://docs.google.com/spreadsheets/d/***ThisIsFileID***/edit#gid=123456789
#  
#    - Check C:\Temp for N-Central Install.txt and log_error.txt for any errors   
#
#  
######################################################################################################################################################################################

# Set Definitions
$ApplicationName = ""
$ServiceName = "Agent64"
$FilePath = "C:\temp"
$FileName = "Agent64.exe"
$FullFilePath = $FilePath + "\" + $FileName
$MSIArguments = @(
     "/quiet"
     "/passive"
)

# Google Drive Download Authorization // Add Refresh Token // Add Client ID // Add Client Secret 
$refreshToken = ""
$ClientID = ""
$ClientSecret = ""
$grantType = "refresh_token"
$requestUri = "https://accounts.google.com/o/oauth2/token"
$GAuthBody = "refresh_token=$refreshToken&client_id=$ClientID&client_secret=$ClientSecret&grant_type=$grantType"
$GAuthResponse = Invoke-RestMethod -Method Post -Uri $requestUri -ContentType "application/x-www-form-urlencoded" -Body $GAuthBody
$accessToken = $GAuthResponse.access_token
$headers = @{"Authorization" = "Bearer $accessToken"          
 
              "Content-type" = "application/json"}

# Test for Temp in C Drive
try {
    $path = "C:\Temp"
    if (Test-Path $path) {
        Write-Host "The 'Temp' folder already exists in the C: drive."
    } else {
        New-Item -ItemType Directory -Path $path
        Write-Host "The 'Temp' folder has been created in the C: drive."
    }
} catch {
    Write-Host "An error occurred: $_. Please check the script and try again."
}

# Test for Windows Agent / N-Central
try {
    # Check if N-Central Agent is installed on Windows
    $app = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Windows Agent*"}
    
    # If N-Central Agent is installed, write message to file and stop the script
    if ($app) {
        Write-Output "N-Central is already installed on this system. The script will now stop."
        $message = "N-Central is already installed on this system."
        $path = "C:\Temp\ncentral_installed.txt"
        New-Item -ItemType File -Path $path -Force
        Set-Content -Path $path -Value $message
        Exit
    } else {
        Write-Output "N-Central is not installed on this system. The script will continue."
    }
} catch {
    Write-Output "An error occurred: $($_.Exception.Message). Please check the script and try again."
}

# Download Google Drive File and place the output file in Temp (Modify the Google File ID for the customer specific N-Central Agent)
$File = Invoke-RestMethod -Uri "https://www.googleapis.com/drive/v3/files/()?alt=media" -Method Get -Headers $headers -OutFile "C:\Temp\Agent64.exe"

# Start the install using the command Arguments 
Start-Process $FullFilePath -ArgumentList $MSIArguments -Wait -NoNewWindow 

# Function to indentify and document errors throughout the script
function Log-ScriptError {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$LogFileName = "C:\Temp\error_log.txt"
    )

    # Store all current errors in the $error variable
    $allErrors = $Error

    # Clear the error variable to prevent duplicates
    $Error.Clear()

    # Iterate over all errors and log them to the specified file
    foreach ($error in $allErrors) {
        $errorString = "$($error.Exception.GetType().FullName): $($error.Exception.Message)`r`nStackTrace:`r`n$($error.Exception.StackTrace)`r`n"
        Write-Output $errorString | Out-File -FilePath $LogFileName -Append
    }
}

# Clean up installer file
function Remove-Agent64 {
    $agentPath = "C:\Temp\Agent64.exe"
    if (Test-Path $agentPath) {
        Remove-Item $agentPath -Force
        Write-Output "Agent64.exe removed successfully."
    } else {
        Write-Output "Agent64.exe not found."
    }
}

# Call the Clean up Function
Remove-Agent64 
