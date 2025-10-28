local getn = table.getn

ProcEm.configRows = {}
ProcEm.MAX_TRACKED_PROCS = 10
ProcEm.trackedProcs = {}

function ProcEm:GetAvailableProcs()
    local available = {}
    for procName, proc in pairs(ProcEmData.Procs) do
        table.insert(available, procName)
    end
    table.sort(available)
    return available
end

function ProcEm:CreateConfigRow(index)
    local yOffset = -50 - ((index - 1) * 35)

    local dropdown = CreateFrame("Frame", "ProcEmConfigDropdown"..tostring(index), ProcEmConfigFrame)
    dropdown:SetWidth(200)
    dropdown:SetHeight(25)
    dropdown:SetPoint("TOPLEFT", ProcEmConfigFrame, "TOPLEFT", 20, yOffset)
    dropdown:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })

    local text = dropdown:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    text:SetPoint("LEFT", dropdown, "LEFT", 8, 0)
    text:SetText("Click to select...")
    text:SetFont("Fonts\\FRIZQT__.TTF", 9)
    dropdown.text = text

    local button = CreateFrame("Button", nil, dropdown)
    button:SetWidth(200)
    button:SetHeight(25)
    button:SetPoint("CENTER", dropdown, "CENTER")
    button:RegisterForClicks("LeftButtonUp")
    button:SetScript("OnClick", function()
        ProcEm:ShowProcSelection(index)
    end)
    dropdown.button = button

    local enableCheck = CreateFrame("CheckButton", "ProcEmConfigCheck"..tostring(index), ProcEmConfigFrame, "UICheckButtonTemplate")
    enableCheck:SetWidth(24)
    enableCheck:SetHeight(24)
    enableCheck:SetPoint("LEFT", dropdown, "RIGHT", 8, 0)
    enableCheck:SetScript("OnClick", function()
        local procName = ProcEm.trackedProcs[index]
        if procName and ProcEmData.Procs[procName] then
            local enabled = this:GetChecked() == 1
            ProcEmData.Procs[procName].enabled = enabled
            ProcEm:SaveProcSettings()

            if enabled then
                if not ProcEm.sessionProcs[procName] then
                    ProcEm.sessionProcs[procName] = {count = 0, lastProc = 0}
                end
            else
                ProcEm.sessionProcs[procName] = nil
            end
        end
    end)

    local soundCheck = CreateFrame("CheckButton", "ProcEmConfigSoundCheck"..tostring(index), ProcEmConfigFrame, "UICheckButtonTemplate")
    soundCheck:SetWidth(24)
    soundCheck:SetHeight(24)
    soundCheck:SetPoint("LEFT", enableCheck, "RIGHT", 8, 0)
    soundCheck:SetScript("OnClick", function()
        local procName = ProcEm.trackedProcs[index]
        if procName then
            local soundEnabled = this:GetChecked() == 1
            if not ProcEmDB.procSounds then
                ProcEmDB.procSounds = {}
            end
            if not ProcEmDB.procSounds[procName] then
                ProcEmDB.procSounds[procName] = {}
            end
            ProcEmDB.procSounds[procName].enabled = soundEnabled
            ProcEm:RefreshConfigUI()
        end
    end)

    local soundDropdown = CreateFrame("Frame", "ProcEmConfigSoundDropdown"..tostring(index), ProcEmConfigFrame)
    soundDropdown:SetWidth(60)
    soundDropdown:SetHeight(25)
    soundDropdown:SetPoint("LEFT", soundCheck, "RIGHT", 8, 0)
    soundDropdown:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })

    local soundText = soundDropdown:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    soundText:SetPoint("CENTER", soundDropdown, "CENTER")
    soundText:SetText("1")
    soundText:SetFont("Fonts\\FRIZQT__.TTF", 9)
    soundDropdown.text = soundText

    local soundButton = CreateFrame("Button", nil, soundDropdown)
    soundButton:SetWidth(60)
    soundButton:SetHeight(25)
    soundButton:SetPoint("CENTER", soundDropdown, "CENTER")
    soundButton:RegisterForClicks("LeftButtonUp")
    soundButton:SetScript("OnClick", function()
        ProcEm:ShowSoundSelection(index)
    end)
    soundDropdown.button = soundButton

    local testButton = CreateFrame("Button", "ProcEmConfigTestButton"..tostring(index), ProcEmConfigFrame, "GameMenuButtonTemplate")
    testButton:SetWidth(40)
    testButton:SetHeight(22)
    testButton:SetPoint("LEFT", soundDropdown, "RIGHT", 5, 0)
    testButton:SetText("Test")
    testButton:SetScript("OnClick", function()
        local procName = ProcEm.trackedProcs[index]
        if procName and ProcEmDB.procSounds and ProcEmDB.procSounds[procName] then
            local soundNum = ProcEmDB.procSounds[procName].soundNum or 1
            PlaySoundFile("Interface\\AddOns\\ProcEm\\sound\\" .. tostring(soundNum) .. ".mp3")
        end
    end)

    return {
        dropdown = dropdown,
        enableCheck = enableCheck,
        soundCheck = soundCheck,
        soundDropdown = soundDropdown,
        testButton = testButton,
        text = text,
        soundText = soundText
    }
