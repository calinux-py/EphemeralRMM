# EphemeralRMM

Ephemeral is a free RMM using Discord and Chrome Remote Desktop API. It allows you to receive updates and control your devices from anywhere in the world using Discord.
It is a fun project.

## Requirements

- Python 3.8+
- Discord Bot Token
- Google Remote Desktop
- PowerShell
- discord.py
- psutil
- requests

## Features

- **Device Enrollment**: Easily enroll new devices to the network using the `/enroll-device` command.
- **Device Listing**: View all enrolled devices and their details using the `/device-list` command.
- **Status Check**: Remotely check the status of any enrolled device with the `/check-status` command.
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
    - `[DiscordToken]` is where you enter your Discord Bot token. 

4. **Run on your main device**:
    ```powershell
    python ephemeral-head.py
    ```
5. **Run on devices to manage**:
    ```powershell
    python ephemeral-head.py
    ```

## Commands

- `/device-list`: Lists all devices currently enrolled in the system.
- `/enroll-device`: Enrolls a new device into the system.
- `/check-status`: Checks the status of a specific device.
- `/howto-enroll`: Provides detailed instructions on how to enroll a new device.

## License

i dont care
