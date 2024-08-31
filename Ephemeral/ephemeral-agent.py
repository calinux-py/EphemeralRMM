# agent. run for client devices.

import discord
from discord.ext import commands
from discord import app_commands
import platform
import psutil
import subprocess
import configparser
import asyncio
import socket
import threading
import time
from datetime import datetime
import os
import configparser
import requests

# call stuff
hostname = socket.gethostname()
current_user = os.getlogin()
uptime_seconds = int(datetime.now().timestamp() - psutil.boot_time())
hours, remainder = divmod(uptime_seconds, 3600)
minutes, seconds = divmod(remainder, 60)
readable_uptime = f"{hours}h {minutes}m {seconds}s"
timestamp_utc = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')

config = configparser.ConfigParser()
config.read(['config/config.ini'])

webhook_url = config.get('LiveFeed', 'LiveFeedWebhook')
token = config.get('DiscordToken', 'Token')


config = configparser.ConfigParser()
intents = discord.Intents.default()
bot = commands.Bot(command_prefix="!", intents=intents)

print(f'\n\n---------------------------------------------\nEphemeral Agent is initiating...')
print(f"{timestamp_utc}\n---------------------------------------------\n\n")
@bot.event
async def on_ready():
    await bot.tree.sync()


    senddis = {
        "embeds": [
            {
                "title": f"{hostname} Agent Initiated",
                "fields": [
                    {"name": "Hostname", "value": hostname},
                    {"name": "Current User", "value": current_user},
                    {"name": "Uptime", "value": readable_uptime},
                    {"name": "Timestamp UTC", "value": timestamp_utc}
                ],
                "color": 00000000
            }
        ]
    }

    response = requests.post(
        webhook_url,
        json=senddis
    )

    # check success
    if response.status_code == 204:
        print("Yeet.")
    else:
        print(f"Failed: {response.status_code}")

# ignore
@bot.tree.command(name="device-list", description="List all devices.")
async def listofmemes(interaction: discord.Interaction):
    return

# ignore
@bot.tree.command(name="enroll-device", description="Setup a new device.")
async def checkmemes(interaction: discord.Interaction, hostname: str, link: str, passcode: str = ''):
    return


@bot.tree.command(name="check-status", description="Check Computer Status")
async def memecheck(interaction: discord.Interaction):
    def run_in_thread():
        amalive = f"```fix\n[ + ] Agent Responded from {hostname}```"
        asyncio.run_coroutine_threadsafe(interaction.channel.send(amalive), bot.loop)
        subprocess.Popen(
            ["powershell.exe", "-NoLogo", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "agent.ps1"])


    thread = threading.Thread(target=run_in_thread)
    thread.start()


@bot.tree.command(name="run", description="Execute PowerShell command")
async def execute(interaction: discord.Interaction, hostname: str, command: str):
    def run_in_thread():
        cmd = f'.\\agent2.ps1 -hostname "{hostname}" -command "{command}"'
        result = subprocess.run(
            ["powershell.exe", "-NoLogo", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", cmd],
            capture_output=True, text=True
        )
        output = result.stdout if result.stdout else result.stderr

    thread = threading.Thread(target=run_in_thread)
    thread.start()



# ignore
@bot.tree.command(name="howto-enroll", description="How to enroll a new device.")
async def howtomeme(interaction: discord.Interaction):
    return

bot.run(token)
