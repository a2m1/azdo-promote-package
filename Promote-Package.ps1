param
(
    [Parameter(Mandatory)]
    [string]
    $feedName,

    [Parameter(Mandatory)]
    [string]
    $packageName,

    [Parameter(Mandatory)]
    [string]
    $packageVersion,

    [Parameter(Mandatory)]
    [string]
    $targetView,

    [Parameter()]
    [ValidateSet("npm" ,"nuget", "python", "universal")]
    [string]
    $feedType = "python"
)

#global variables
$account = ($env:SYSTEM_TEAMFOUNDATIONSERVERURI -replace "https://dev\.azure\.com/(.*)/", '$1').split('.')[0]
$project = $env:SYSTEM_TEAMPROJECT
$basepackageurl = "https://pkgs.dev.azure.com/${account}/_apis/packaging/feeds"


function New-AuthenticationToken
{
    [CmdletBinding()]
    [OutputType([object])]
         
    $accesstoken = "";
    if([string]::IsNullOrEmpty($env:AZDO_PAT))
    {
        throw "No token Personal Access Token provided"
    }
    $userpass = ":$($env:AZDO_PAT)"
    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($userpass))
    $accesstoken = "Basic $encodedCreds"

    return $accesstoken;
}


$token = New-AuthenticationToken

#API URL is slightly different for packages
switch($feedType)
{
    "npm" {
        $releaseViewURL = "${basepackageurl}/${feedName}/npm/packages/${packageName}/versions/${packageVersion}?api-version=5.1-preview.1"
    }
    "nuget" {
        $releaseViewURL = "${basepackageurl}/${feedName}/nuget/packages/${packageName}/versions/${packageVersion}?api-version=5.1-preview.1"
    }
    "python"
    { 
        $basepackageurl = "https://pkgs.dev.azure.com/${account}/${project}/_apis/packaging/feeds"
        $releaseViewURL = "${basepackageurl}/${feedName}/pypi/packages/${packageName}/versions/${packageVersion}?api-version=5.1-preview.1"
    }
    "universal" {
        $releaseViewURL = "${basepackageurl}/${feedName}/upack/packages/${packageName}/versions/${packageVersion}?api-version=5.1-preview.1"
    }
    default
    {
        $basepackageurl = "https://pkgs.dev.azure.com/${account}/${project}/_apis/packaging/feeds"
        $releaseViewURL = "${basepackageurl}/${feedName}/pypi/packages/${packageName}/versions/${packageVersion}?api-version=5.1-preview.1"
    }
}

$json = @{
    views = @{
        op = "add"
        path = "/views/-"
        value = "$targetView"
    }
}

Write-Debug "releaseViewURL=$releaseViewURL"
Write-Debug "json=$(ConvertTo-Json $json)"

$response = Invoke-RestMethod -Uri $releaseViewURL -Headers @{Authorization = $token} -ContentType "application/json" -Method Patch -Body (ConvertTo-Json $json)
return $response
