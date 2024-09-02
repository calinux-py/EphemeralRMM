$previousProcesses = @()
$startTime = Get-Date
$hostname = hostname
$curuser = whoami

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

$config = Get-IniContent -Path "config/config.ini"
$webhookUrl = $config['ProcessFeed']['ProcessWebhook']

while ($true) {
    Start-Sleep -Seconds 7
    $elapsedTime = (Get-Date) - $startTime

    $currentProcesses = Get-Process | Where-Object { $_.MainWindowHandle -ne 0 }

    if ($elapsedTime.TotalSeconds -ge 8) {
        $newProcesses = $currentProcesses | Where-Object { $previousProcesses.Id -notcontains $_.Id }

        foreach ($process in $newProcesses) {
            $processName = $process.Name
            $processId = $process.Id
            $processStartTime = $process.StartTime.ToString()

            $processPath = try { $process.Path } catch { "N/A" }

            $embed = @{
                "embeds" = @(
                    @{
                        "title" = "New Process: $processName | $hostname"
                        "description" = "**Timestamp**: ``````($processStartTime)`````` `n**User**: ``````($curuser)`````` `n**Process**: ``````($processName)`````` `n**ID**: ``````($processId)`````` `n**Path**: ``````($processPath)`````` `n"
                        "color" = 0xb298dc
                    }
                )
            }


            $embedScript = $embed | ConvertTo-Json -Depth 4
            $embedScript = $embedScript -replace '[()]', ''
            $embedScript = $embedScript -replace '``````', '```N/A```'
            $json = $embedScript



            Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $json -ContentType "application/json"
        }
    }

    $previousProcesses = $currentProcesses
}