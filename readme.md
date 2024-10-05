# [<img src="https://github.com/calinux-py/Ephemeral/blob/main/Ephemeral/config/ephemerallogo.png?raw=true" alt="Ephemeral Logo" width="5%">](https://github.com/calinux-py/Ephemeral)     EphemeralRMM

Ephemeral is a free RMM using Discord and Chrome Remote Desktop API. It allows you to receive updates and control your devices from anywhere in the world using Discord.
It is a fun project. Now control from Linux/Raspberry Pi!

| Supported | Features            |
|--------|--------------------|
| ✅     | **Control devices remotely from Discord**   |
| ✅     | **Remote into any device from Discord**   |
| ✅     | **Guided enrollment of new devices**   |
| ✅     | **List enrolled devices**      |
| ✅     | **Status check on enrolled devices**        |
| ✅     | **Real-time device feed**       |
| ✅     | **Execute terminal cmds from Discord**   |
| ✅     | **Real-time process monitoring**   |
| ✅     | **Linux command and control support**   |
| ✅     | **Windows client and C&C support**   |



## Requirements
![Windows](https://img.shields.io/badge/platform-Windows-blue) ![Raspbian](https://img.shields.io/badge/platform-Raspbian-green) ![Python](https://img.shields.io/badge/language-Python-darkgreen) ![PowerShell](https://img.shields.io/badge/language-PowerShell-purple) ![Discord](https://img.shields.io/badge/Discord-7289DA?logo=discord&logoColor=white) ![Google](https://img.shields.io/badge/Google-4285F4?logo=google&logoColor=white)



- Python 3.8+
- Discord Bot Token
- Discord Webhooks
- Google Remote Desktop
- PowerShell or Bash
- discord.py
- psutil
- requests


## Features

- **Device Enrollment**: Easily enroll new devices to the network using the `/enroll-device` command.
- **Device Listing**: View all enrolled devices and their details using the `/device-list` command.
- **Status Check**: Remotely check the status of any enrolled device with the `/check-status` command.
- **Discord Shell**: Execute Terminal (CMD) commands directly from Discord using the `/run` command. Return the output back to you in Discord.
- **Guided Enrollment**: Step-by-step instructions for enrolling a new device via the `/howto-enroll` command.

[<img src="https://github.com/calinux-py/Ephemeral/blob/main/Ephemeral/config/eph.png?raw=true" alt="Ephemeral Logo" width="71%">](https://github.com/calinux-py/Ephemeral)



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
    - `[AgentCommands]` is the Discord webhook used by agents to return output from PowerShell commands.
    - `[ProcessFeed]` is the Discord webhook used to update new running processes.
    - LiveFeed, AgentStatus, and ProcessFeed can be the same Discord webhook (but not recommended).
    - `[DiscordToken]` is where you enter your Discord Bot token. 

4. **Convert Ephemeral source code into an .exe**:
```powershell
pyinstaller --onefile PATH/TO/EPHEMERAL.py
```

5. **Run Ephemeral**:
    - Run Ephemeral-Head on a server or computer you are controlling.
    - Run Ephemeral-Client on a Windows client device you want to control.

6. **Start Ephemeral (Hidden) Upon Each Boot**:
    - Save the below PowerShell script as a `.ps1` file in your `Startup Folder`. You can easily access your `Startup Folder` by holding `CTRL+R` and typing `shell:startup`.
```powershell
cd "PATH\TO\Ephemeral\";
Start-Process -FilePath .\ephemeral.exe -WindowStyle hidden; Start-Process -FilePath .\agent3.ps1 -WindowStyle hidden
```

7. Optional: **Start Ephemeral (Hidden) Upon Each Boot WITHOUT Process Monitor**:
    - Save the below PowerShell script as a `.ps1` file in your `Startup Folder`. You can easily access your `Startup Folder` by holding `CTRL+R` and typing `shell:startup`.

```powershell
cd "PATH\TO\Ephemeral\";
Start-Process -FilePath .\ephemeral.exe -WindowStyle hidden
```

## Commands

- `/device-list`: Lists all devices currently enrolled in the system.
- `/enroll-device`: Enrolls a new device into the system.
- `/check-status`: Checks the status of devices.
- `/run`: Execute PowerShell or cmd commands directly from Discord.
- `/howto-enroll`: Provides detailed instructions on how to enroll a new device.

[<img src="https://github.com/calinux-py/Ephemeral/blob/main/Ephemeral/config/ephproc.png?raw=true" alt="Ephemeral Logo" width="70%">](https://github.com/calinux-py/Ephemeral)

## PowerShell Agents
- **Agent.ps1**: used for checking statuses of all client agents. Returns output back to user in Discord.
- **Agent2.ps1**: used for running shell commands and returning output back to the user in Discord.
- **Agent3.ps1**: used for monitoring new processes and updating the user in Discord. 

## License

MIT

[<img src="https://github.com/calinux-py/Ephemeral/blob/main/Ephemeral/config/1723167525111.gif?raw=true" alt="Ephemeral Logo" width="75%">](https://github.com/calinux-py/Ephemeral)
