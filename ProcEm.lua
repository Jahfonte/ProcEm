-- Addon namespace
ProcEm = ProcEm or {}

-- Local references for performance
local _G = _G or getfenv(0)
local getn = table.getn
local S_FIND = string.find
local S_LOWER = string.lower

-- Session data
ProcEm.sessionProcs = {}
ProcEm.currentBoss = nil
ProcEm.inCombat = false
ProcEm.enabled = true

-- Default saved variables structure
ProcEm.defaultDB = {
    enabled = true,
    soundEnabled = true,
    soundVolume = 1.0,        -- 0.0 - 1.0 for forced playback
    soundForce = true,        -- temporarily force SFX on + volume during playback
    targetDebuffCooldown = 1.5,
    displayLocked = false,
    displayAlpha = 1.0,
    displayPosition = {
        point = "CENTER",
        x = 0,
        y = 0,
    },
    displaySize = {250, 300},
    configSize = {520, 500},
    trackedProcs = {},
    procSounds = {},
    customProcs = {},
    bossStats = {},
}

ProcEm.defaultCharDB = {
    procSettings = {},
    totalProcs = {},
}

-- Initialize saved variables
function ProcEm:InitDatabase()
    if not ProcEmDB then
        ProcEmDB = {}
    end

    -- Merge defaults
    for key, value in pairs(self.defaultDB) do
        if ProcEmDB[key] == nil then
            ProcEmDB[key] = value
        end
    end

    -- Restore enabled toggle from saved variables if present
    if ProcEmDB.enabled ~= nil then
        self.enabled = ProcEmDB.enabled
    end

    if not ProcEmCharDB then
        ProcEmCharDB = {}
    end

    for key, value in pairs(self.defaultCharDB) do
        if ProcEmCharDB[key] == nil then
            ProcEmCharDB[key] = value
        end
    end

    -- Load proc settings from character DB
    for procName, settings in pairs(ProcEmCharDB.procSettings) do
        if ProcEmData.Procs[procName] then
            if settings.enabled ~= nil then
                ProcEmData.Procs[procName].enabled = settings.enabled
            end
        end
    end
end

-- Safe sound playback that can temporarily force volume to a desired level (1.12/Turtle)
function ProcEm:PlayProcSound(soundNum)
    local path = "Interface\\AddOns\\ProcEm\\sound\\" .. tostring(soundNum) .. ".mp3"
    if ProcEmDB and ProcEmDB.soundForce then
        local oldVol = GetCVar("SoundVolume")
        local desired = ProcEmDB.soundVolume or 1.0
        if desired < 0 then desired = 0 end
        if desired > 1 then desired = 1 end
        SetCVar("SoundVolume", tostring(desired))
        PlaySoundFile(path)
        SetCVar("SoundVolume", oldVol)
    else
        PlaySoundFile(path)
    end
end

-- Set only the background alpha of the main display (keep text fully visible)
function ProcEm:SetBackgroundAlpha(alpha)
    ProcEmDB.displayAlpha = alpha
    if ProcEmFrame and ProcEmFrame.SetBackdropColor then
        ProcEmFrame:SetBackdropColor(1, 1, 1, alpha)
        if ProcEmFrame.SetBackdropBorderColor then
            ProcEmFrame:SetBackdropBorderColor(1, 1, 1, 1)
        end
    end
end

-- Save proc settings to character DB
function ProcEm:SaveProcSettings()
    ProcEmCharDB.procSettings = {}
    for procName, proc in pairs(ProcEmData.Procs) do
        ProcEmCharDB.procSettings[procName] = {
            enabled = proc.enabled
        }
    end
end

-- Print message to chat
function ProcEm:Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00ProcEm:|r " .. tostring(msg))
end

-- Debug message (only if debug enabled)
function ProcEm:Debug(msg)
    if ProcEmDB.debug then
        DEFAULT_CHAT_FRAME:AddMessage("|cff888888[ProcEm Debug]|r " .. tostring(msg))
    end
end

