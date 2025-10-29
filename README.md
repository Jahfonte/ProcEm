# ProcEm - Proc Tracker for Turtle WoW

Simple, clean proc tracker with custom sound support.

## Features

- **Dropdown Selection**: Choose up to 10 procs to track
- **Enable/Disable**: Check/uncheck to toggle tracking
- **Custom Sounds**: Assign sounds 1-5 to each proc
- **Chat Notifications**: Shows "PROC'D: Nightfall" in chat window
- **Resizable Windows**: Drag corners to resize
- **Transparency Control**: Slider to adjust window opacity
- **Boss Tracking**: Auto-detects bosses, tracks procs per boss
- **Session Reset**: Reset counters before fights

## Config Window Layout

```
[Proc Dropdown ⏷] [On ☑] [Msg ☑] [Snd ☑] [# ⏷] [Test]
```

- **Proc Dropdown**: Click to select which proc to track
- **Enable Checkbox (On)**: Enable/disable tracking for this proc
- **Msg Checkbox**: Enable/disable chat message for this proc
- **Sound Checkbox**: Enable/disable sound for this proc
- **Sound Dropdown**: Choose sound 1-5
- **Test Button**: Preview the selected sound

## Custom Sounds

Place your custom .mp3 files in the addon sound folder:

```
Interface/AddOns/ProcEm/sound/1.mp3
Interface/AddOns/ProcEm/sound/2.mp3
Interface/AddOns/ProcEm/sound/3.mp3
Interface/AddOns/ProcEm/sound/4.mp3
Interface/AddOns/ProcEm/sound/5.mp3
```

Each proc can use a different sound (1-5).

## Commands

- `/procem` or `/procem config` - Open config window
- `/procem show` - Show proc tracker
- `/procem hide` - Hide proc tracker
- `/procem toggle` - Enable/disable tracking
- `/procem soundforce` - Toggle forced alert volume
- `/procem soundvol <0..1>` - Set forced alert volume (0.0–1.0)
- `/procem chat` - Toggle chat notifications
- `/procem reset` - Reset session counters
- `/procem lock` - Lock window position
- `/procem unlock` - Unlock window position
- `/procem boss` - Show boss statistics
 - `/procem tdcooldown <seconds>` - Target-debuff alert cooldown

## Usage

1. `/procem config` - Open config
2. Click first dropdown → Select a proc (Nightfall, Crusader, etc.)
3. Check "Enable" to track it
4. Check "Sound" if you want audio alerts
5. Click sound dropdown → Choose sound 1-5
6. Repeat for more procs
7. `/procem show` - Show tracker window
8. Click "Reset" before boss fights

## Notes

- Windows hidden by default (use `/procem show`)
- Both windows resizable and draggable
- Settings saved per character
- Tracks procs during combat
- Auto-detects bosses (elite/boss classification)
