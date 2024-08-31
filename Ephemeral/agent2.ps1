param (
    [string]$hostname,
    [string]$command
)

function Get-IniContent {
    param (
        [string]$Path
    )
    $ini = @{}
    $section = ""
    foreach ($line in Get-Content -Path $Path) {
        $line = $line.Trim()
        if ($line -match '^\[(.+)\]$') {
            $section = $matches[1]
            $ini[$section] = @{}
        }
        elseif ($line -match '^(.*?)=(.*)$') {
            $name, $value = $matches[1..2]
            $ini[$section][$name.Trim()] = $value.Trim()
        }
    }
    return $ini
}

$currentHostname = $env:COMPUTERNAME

if ($hostname -ne $currentHostname) {
    exit
}

$config = Get-IniContent -Path "config/config.ini"
$webhookUrl = $config['AgentCommands']['AgentCommandWebhook']

function Invoke-CommandWithTimeout {
    param (
        [string]$Command,
        [int]$Timeout = 30
    )

    $job = Start-Job -ScriptBlock { 
        param($cmd)
        Invoke-Expression -Command $cmd
    } -ArgumentList $Command

    $completed = Wait-Job $job -Timeout $Timeout
    if ($completed) {
        $output = Receive-Job $job
        Remove-Job $job
    } else {
        Stop-Job $job
        $output = "Command timed out after $Timeout seconds."
        Remove-Job $job -Force
    }

    return $output
}

$output = Invoke-CommandWithTimeout -Command $command -Timeout 30


$outputString = $output -join "`n"

$outputFile = "output.txt"
$outputString | Out-File -FilePath $outputFile -Encoding UTF8

$outputFromFile = Get-Content -Path $outputFile -Raw

$formattedOutput = "``````$outputFromFile``````"

$chunkSize = 1990
$chunks = @()
$firstChunk = $true
for ($i = 0; $i -lt $formattedOutput.Length; $i += $chunkSize) {
    $chunk = $formattedOutput.Substring($i, [math]::Min($chunkSize, $formattedOutput.Length - $i))

    if (-not $firstChunk) {
        $chunk = "``````" + $chunk
    }
    $firstChunk = $false

    if ($i + $chunkSize -lt $formattedOutput.Length) {
        $chunk += "`n``````"
    }
    
    $chunks += $chunk
}

foreach ($chunk in $chunks) {
    $body = @{
        content = $chunk
    } | ConvertTo-Json

    Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $body -ContentType "application/json"
}
