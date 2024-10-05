# [<img src="https://github.com/calinux-py/Ephemeral/blob/main/Ephemeral/config/ephemerallogo.png?raw=true" alt="Ephemeral Logo" width="5%">](https://github.com/calinux-py/Ephemeral) EphemeralRMM   

[<img src="https://github.com/calinux-py/Ephemeral/blob/main/Ephemeral/config/1723167525111.gif?raw=true" alt="Ephemeral Logo" width="68%">](https://github.com/calinux-py/Ephemeral)

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
![Windows](https://img.shields.io/badge/platform-Windows-blue) ![Linux](https://img.shields.io/badge/platform-Linux-green) ![Python](https://img.shields.io/badge/language-Python-darkgreen) ![PowerShell](https://img.shields.io/badge/language-PowerShell-purple) ![Bash](https://img.shields.io/badge/language-Bash-yellow) ![Discord](https://img.shields.io/badge/Discord-7289DA?logo=discord&logoColor=white) ![Google](https://img.shields.io/badge/Google-4285F4?logo=google&logoColor=white)



- Python 3.8+
- Discord Bot Token
- Discord Webhooks
- Google Remote Desktop
- PowerShell or Bash
- discord.py
- psutil
- requests

---

## Features

- **Device Enrollment**: Easily enroll new devices to the network using the `/enroll-device` command.
- **Device Listing**: View all enrolled devices and their details using the `/device-list` command.
- **Status Check**: Remotely check the status of any enrolled device with the `/check-status` command.
- **Discord Shell**: Execute Terminal (CMD) commands directly from Discord using the `/run` command. Return the output back to you in Discord.
- **Guided Enrollment**: Step-by-step instructions for enrolling a new device via the `/howto-enroll` command.

[<img src="https://github.com/calinux-py/Ephemeral/blob/main/Ephemeral/config/eph.png?raw=true" alt="Ephemeral Logo" width="71%">](https://github.com/calinux-py/Ephemeral)

---

## Commands

- `/device-list`: Lists all devices currently enrolled in the system.
- `/enroll-device`: Enrolls a new device into the system.
- `/check-status`: Checks the status of devices.
- `/run`: Execute PowerShell or cmd commands directly from Discord.
- `/howto-enroll`: Provides detailed instructions on how to enroll a new device.

---

## Windows Setup (Head and Client)

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
    - `[Hostname]` is the hostname of the device running Ephemeral-Head (the command and control device).
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

---

## Linux Setup (Head Only)
1. **Clone the Repository**:
    ```bash
    git clone https://github.com/calinux-py/Ephemeral.git
    cd Ephemeral; cd Ephemeral
    ```

2. **Install Dependencies**:
    ```bash
    pip install -r requirements.txt
    ```
    
3. **Remove all carriage return (\r) characters from the Linux-agent.sh file, converting it from Windows-style line to Unix-style line endings** (im lazy do it yourself).
    ```bash
    sed -i 's/\r//' Linux-agent.sh
    ```
    
4. **Configure Ephemeral**:
    - Update `config/config.ini` with your Discord bot token and webhooks.
    - `[Hostname]` is the hostname of the device running Ephemeral-Head (the command and control device).
    - `[AgentStatus]` is the Discord webhook where agents will post device information when inquired.
    - `[DiscordToken]` is where you enter your Discord Bot token.
    - No other webhooks are needed with Linux Ephemeral-Head.

5. **Add perms as needed**:
   ```bash
   chmod +x Linux-agent.sh Linux-Ephemeral-Head.py
   ```

6. **Run Ephemeral**:
   ```bash
   python3 Linux-Ephemeral-Head.py
   ```

7. **Run upon boot**:
    - Add this bash file, `start-eph.sh`, to any directory
   ```bash
    sleep 10
    cd /home/PATH/TO/Ephemeral
    lxterminal -e "python3 /home/PATH/TO/Ephemeral/Linux-Ephemeral-Head.py"
    ```

9. **Add startup file to .config**:
    - Go to /home/USER/.config
    - If you do not have a directory named autostart, create it.
    - Add this to autostart named Ephemeral.desktop
   ```bash
   [Desktop Entry]

   Exec=bash /home/PATH/TO/start-eph.sh
    ```
   
---

[<img src="https://github.com/calinux-py/Ephemeral/blob/main/Ephemeral/config/ephproc.png?raw=true" alt="Ephemeral Logo" width="70%">](https://github.com/calinux-py/Ephemeral)

## PowerShell Agents
- **Agent.ps1**: used for checking statuses of all client agents. Returns output back to user in Discord.
- **Agent2.ps1**: used for running shell commands and returning output back to the user in Discord.
- **Agent3.ps1**: used for monitoring new processes and updating the user in Discord.
- **Agent.sh**: Linux version of Agent.ps1.

---

## License

MIT
