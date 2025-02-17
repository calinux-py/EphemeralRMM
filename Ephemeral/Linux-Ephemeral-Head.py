# head. command and control.

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
import ipaddress

def get_non_loopback_ipv4_addresses():
    valid_ips = []
    for interface, addrs in psutil.net_if_addrs().items():
        for addr in addrs:
            if addr.family == socket.AF_INET:
                ip = addr.address
                try:
                    ip_obj = ipaddress.ip_address(ip)
                    if not ip_obj.is_loopback:
                        valid_ips.append(ip)
                except ValueError:
                    continue
    return valid_ips

# call stuff
hostname = socket.gethostname()
current_user = os.getlogin()
uptime_seconds = int(datetime.now().timestamp() - psutil.boot_time())
hours, remainder = divmod(uptime_seconds, 3600)
minutes, seconds = divmod(remainder, 60)
readable_uptime = f"{hours}h {minutes}m {seconds}s"
timestamp_utc = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')

config = configparser.ConfigParser()
config.read('config/config.ini')
token = config.get('DiscordToken', 'Token')
webhook_url = config.get('LiveFeed', 'LiveFeedWebhook')

config = configparser.ConfigParser()
intents = discord.Intents.default()
bot = commands.Bot(command_prefix="!", intents=intents)

print(f'\n\n---------------------------------------------\nEphemeral Head is initiating...')
print(f"{timestamp_utc}\n---------------------------------------------\n\n")