-- Initialize session proc counters
function ProcEm:InitSessionProcs()
    self.sessionProcs = {}
    -- Build a set of selected procs from config
    local selected = {}
    if ProcEmDB and ProcEmDB.trackedProcs then
        for _, name in pairs(ProcEmDB.trackedProcs) do
            if name then selected[name] = true end
        end
    end
    for procName, proc in pairs(ProcEmData.Procs) do
        if proc.enabled and selected[procName] then
            self.sessionProcs[procName] = {
                count = 0,
                lastProc = 0,
            }
        end
    end
end

-- Record a proc
function ProcEm:RecordProc(procName)
    local proc = ProcEmData.Procs[procName]
    if not proc or not proc.enabled then
        return
    end

    -- Initialize if needed
    if not self.sessionProcs[procName] then
        self.sessionProcs[procName] = {count = 0, lastProc = 0}
    end

    -- Increment counters
    self.sessionProcs[procName].count = self.sessionProcs[procName].count + 1
    self.sessionProcs[procName].lastProc = GetTime()

    -- Increment total counter
    if not ProcEmCharDB.totalProcs[procName] then
        ProcEmCharDB.totalProcs[procName] = 0
    end
    ProcEmCharDB.totalProcs[procName] = ProcEmCharDB.totalProcs[procName] + 1

    -- Boss tracking
    if self.currentBoss then
        if not ProcEmDB.bossStats[self.currentBoss] then
            ProcEmDB.bossStats[self.currentBoss] = {}
        end
        if not ProcEmDB.bossStats[self.currentBoss][procName] then
            ProcEmDB.bossStats[self.currentBoss][procName] = 0
        end
        ProcEmDB.bossStats[self.currentBoss][procName] = ProcEmDB.bossStats[self.currentBoss][procName] + 1
    end

    -- Play custom sound
    if ProcEmDB.soundEnabled and ProcEmDB.procSounds and ProcEmDB.procSounds[procName] then
        if ProcEmDB.procSounds[procName].enabled and ProcEmDB.procSounds[procName].soundNum then
            local soundNum = ProcEmDB.procSounds[procName].soundNum
            self:PlayProcSound(soundNum)
        end
    end

    -- Chat notification
    local chatOk = true
    if ProcEmDB and ProcEmDB.procChat then
        if ProcEmDB.procChat[procName] and ProcEmDB.procChat[procName].enabled ~= nil then
            chatOk = ProcEmDB.procChat[procName].enabled
        end
    end
    if chatOk then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00PROC'D:|r " .. tostring(procName))
    end

    -- Update display
    if ProcEmFrame and ProcEmFrame:IsVisible() then
        ProcEm:UpdateDisplay()
    end

    self:Debug("Proc recorded: " .. tostring(procName) .. " (Count: " .. tostring(self.sessionProcs[procName].count) .. ")")
end

-- Parse combat log message for proc detection
function ProcEm:ParseCombatLog(event, message)
    if not self.enabled or not message then
        return
    end

    -- Build a set of selected procs to enforce "only track what's in config"
    local selected = {}
    if ProcEmDB and ProcEmDB.trackedProcs then
        for _, name in pairs(ProcEmDB.trackedProcs) do
            if name then selected[name] = true end
        end
    end

    -- Check each enabled proc
    for procName, proc in pairs(ProcEmData.Procs) do
        if proc.enabled and proc.event == event and selected[procName] then
            if proc.pattern and S_FIND(message, proc.pattern) then
                if proc.targetOnly then
                    local currentTarget = UnitName("target")
                    if currentTarget then
                        local who = string.match(message, "^(.+) is afflicted by ")
                        if who and who == currentTarget then
                            -- Anti-spam cooldown per proc per target to avoid double alerts
                            self.lastTargetProc = self.lastTargetProc or {}
                            self.lastTargetProc[procName] = self.lastTargetProc[procName] or {}
                            local now = GetTime()
                            local last = self.lastTargetProc[procName][who] or 0
                            local cd = (ProcEmDB and ProcEmDB.targetDebuffCooldown) or 1.5
                            if (now - last) >= cd then
                                self.lastTargetProc[procName][who] = now
                                self:RecordProc(procName)
                            else
                                -- Suppressed due to cooldown
                            end
                        end
                    end
                else
                    self:RecordProc(procName)
                end
            end
        end
    end
