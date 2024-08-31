# EphemeralRMM

Ephemeral is a free RMM using Discord and Chrome Remote Desktop API. It allows you to receive updates and control your devices from anywhere in the world using Discord.
It is a fun project.

| Supported | Feature            |
|--------|--------------------|
| ✅     | **Control devices remotely**   |
| ✅     | **Remote into any device from Discord**   |
| ✅     | **List enrolled devices**      |
| ✅     | **Status check on enrolled devices**        |
| ✅     | **Real-time device feed**       |
| ✅     | **Execute PowerShell commands from Discord**   |
| ✅     | **Guided enrollment of new devices**   |


## Requirements
![Windows](https://img.shields.io/badge/platform-Windows-blue)![Python](https://img.shields.io/badge/language-Python-darkgreen)![PowerShell](https://img.shields.io/badge/language-PowerShell-purple)![Discord](https://img.shields.io/badge/Discord-7289DA?logo=discord&logoColor=white)![Google](https://img.shields.io/badge/Google-4285F4?logo=google&logoColor=white)



- Python 3.8+
- Discord Bot Token
- Discord Webhooks
- Google Remote Desktop
- PowerShell
- discord.py
- psutil
- requests


## Features

- **Device Enrollment**: Easily enroll new devices to the network using the `/enroll-device` command.
- **Device Listing**: View all enrolled devices and their details using the `/device-list` command.
- **Status Check**: Remotely check the status of any enrolled device with the `/check-status` command.
- **Discord Shell**: Execute PowerShell commands directly from Discord using the `/run` command. Return the output back to you in Discord.
- **Guided Enrollment**: Step-by-step instructions for enrolling a new device via the `/howto-enroll` command.

## Setup

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/calinux-py/Ephemeral.git
    cd ephemeral; cd ephemeral
    ```

2. **Install Dependencies**:
    ```powershell
    pip install -r requirements.txt
    ```

3. **Configure Ephemeral**:
    - Update `config/config.ini` with your Discord bot token and webhooks.
    - `[LiveFeed]` is the Discord webhook where your devices will actively post device information in realtime.
    - `[AgentStatus]` is the Discord webhook where agents will post device information when inquired.
    - LiveFeed and AgentStatus can be the same Discord webhook.
    - `[AgentCommands]` is the Discord webhook used by agents to return output from PowerShell commands.
    - LiveFeed and AgentStatus can be the same Discord webhook.
    - `[DiscordToken]` is where you enter your Discord Bot token. 

4. **Run on your main device**:
    ```powershell
    python ephemeral-head.py
    ```
5. **Run on devices to manage**:
    ```powershell
    python ephemeral-agent.py
    ```

## Commands

- `/device-list`: Lists all devices currently enrolled in the system.
- `/enroll-device`: Enrolls a new device into the system.
- `/check-status`: Checks the status of devices.
- `/run`: Execute PowerShell or cmd commands directly from Discord.
- `/howto-enroll`: Provides detailed instructions on how to enroll a new device.

## Start Ephemeral (Hidden) Upon Each Boot
Save the below PowerShell script as a `.ps1` file in your `Startup Folder`. You can easily access your `Startup Folder` by holding `CTRL+R` and typing `shell:startup`.
```powershell
cd "PATH\TO\Ephemeral\Ephemeral\";
Start-Process -FilePath .\ephemeral.exe -WindowStyle hidden
```

## License

MIT
