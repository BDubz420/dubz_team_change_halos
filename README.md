# Dubz UI Lib – Readme / Usage Guide

This file is basically a small utility library I use across projects for quick UI, messaging, and area-based interaction systems. It’s meant to be lightweight and easy to drop into any DarkRP or sandbox-style gamemode.

Nothing in here is overly strict — you can rip pieces out or modify them however you want.

---

## GENERAL NOTES

* This file contains both CLIENT and SERVER code.
* Some functions are meant to be called server-side (broadcasting, spawning blobs).
* Some are purely client-side (HUD drawing, panels).
* Networking is already handled internally where needed.

If something isn’t working, 90% of the time it’s because it’s being called on the wrong realm.

---

1. BROADCAST TEXT (CENTER / SCREEN)

---

DrawBroadcastText(msg, font, color, time, position)

Simple way to draw temporary text on the player’s screen.

Example:
DrawBroadcastText("Hello!", "DermaLarge", Color(255,0,0), 5, "topright")

Notes:

* Automatically removes itself after time expires.
* Position is a string (see list below).
* Uses HUDPaint, so don’t spam it every tick.

Positions:
topleft, topcenter, topright
centerleft, center, centerright
bottomleft, bottomcenter, bottomright

---

2. CHAT BROADCASTING

---

BroadcastChatText(ply, msg, color)

Sends a colored chat message attributed to a player.

Example:
BroadcastChatText(ply, "Hello world", Color(255, 0, 0))

Notes:

* This is server-side only.
* Displays as: PlayerName: message
* Color only affects the message, not the name.

---

3. BANKER HUD (ROLE-BASED UI)

---

DrawBankerHUD(teamID, header, headerFont, headerColor, content, contentFont, contentColor, bgColor, width, height, position, duration)

Example:
DrawBankerHUD(
TEAM_BANKER,
"Bank Menu",
"DermaLarge",
Color(255,255,255),
"Welcome to the bank!",
"DermaDefault",
Color(200,200,200),
Color(20,20,20,200),
300,
200,
"topright",
5
)

Notes:

* Only renders if LocalPlayer():Team() matches.
* Good for job-specific HUD elements.
* Auto-removes after duration.

---

4. HINT UI (LIGHTWEIGHT PROMPT)

---

HintUI(color, content, contentFont, contentColor, bgColor, width, height, position, duration)

Example:
HintUI(
Color(255,255,255),
"Press E to interact",
"DermaDefault",
Color(200,200,200),
Color(20,20,20,220),
300,
100,
"bottomcenter",
2
)

Notes:

* Replaces any existing hint (does not stack).
* Has fade in/out built in.
* Good for proximity prompts.

---

5. INTERACTION PANEL (CONFIRM UI)

---

OpenInteractionPanel(title, content, onAccept, onDecline)

Example:
OpenInteractionPanel(
"Job Selection",
"Become Police?",
function()
RunConsoleCommand("join_blob_team", TEAM_POLICE)
end,
function()
print("Declined")
end
)

Notes:

* Only one panel can exist at a time.
* Accept/Decline callbacks are optional.
* This is what your blob system uses.

---

6. AREA INTERACTABLE SYSTEM (BLOBS)

---

This is the main feature in this file.

Blobs are invisible entities that:

* Detect when a player enters a radius
* Show a UI prompt
* Optionally play a sound
* Allow the player to switch jobs

Everything is handled through the admin menu.

---

## OPENING THE MENU

Console command (admin only):

dubz_blob_menu

---

## CREATING A BLOB

Inside the menu:

* Select a job (from DarkRP job list)
* Set radius (distance trigger)
* Set message (shown to player)
* Pick a color (affects the cylinder visual)
* Optional sound (plays on enter)
* Toggle sound on/off

Blob spawns at your feet.

---

## EDITING A BLOB

* Select a blob from the list
* Click "Edit Selected"
* Change any values (team, radius, message, color, sound)
* Save

Changes apply immediately and persist.

---

## DELETING A BLOB

* Select blob
* Click "Delete Selected"

That’s it.

---

## HOW TEAM SWITCHING WORKS

Uses DarkRP’s proper function:

ply:changeTeam(teamID, false)

Also includes:

* cooldown (prevents spam)
* prevents switching to same team

---

## DATA STORAGE

Blobs are saved to:

data/dubz_blobs.txt

Stored values:

* id
* position
* team
* radius
* message
* color
* sound
* play sound toggle

They automatically reload on server start.

---

## NETWORKING

Handled internally using:

Dubz_OpenBlobMenu
Dubz_RequestBlobs
Dubz_SendBlobs
Dubz_CreateBlob
Dubz_DeleteBlob
Dubz_UpdateBlob

You generally won’t need to touch this unless extending the system.

---

## KNOWN LIMITATIONS / NOTES

* Blob detection runs clientside (Think hook)
* Sound must be a valid path (e.g. "buttons/button14.wav")
* Color is applied via networked vector (for consistency)
* Menu assumes DarkRP team structure

If something feels off, it’s usually:

* bad team ID
* invalid sound path
* missing NW values

---

## FINAL NOTES

This was built to be practical, not overengineered.

If you want to extend it, easy upgrades would be:

* animations on the cylinder
* per-blob cooldown settings
* job whitelist/blacklist
* permissions per blob

Otherwise, it should be good to go as-is.
