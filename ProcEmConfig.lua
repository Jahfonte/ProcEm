local getn = table.getn

ProcEm.configCheckboxes = {}
ProcEm.NUM_CONFIG_ROWS = 15

function ProcEm:CreateConfigCheckboxes()
    for i = 1, self.NUM_CONFIG_ROWS do
        local row = CreateFrame("CheckButton", "ProcEmConfigRow"..tostring(i), ProcEmConfigFrame, "OptionsCheckButtonTemplate")

        row:SetWidth(280)
        row:SetHeight(20)

        if i == 1 then
            row:SetPoint("TOPLEFT", ProcEmConfigFrame, "TOPLEFT", 20, -50)
        else
            row:SetPoint("TOPLEFT", "ProcEmConfigRow"..tostring(i-1), "BOTTOMLEFT", 0, 0)
        end

        local label = _G["ProcEmConfigRow"..tostring(i).."Text"]
        if label then
            label:SetFont("Fonts\\FRIZQT__.TTF", 10)
            label:SetTextColor(1, 1, 1)
        end

        row:SetScript("OnClick", function()
            local procName = this.procName
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

        self.configCheckboxes[i] = row
    end
end

function ProcEm:RefreshConfigUI()
    if not ProcEmConfigFrame or not ProcEmConfigFrame:IsVisible() then
        return
    end

    if getn(self.configCheckboxes) == 0 then
        self:CreateConfigCheckboxes()
    end

    if not ProcEmData or not ProcEmData.Procs then
        DEFAULT_CHAT_FRAME:AddMessage("|cffff0000ProcEm Error: ProcEmData not loaded!|r")
        return
    end

    local procList = {}
    for procName, proc in pairs(ProcEmData.Procs) do
        table.insert(procList, {name = procName, data = proc})
    end

    table.sort(procList, function(a, b)
        if a.data.category ~= b.data.category then
            return a.data.category < b.data.category
        end
        return a.name < b.name
    end)

    local numProcs = getn(procList)
    local scrollOffset = ProcEmConfigFrame.scrollOffset or 0

    local maxScroll = numProcs - self.NUM_CONFIG_ROWS
    if maxScroll < 0 then maxScroll = 0 end
    if scrollOffset > maxScroll then scrollOffset = maxScroll end
    ProcEmConfigFrame.scrollOffset = scrollOffset

    for i = 1, self.NUM_CONFIG_ROWS do
        local index = i + scrollOffset
        local row = self.configCheckboxes[i]

        if index <= numProcs then
            local procEntry = procList[index]
            local procName = procEntry.name
            local proc = procEntry.data

            row:SetChecked(proc.enabled)
            row.procName = procName

            local label = _G["ProcEmConfigRow"..tostring(i).."Text"]
            if label then
                local color = "|cffffffff"
                if proc.category == "Weapon" then
                    color = "|cffff8000"
                elseif proc.category == "Enchant" then
                    color = "|cff00ff00"
                elseif proc.category == "Talent" then
                    color = "|cff8080ff"
                elseif proc.category == "Trinket" then
                    color = "|cfffff000"
                elseif proc.category == "Ability" then
                    color = "|cffff6060"
                end

                label:SetText(color .. tostring(procName) .. "|r |cff888888[" .. tostring(proc.category) .. "]|r")
            end

            row:Show()
        else
            row:Hide()
        end
    end

    if ProcEmConfigFrame_ScrollBar then
        local thumbHeight = (self.NUM_CONFIG_ROWS / numProcs) * 100
        if thumbHeight > 100 then thumbHeight = 100 end
        if thumbHeight < 10 then thumbHeight = 10 end

        if numProcs <= self.NUM_CONFIG_ROWS then
            ProcEmConfigFrame_ScrollBar:Hide()
        else
            ProcEmConfigFrame_ScrollBar:Show()
        end
    end
end

function ProcEm:ConfigScrollUp()
    if not ProcEmConfigFrame.scrollOffset then
        ProcEmConfigFrame.scrollOffset = 0
    end

    ProcEmConfigFrame.scrollOffset = ProcEmConfigFrame.scrollOffset - 1
    if ProcEmConfigFrame.scrollOffset < 0 then
        ProcEmConfigFrame.scrollOffset = 0
    end

    self:RefreshConfigUI()
end

function ProcEm:ConfigScrollDown()
    if not ProcEmConfigFrame.scrollOffset then
        ProcEmConfigFrame.scrollOffset = 0
    end

    local numProcs = 0
    for _ in pairs(ProcEmData.Procs) do
        numProcs = numProcs + 1
    end

    local maxScroll = numProcs - self.NUM_CONFIG_ROWS
    if maxScroll < 0 then maxScroll = 0 end

    ProcEmConfigFrame.scrollOffset = ProcEmConfigFrame.scrollOffset + 1
    if ProcEmConfigFrame.scrollOffset > maxScroll then
        ProcEmConfigFrame.scrollOffset = maxScroll
    end

    self:RefreshConfigUI()
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
    local numVisible = 14

    for i = 1, numVisible do
        local rowName = "ProcEmFrame_Row" .. tostring(i)
        local row = _G[rowName]

        if not row then
            row = ProcEmFrame:CreateFontString(rowName, "OVERLAY", "GameFontNormal")
            row:SetFont("Fonts\\FRIZQT__.TTF", 10)
            row:SetWidth(200)
            row:SetHeight(14)
            row:SetJustifyH("LEFT")

            if i == 1 then
                row:SetPoint("TOPLEFT", ProcEmFrame, "TOPLEFT", 15, -60)
            else
                row:SetPoint("TOPLEFT", "ProcEmFrame_Row" .. tostring(i-1), "BOTTOMLEFT", 0, -2)
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
        ProcEmFrame:SetPoint(pos.point, pos.x, pos.y)
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