@bot.event
async def on_ready():
    await bot.tree.sync(guild=None)
    
    ipv4_addresses = get_non_loopback_ipv4_addresses()
    ipv4_str = "\n".join(ipv4_addresses) if ipv4_addresses else "None"
    
    senddis = {
        "embeds": [
            {
                "title": f"{hostname} Agent Initiated",
                "fields": [
                    {"name": "Hostname", "value": hostname},
                    {"name": "Current User", "value": current_user},
                    {"name": "Uptime", "value": readable_uptime},
                    {"name": "Timestamp UTC", "value": timestamp_utc},
                    {"name": "IPv4 Addresses", "value": ipv4_str}
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


@bot.tree.command(name="device-list", description="List all devices.")
async def listofmemes(interaction: discord.Interaction):
    await interaction.response.defer(ephemeral=True)

    config.read('config/agents.ini')
    agents = config.get('Ephemerial', 'agents').strip('[]').split('], [')
    response = ""
    for agent in agents:
        parts = agent.split(' : ')
        name = parts[0]
        link = parts[1]
        passcode = parts[2] if len(parts) > 2 else ''

        response += f"> **Name**: {name}\n> [Remote to {name}]({link})\n"
        if passcode:
            response += f"> **Passcode**: ||{passcode}||\n"
        response += "\n"

    await interaction.followup.send(response)


@bot.tree.command(name="enroll-device", description="Setup a new device.")
async def checkmemes(interaction: discord.Interaction, hostname: str, link: str, passcode: str = ''):
    await interaction.response.defer(ephemeral=False)

    # dont really need this check right now but have future logic which this check will be required
    config = configparser.ConfigParser()
    configa = configparser.ConfigParser()
    config.read('config/config.ini')

    hostname2 = config.get('Hostname', 'name').lower()
    if socket.gethostname().lower() != hostname2:
        return
    configa.read('config/agents.ini')

    if 'Ephemerial' not in configa:
        configa['Ephemerial'] = {}
    if 'Agents' not in configa['Ephemerial']:
        configa['Ephemerial']['Agents'] = ''

    agents = configa['Ephemerial']['Agents']
    new_agent = f'[{hostname} : {link} : {passcode}]' if passcode else f'[{hostname} : {link}]'

    if agents:
        agents_list = agents.split(', ')
        agents_list.append(new_agent)
        configa['Ephemerial']['Agents'] = ', '.join(agents_list)
    else:
        configa['Ephemerial']['Agents'] = new_agent

    with open('config/agents.ini', 'w') as configfile:
        configa.write(configfile)

    await interaction.followup.send(f"Added agent: {hostname} with link: {link} {'and passcode: ' + passcode if passcode else ''}")


@bot.tree.command(name="check-status", description="Check Computer Status")
async def memecheck(interaction: discord.Interaction):
    await interaction.response.defer(ephemeral=True)

    def run_in_thread():
        hostname = socket.gethostname()
        response_message = f"```fix\n[ + ] Agent Responded from {hostname}```"
        asyncio.run_coroutine_threadsafe(interaction.channel.send(response_message), bot.loop)
        subprocess.Popen(
            ["bash", "./Linux-agent.sh"]
        )

    thread = threading.Thread(target=run_in_thread)
    thread.start()

    await interaction.followup.send("-# Command executed successfully.", ephemeral=True)


@bot.tree.command(name="howto-enroll", description="How to enroll a new device.")
async def howtomeme(interaction: discord.Interaction):
    await interaction.response.defer(ephemeral=False)

    embed = discord.Embed(
        title="How to Enroll a New Device",
        description=( 
            "Step 1\n\nFirst, download [Google Remote Desktop](https://remotedesktop.google.com/unsupported-browser/?target=/access) "
            "and follow the directions to fully install it. Recommended to use Google Chrome or bugs may occur.\n\n"
            "Once installed, select `Set up via SSH` and then `Begin`."
        )
    )
    embed.set_image(url="attachment://new-agent1.png")

    await interaction.followup.send(embed=embed, file=discord.File("config/setup/new-agent1.png"))

    embed = discord.Embed(
        description=( 
            "Step 2\n\nCopy the `.msi` or `.deb` link and send this to the remote computer you want to onboard. "
            "Download the remote software and complete the installation."
        )
    )
    embed.set_image(url="attachment://new-agent2.png")

    await interaction.followup.send(embed=embed, file=discord.File("config/setup/new-agent2.png"))

    embed = discord.Embed(
        description=( 
            "Step 3\n\nAuthorize the setup of another computer and copy the script for either `Cmd`, `PowerShell`, or `Linux Terminal`. "
            "Run this in the respective terminal."
        )
    )
    embed.set_image(url="attachment://new-agent3.png")

    await interaction.followup.send(embed=embed, file=discord.File("config/setup/new-agent3.png"))

    embed = discord.Embed(
        description=( 
            "Step 4\n\nOnce you execute the script in the terminal, it will require a `passcode` to complete. "
            "This `passcode` will be required when remoting to that specific device.\n\n"
        )
    )
    embed.set_image(url="attachment://new-agent4.png")

    await interaction.followup.send(embed=embed, file=discord.File("config/setup/new-agent4.png"))

    embed = discord.Embed(
        description=( 
            "Step 5\n\nReturn back to the `Google Remote Desktop` application and view your new enrolled device in `Remote Access`.\n\nIf your device does not appear, refresh the page."
        )
    )
    embed.set_image(url="attachment://new-agent5.png")

    await interaction.followup.send(embed=embed, file=discord.File("config/setup/new-agent5.png"))

    embed = discord.Embed(
        description=( 
            "Step 6\n\nRight-click the recently enrolled device and select `Copy link address`."
        )
    )
    embed.set_image(url="attachment://new-agent6.png")

    await interaction.followup.send(embed=embed, file=discord.File("config/setup/new-agent6.png"))

    embed = discord.Embed(
        description=( 
            "Step 7\n\nSwitch back to Discord and run the `/enroll-device` command.\n\nEnter in the devices `name`, the `link` copied from the last step, and the `passcode` (optional)."
        )
    )
    embed.set_image(url="attachment://new-agent7.png")

    await interaction.followup.send(embed=embed, file=discord.File("config/setup/new-agent7.png"))

    embed = discord.Embed(
        description=( 
            "Step 8\n\nRun the `/device-list` command to view enrolled devices."
        )
    )
    embed.set_image(url="attachment://new-agent8.png")

    await interaction.followup.send(embed=embed, file=discord.File("config/setup/new-agent8.png"))


@bot.tree.command(name="run", description="Execute PowerShell command")
async def execute(interaction: discord.Interaction, host: str, command: str):
    async def run_in_thread():
        await interaction.response.send_message("-# Command executed successfully.", ephemeral=True)

    await run_in_thread()


bot.run(token)