end

-- Detect boss encounters
function ProcEm:DetectBoss(unitName)
    if not unitName then
        return
    end

    -- Check if unit is a boss (level 63 or ?? or elite)
    local targetLevel = UnitLevel("target")
    local targetClassification = UnitClassification("target")

    if targetLevel == -1 or targetClassification == "worldboss" or targetClassification == "boss" or targetClassification == "elite" then
        -- This is likely a boss
        if unitName ~= self.currentBoss then
            self.currentBoss = unitName
            -- Removed verbose chat message for cleaner output
        end
    end
end

-- Combat detection
function ProcEm:OnPlayerRegenDisabled()
    self.inCombat = true

    -- Check if we're targeting a boss
    if UnitExists("target") and UnitCanAttack("player", "target") then
        local targetName = UnitName("target")
        self:DetectBoss(targetName)
    end
end

function ProcEm:OnPlayerRegenEnabled()
    self.inCombat = false

    -- Clear boss after combat ends
    if self.currentBoss then
        self.currentBoss = nil
    end
end

-- Update target (to detect boss)
function ProcEm:OnPlayerTargetChanged()
    if self.inCombat and UnitExists("target") and UnitCanAttack("player", "target") then
        local targetName = UnitName("target")
        self:DetectBoss(targetName)
    end
end

-- Event handler
function ProcEm:OnEvent(event)
    if event == "ADDON_LOADED" and arg1 == "ProcEm" then
        self:InitDatabase()
        self:InitSessionProcs()
        -- Quiet load

    elseif event == "PLAYER_LOGIN" then
        self:InitSessionProcs()
        self:InitDisplay()

    elseif event == "PLAYER_REGEN_DISABLED" then
        self:OnPlayerRegenDisabled()

    elseif event == "PLAYER_REGEN_ENABLED" then
        self:OnPlayerRegenEnabled()

    elseif event == "PLAYER_TARGET_CHANGED" then
        self:OnPlayerTargetChanged()

    -- Combat log events
    elseif event == "CHAT_MSG_SPELL_SELF_BUFF" or
           event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" or
           event == "CHAT_MSG_SPELL_SELF_DAMAGE" or
           event == "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE" or
           event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" or
           event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" or
           event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" then
        self:ParseCombatLog(event, arg1)
    end
end