end

function ProcEm:ShowSoundSelection(rowIndex)
    if ProcEm.soundSelectionFrame then
        ProcEm.soundSelectionFrame:Hide()
    end

    local frame = CreateFrame("Frame", "ProcEmSoundSelectionFrame", UIParent)
    frame:SetWidth(150)
    frame:SetHeight(200)
    frame:SetPoint("CENTER", UIParent, "CENTER")
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetFrameStrata("DIALOG")
    frame.rowIndex = rowIndex

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", frame, "TOP", 0, -15)
    title:SetText("Sound")

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)

    local yPos = -45

    for i = 1, 5 do
        local btn = CreateFrame("Button", nil, frame)
        btn:SetWidth(120)
        btn:SetHeight(20)
        btn:SetPoint("TOP", frame, "TOP", 0, yPos)

        local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        btnText:SetPoint("CENTER", btn, "CENTER")
        btnText:SetText("Sound " .. tostring(i))

        btn:SetScript("OnClick", function()
            ProcEm:SelectSound(rowIndex, i)
            frame:Hide()
        end)

        btn:SetScript("OnEnter", function()
            btnText:SetTextColor(1, 1, 0)
        end)

        btn:SetScript("OnLeave", function()
            btnText:SetTextColor(1, 1, 1)
        end)

        yPos = yPos - 25
    end

    frame:Show()
    ProcEm.soundSelectionFrame = frame
end

function ProcEm:SelectSound(rowIndex, soundNum)
    local procName = ProcEm.trackedProcs[rowIndex]
    if procName then
        if not ProcEmDB.procSounds then
            ProcEmDB.procSounds = {}
        end
        if not ProcEmDB.procSounds[procName] then
            ProcEmDB.procSounds[procName] = {}
        end
        ProcEmDB.procSounds[procName].soundNum = soundNum
        ProcEm:RefreshConfigUI()
    end
end

function ProcEm:ShowProcSelection(rowIndex)
    if ProcEm.selectionFrame then
        ProcEm.selectionFrame:Hide()
    end

    local frame = CreateFrame("Frame", "ProcEmSelectionFrame", UIParent)
    frame:SetWidth(200)
    frame:SetHeight(400)
    frame:SetPoint("CENTER", UIParent, "CENTER")
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetFrameStrata("DIALOG")
    frame.rowIndex = rowIndex

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", frame, "TOP", 0, -15)
    title:SetText("Select Proc")

    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)

    local availableProcs = ProcEm:GetAvailableProcs()
    local yPos = -45

    for i = 1, getn(availableProcs) do
        local procName = availableProcs[i]
        local btn = CreateFrame("Button", nil, frame)
        btn:SetWidth(180)
        btn:SetHeight(18)
        btn:SetPoint("TOP", frame, "TOP", 0, yPos)

        local btnText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        btnText:SetPoint("LEFT", btn, "LEFT", 5, 0)
        btnText:SetText(procName)
        btnText:SetFont("Fonts\\FRIZQT__.TTF", 9)

        btn:SetScript("OnClick", function()
            ProcEm:SelectProc(rowIndex, procName)
            frame:Hide()
        end)

        btn:SetScript("OnEnter", function()
            btnText:SetTextColor(1, 1, 0)
        end)

        btn:SetScript("OnLeave", function()
            btnText:SetTextColor(1, 1, 1)
        end)

        yPos = yPos - 20

        if yPos < -370 then
            break
        end
    end

    frame:Show()
    ProcEm.selectionFrame = frame
end

function ProcEm:SelectProc(rowIndex, procName)
    ProcEm.trackedProcs[rowIndex] = procName

    if not ProcEmDB.trackedProcs then
        ProcEmDB.trackedProcs = {}
    end
    ProcEmDB.trackedProcs[rowIndex] = procName

    ProcEm:RefreshConfigUI()
end

