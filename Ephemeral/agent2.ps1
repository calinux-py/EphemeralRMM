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
    # If it doesn't match, exit the script
    exit
}

$config = Get-IniContent -Path "config/config.ini"
$webhookUrl = $config['AgentCommands']['AgentCommandWebhook']

function Invoke-CommandWithTimeout {
    param (
        [string]$Command,
        [int]$Timeout = 25
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

$output = Invoke-CommandWithTimeout -Command $command -Timeout 25

$outputString = $output -join "`n"

$formattedOutput = "``````$outputString``````"

$body = @{
    content = $formattedOutput
} | ConvertTo-Json

Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $body -ContentType "application/json"