-- Slash command handler
function ProcEm:SlashCommand(msg)
    msg = S_LOWER(msg or "")

    if msg == "toggle" then
        self.enabled = not self.enabled
        ProcEmDB.enabled = self.enabled
        self:Print("Tracking " .. (self.enabled and "|cff00ff00enabled|r" or "|cffff0000disabled|r"))

    elseif msg == "sound" then
        ProcEmDB.soundEnabled = not ProcEmDB.soundEnabled
        self:Print("Sound " .. (ProcEmDB.soundEnabled and "|cff00ff00enabled|r" or "|cffff0000disabled|r"))

    elseif msg == "reset" then
        self:InitSessionProcs()
        self:Print("Session counters reset")
        if ProcEmFrame and ProcEmFrame:IsVisible() then
            self:UpdateDisplay()
        end

    elseif msg == "show" then
        if ProcEmFrame then
            ProcEmFrame:Show()
            self:UpdateDisplay()
        end

    elseif msg == "hide" then
        if ProcEmFrame then
            ProcEmFrame:Hide()
        end

    elseif msg == "lock" then
        ProcEmDB.displayLocked = true
        self:Print("Display locked")
        if ProcEmFrame then
            ProcEmFrame:EnableMouse(false)
        end

    elseif msg == "unlock" then
        ProcEmDB.displayLocked = false
        self:Print("Display unlocked - drag to move")
        if ProcEmFrame then
            ProcEmFrame:EnableMouse(true)
        end

    elseif msg == "config" or msg == "options" or msg == "" then
        if ProcEmConfigFrame then
            if ProcEmConfigFrame:IsVisible() then
                ProcEmConfigFrame:Hide()
            else
                ProcEmConfigFrame:Show()
                ProcEm:RefreshConfigUI()
            end
        end

    elseif msg == "boss" or msg == "stats" then
        self:PrintBossStats()

    elseif string.sub(msg, 1, 10) == "tdcooldown" then
        local arg = string.gsub(msg, "^tdcooldown%s*", "")
        if arg == "" then
            self:Print("Target debuff cooldown: " .. tostring(ProcEmDB.targetDebuffCooldown or 1.5) .. "s")
        else
            local secs = tonumber(arg)
            if secs and secs >= 0 then
                ProcEmDB.targetDebuffCooldown = secs
                self:Print("Target debuff cooldown set to " .. tostring(secs) .. "s")
            else
                self:Print("Invalid value. Usage: /procem tdcooldown <seconds>")
            end
        end

    elseif string.sub(msg, 1, 8) == "soundvol" then
        local arg = string.gsub(msg, "^soundvol%s*", "")
        if arg == "" then
            self:Print("Sound volume: " .. tostring(ProcEmDB.soundVolume or 1.0))
        else
            local vol = tonumber(arg)
            if vol and vol >= 0 and vol <= 1 then
                ProcEmDB.soundVolume = vol
                self:Print("Sound volume set to " .. tostring(vol))
            else
                self:Print("Invalid value. Usage: /procem soundvol <0..1>")
            end
        end

    elseif msg == "soundforce" then
        ProcEmDB.soundForce = not ProcEmDB.soundForce
        self:Print("Sound force is now " .. (ProcEmDB.soundForce and "|cff00ff00ON|r" or "|cffff0000OFF|r"))

    elseif msg == "chat" then
        ProcEmDB.chatEnabled = not ProcEmDB.chatEnabled
        self:Print("Chat notifications " .. (ProcEmDB.chatEnabled and "|cff00ff00enabled|r" or "|cffff0000disabled|r"))

    else
        self:Print("Commands:")
        self:Print("  /procem - Open configuration")
        self:Print("  /procem toggle - Enable/disable tracking")
        self:Print("  /procem sound - Toggle sound notifications")
        self:Print("  /procem soundforce - Toggle force SFX+volume for alerts")
        self:Print("  /procem soundvol <0..1> - Set forced alert volume")
        self:Print("  /procem chat - Toggle chat notifications")
        self:Print("  /procem reset - Reset session counters")
        self:Print("  /procem show/hide - Show/hide display")
        self:Print("  /procem lock/unlock - Lock/unlock display position")
        self:Print("  /procem boss - Show boss statistics")
        self:Print("  /procem tdcooldown <seconds> - Target-debuff alert cooldown")
    end
end

-- Print boss statistics
function ProcEm:PrintBossStats()
    self:Print("Boss Statistics:")

    if not ProcEmDB.bossStats or getn(ProcEmDB.bossStats) == 0 then
        self:Print("  No boss data recorded yet")
        return
    end

    for bossName, procs in pairs(ProcEmDB.bossStats) do
        DEFAULT_CHAT_FRAME:AddMessage("|cffff8000" .. tostring(bossName) .. "|r")
        for procName, count in pairs(procs) do
            DEFAULT_CHAT_FRAME:AddMessage("  " .. tostring(procName) .. ": " .. tostring(count))
        end
    end
end

-- Create main event frame
ProcEm.eventFrame = CreateFrame("Frame", "ProcEmEventFrame")
ProcEm.eventFrame:RegisterEvent("ADDON_LOADED")
ProcEm.eventFrame:RegisterEvent("PLAYER_LOGIN")
ProcEm.eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
ProcEm.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
ProcEm.eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
ProcEm.eventFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
ProcEm.eventFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
ProcEm.eventFrame:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
ProcEm.eventFrame:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
ProcEm.eventFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
ProcEm.eventFrame:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
ProcEm.eventFrame:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")

ProcEm.eventFrame:SetScript("OnEvent", function()
    ProcEm:OnEvent(event)
end)

-- Register slash commands
SLASH_PROCEM1 = "/procem"
SLASH_PROCEM2 = "/procmonitor"
SlashCmdList["PROCEM"] = function(msg)
    ProcEm:SlashCommand(msg)
end
