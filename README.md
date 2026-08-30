# ArenaMaster PvP Inspect AddOn

## Overview

This is a utility addon for the ArenaMaster web app: <a href="https://arenamaster.io" target="_blank" rel="noopener">https://arenamaster.io</a>. By installing this addon, you'll be able to easily check any player's arena and rbg experience without having to leave the game.

## Unit Frame Hover

You can hover over a player's unit frame in the open world and see at a glance the highest 2v2, 3v3 and rbg rating they've achieved on the character, or the overall best rating if the player has an ArenaMaster account.

With the new addon version, you can see even more PvP info, like current season performance, account achievements, and overall character stats like versatility and health.

Solo Shuffle and Battleground Blitz are shown per specialization, best rating first, with the games played and win rate for each spec — so you can tell at a glance whether the healer you're looking at is a 2400 Mistweaver or a 1600 Windwalker.

![ArenaMaster.IO Unit Frame Hover](https://arenamaster.s3.eu-central-1.amazonaws.com/addon/NewTooltip.png "ArenaMaster.IO Tooltip Hover")

## Settings

With the new update you can control which info you're interested in seeing when in the open world / LFG and you also have a separate config for when you're in arenas or battlegrounds.

Type `/ampvp` in chat to bring up the settings interface. Every section — including the new Solo Shuffle and Battleground Blitz lines — can be toggled independently for the open world and for arenas/battlegrounds.

![ArenaMaster.IO Tooltip Settings](https://arenamaster.s3.eu-central-1.amazonaws.com/addon/TooltipSettings.png "ArenaMaster.IO Tooltip Settings")

## Battle&#46;net Friends Hover

You can also hover over your Battle&#46;net friends list and quickly determine the experience of your friend's currently played character. Combine this with in-game notes for your friends and a couple of useful addons like **Friend List Colors** and **Friend Groups** and your friend list suddenly becomes a more personal LFG experience.

![ArenaMaster.IO BattleNet Hover](https://arenamaster.s3.eu-central-1.amazonaws.com/addon/BattleNetHoverTooltip.png "ArenaMaster.IO BattleNet Hover")

## LFG Hovers

Whether you're creating a group or applying to someone else's, the ArenaMaster addon is here to help you determine the right fit as fast as possible.

### As a group owner

When reviewing group applications, quickly check the experience level to determine a potential match, before going to the website to see their full profile info.

![ArenaMaster.IO Group Owner Hover](https://arenamaster.s3.eu-central-1.amazonaws.com/addon/LFGGroupOwner.png "ArenaMaster.IO Group Owner Hover")

### Applying to groups

When applying to groups, you can check the experience of the group owner.

![ArenaMaster.IO Group Application Hover](https://arenamaster.s3.eu-central-1.amazonaws.com/addon/LFGHoverTooltip.png "ArenaMaster.IO Group Application Hover")

## Copy ArenaMaster Profile

In addition, you can right-click any character's unit frame to get their ArenaMaster Profile URL where you can see their full PvP information including current rating, win rates, gear, talents, achievements and much more.

Apart from unit frames, you can get the link from anywhere in-game by right-clicking the names in whispers, guild chat, LFG and other places.

The URL is already selected. All you have to do is `CTRL + C` the link and paste it in your browser of choice to get directly to their ArenaMaster Profile.

![ArenaMaster.IO Tooltip Hover](https://arenamaster.s3.eu-central-1.amazonaws.com/addon/InspectProfileLinkTooltip.png "ArenaMaster.IO Tooltip Hover")

## Installation

If you're using the Twitch app to manage your addons, open the app and navigate to the Mods -> Get More Addons section where you can find the addon by name.

In case you prefer to download the zip and unpack it in your addons directory yourself, click the <a href="https://www.curseforge.com/wow/addons/arenamaster/download" target="_blank" rel="noopener">Download from CurseForge</a>

Make sure to keep an eye out for updates and update when available. As the web app and addon are in the early stages, there is a chance you'll encounter players that have no data you can view with the addon. You can visit their ArenaMaster profiles in order to add them to our database, and their character data will be available in-game on the next update.

As more players start to use the web app, the data will be updated more frequently and the addon will become more and more useful.

## How Data Updates Work

The ratings, experience and other PvP stats shown by this addon come from a database that is **bundled with the addon itself** — it ships inside the download and is loaded locally while you play. The addon does **not** pull live data from the website while you're in-game, and it does **not** refresh on its own on a daily or weekly schedule the way some other tools (for example, raider.io) do.

A character's in-game data only changes when a **new version of the addon is released and you update it**. Each release packages a fresh snapshot of the ArenaMaster.IO database, so updating the addon is what brings in newer ratings and newly added characters.

## FAQ

### My characters show no data even though I updated them on the website. Why?

Updating your profile on <a href="https://arenamaster.io" target="_blank" rel="noopener">arenamaster.io</a> records your data on the website right away, but that data is only **bundled into the addon when the next addon version is released**. Until you install an addon update that includes a snapshot taken *after* your website update, the in-game tooltips won't show the new numbers — and a character that isn't in the bundled snapshot yet will show no ArenaMaster info at all.

To get your data in-game:

1. Visit your character's profile on <a href="https://arenamaster.io" target="_blank" rel="noopener">arenamaster.io</a> so it's recorded in the database.
2. Wait for a new addon version that includes a database snapshot taken after that visit.
3. Update the addon (via CurseForge or your addon manager) and reload the game.

### How often is the data updated?

It updates with addon releases rather than on a fixed daily or weekly schedule. As more players use the web app, snapshots are bundled and released more frequently. Keeping the addon up to date is the way to always see the latest available data.

### How do I know how current a character's data is?

When a character is present in the database, its tooltip includes a **Last Updated** line showing the date that character's data was captured.

## Support

Interested in supporting the ongoing development of ArenaMaster.IO and getting some in-app benefits while you're at it? Visit our Patreon page to learn more about the mission and available perks.

<a href="https://www.patreon.com/arenamaster" target="_blank" rel="noopener">
  <img src="https://arenamaster.s3.eu-central-1.amazonaws.com/addon/patreon-btn.png" alt="Support on Patreon" width="250">
</a>
