#Function to get token with Google Drive & set the headers for your download
###########################################################################

$refreshToken = ""
$ClientID = ""
$grantType = "refresh_token" 
$requestUri = "https://accounts.google.com/o/oauth2/token" 
$GAuthBody = "refresh_token=$refreshToken&client_id=$ClientID&client_secret=$GoogleClientSecret&grant_type=$grantType" 
$GAuthResponse = Invoke-RestMethod -Method Post -Uri $requestUri -ContentType "application/x-www-form-urlencoded" -Body $GAuthBody 
$accessToken = $GAuthResponse.access_token
$headers = @{"Authorization" = "Bearer $accessToken"          
 
              "Content-type" = "application/json"}
$URI = "https://www.googleapis.com/drive/v3/files/" + $1vSOBZ11nMLk9rB7bSyA5_DK9aG-dJ8ZQ + "?alt=media"
#echo "send google authentication token for drive download" 

#Function to download a file from Google Drive.
###########################################################################
##### The URI is formatted as follows: "https://www.googleapis.com/drive/v3/files/<FILEID>?alt=media"
##### To get the file ID from a shared file in Google Drive, right-click the file and click "get sharable link".  
##### In this case the link is: https://drive.google.com/open?id=1xPJOoZwFX6k1_fRBOoFbhliA-SHfGoLn
##### The file ID is called out at the end of the link: "id=1xPJOoZwFX6k1_fRBOoFbhliA-SHfGoLn"

$FileDownload1 = Invoke-RestMethod -Uri $URI -Method Get -Headers $headers -OutFile $FullFilePath | out-null

#echo "google drive download complete" 
