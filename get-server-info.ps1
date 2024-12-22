# Define server host and port
$serverHost = "http://localhost"
$serverPort = 3001

# Combine server host and port to form the base URL
$baseUrl = "${serverHost}:$serverPort"

# Endpoint to retrieve model info
$endpoint = "/info"

# Full URL
$url = "$baseUrl$endpoint"

# Perform the request
try {
    $response = Invoke-WebRequest -Uri $url -Method GET -ContentType "application/json" -UseBasicParsing
    
    # Check if the response status code is 200 (OK)
    if ($response.StatusCode -eq 200) {
        Write-Host "Request successful!" -ForegroundColor Green
        Write-Host "Response content:" -ForegroundColor Yellow
        Write-Output $response.Content | ConvertFrom-Json | Format-List
    } else {
        Write-Host "Request failed with status code: $($response.StatusCode)" -ForegroundColor Red
        Write-Output $response
    }
} catch {
    Write-Host "An error occurred during the request:" -ForegroundColor Red
    Write-Host $_.Exception.Message
}