function ProcEm:RefreshConfigUI()
    if not ProcEmConfigFrame or not ProcEmConfigFrame:IsVisible() then
        return
    end

    if getn(ProcEm.configRows) == 0 then
        for i = 1, ProcEm.MAX_TRACKED_PROCS do
            ProcEm.configRows[i] = ProcEm:CreateConfigRow(i)
        end
    end

    if ProcEmDB.trackedProcs then
        for i = 1, ProcEm.MAX_TRACKED_PROCS do
            local procName = ProcEmDB.trackedProcs[i]
            if procName then
                ProcEm.trackedProcs[i] = procName
            end
        end
    end

    for i = 1, ProcEm.MAX_TRACKED_PROCS do
        local row = ProcEm.configRows[i]
        local procName = ProcEm.trackedProcs[i]

        if procName and ProcEmData.Procs[procName] then
            local proc = ProcEmData.Procs[procName]
            row.text:SetText(procName)
            row.enableCheck:SetChecked(proc.enabled)
            row.enableCheck:Show()

            if ProcEmDB.procSounds and ProcEmDB.procSounds[procName] then
                row.soundCheck:SetChecked(ProcEmDB.procSounds[procName].enabled)
                if ProcEmDB.procSounds[procName].soundNum then
                    row.soundText:SetText(tostring(ProcEmDB.procSounds[procName].soundNum))
                end
                row.soundCheck:Show()
                row.soundDropdown:Show()
                row.testButton:Show()
            else
                row.soundCheck:SetChecked(false)
                row.soundText:SetText("1")
                row.soundCheck:Show()
                row.soundDropdown:Show()
                row.testButton:Show()
            end
        else
            row.text:SetText("Click to select...")
            row.enableCheck:Hide()
            row.soundCheck:Hide()
            row.soundDropdown:Hide()
            row.testButton:Hide()
        end
    end
end

function ProcEm:UpdateDisplay()
    if not ProcEmFrame or not ProcEmFrame:IsVisible() then
        return
    end

    local bossText = _G["ProcEmFrame_BossName"]
    if bossText then
        if self.currentBoss then
            bossText:SetText("|cffff8000vs " .. tostring(self.currentBoss) .. "|r")
        else
            bossText:SetText("")
        end
    end

    local displayList = {}
    for procName, data in pairs(self.sessionProcs) do
        if data.count > 0 then
            local proc = ProcEmData.Procs[procName]
            if proc then
                table.insert(displayList, {
                    name = procName,
                    count = data.count,
                    lastProc = data.lastProc,
                    color = proc.color or {1, 1, 1}
                })
            end
        end
    end

    table.sort(displayList, function(a, b)
        return a.count > b.count
    end)

    local numProcs = getn(displayList)
    local numVisible = 12

    for i = 1, numVisible do
        local rowName = "ProcEmFrame_Row" .. tostring(i)
        local row = _G[rowName]

        if not row then
            row = ProcEmFrame:CreateFontString(rowName, "OVERLAY", "GameFontNormal")
            row:SetFont("Fonts\\FRIZQT__.TTF", 11)
            row:SetWidth(200)
            row:SetHeight(16)
            row:SetJustifyH("LEFT")

            if i == 1 then
                row:SetPoint("TOPLEFT", ProcEmFrame, "TOPLEFT", 15, -50)
            else
                row:SetPoint("TOPLEFT", "ProcEmFrame_Row" .. tostring(i-1), "BOTTOMLEFT", 0, -3)
            end
        end

        if i <= numProcs then
            local entry = displayList[i]
            local r, g, b = entry.color[1], entry.color[2], entry.color[3]

            local text = tostring(entry.name) .. ": " .. tostring(entry.count)
            row:SetText(text)
            row:SetTextColor(r, g, b)
            row:Show()
        else
            row:Hide()
        end
    end
end

function ProcEm:InitDisplay()
    if ProcEmDB.displayPosition then
        local pos = ProcEmDB.displayPosition
        ProcEmFrame:ClearAllPoints()
        ProcEmFrame:SetPoint(pos.point, UIParent, pos.point, pos.x, pos.y)
    end

    if ProcEmDB.displaySize then
        ProcEmFrame:SetWidth(ProcEmDB.displaySize[1])
        ProcEmFrame:SetHeight(ProcEmDB.displaySize[2])
    end

    if ProcEmDB.displayAlpha then
        ProcEmFrame:SetAlpha(ProcEmDB.displayAlpha)
    end

    if ProcEmDB.configSize and ProcEmConfigFrame then
        ProcEmConfigFrame:SetWidth(ProcEmDB.configSize[1])
        ProcEmConfigFrame:SetHeight(ProcEmDB.configSize[2])
    end

    if ProcEmConfigFrame_AlphaSlider then
        ProcEmConfigFrame_AlphaSlider:SetValue((ProcEmDB.displayAlpha or 1.0) * 100)
    end

    if ProcEmDB.displayLocked then
        ProcEmFrame:EnableMouse(false)
    else
        ProcEmFrame:EnableMouse(true)
    end
end
