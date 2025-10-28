-- Local references
local getn = table.getn

-- Configuration state
ProcEm.configCheckboxes = {}
ProcEm.NUM_PROC_BUTTONS = 20

-- Create checkbox rows
function ProcEm:CreateConfigCheckboxes()
    for i = 1, self.NUM_PROC_BUTTONS do
        local checkbox = CreateFrame("CheckButton", "ProcEmConfigCheckbox" .. tostring(i), ProcEmConfigFrame_ScrollFrame, "OptionsCheckButtonTemplate")
        checkbox:SetWidth(400)
        checkbox:SetHeight(20)

        -- Position
        if i == 1 then
            checkbox:SetPoint("TOPLEFT", ProcEmConfigFrame_ScrollFrame, "TOPLEFT", 10, -5)
        else
            checkbox:SetPoint("TOPLEFT", "ProcEmConfigCheckbox" .. tostring(i-1), "BOTTOMLEFT", 0, -2)
        end

        -- Label
        local label = _G["ProcEmConfigCheckbox" .. tostring(i) .. "Text"]
        if label then
            label:SetFont("Fonts\\FRIZQT__.TTF", 11)
            label:SetTextColor(1, 1, 1)
        end

        -- Click handler
        checkbox:SetScript("OnClick", function()
            local procName = this.procName
            if procName and ProcEmData.Procs[procName] then
                local enabled = this:GetChecked() == 1
                ProcEmData.Procs[procName].enabled = enabled
                ProcEm:SaveProcSettings()

                -- Update session tracking
                if enabled then
                    if not ProcEm.sessionProcs[procName] then
                        ProcEm.sessionProcs[procName] = {count = 0, lastProc = 0}
                    end
                else
                    ProcEm.sessionProcs[procName] = nil
                end

                ProcEm:Debug("Proc " .. tostring(procName) .. " " .. (enabled and "enabled" or "disabled"))
            end
        end)

        self.configCheckboxes[i] = checkbox
    end
end

-- Refresh configuration UI
function ProcEm:RefreshConfigUI()
    if not ProcEmConfigFrame or not ProcEmConfigFrame:IsVisible() then
        return
    end

    -- Create checkboxes if needed
    if getn(self.configCheckboxes) == 0 then
        self:CreateConfigCheckboxes()
    end

    -- Build sorted proc list
    local procList = {}
    for procName, proc in pairs(ProcEmData.Procs) do
        table.insert(procList, {name = procName, data = proc})
    end

    -- Sort by category then name
    table.sort(procList, function(a, b)
        if a.data.category ~= b.data.category then
            return a.data.category < b.data.category
        end
        return a.name < b.name
    end)

    local numProcs = getn(procList)
    local scrollOffset = FauxScrollFrame_GetOffset(ProcEmConfigFrame_ScrollFrame)

    -- Update scroll frame
    FauxScrollFrame_Update(ProcEmConfigFrame_ScrollFrame, numProcs, self.NUM_PROC_BUTTONS, 20)

    -- Update checkboxes
    for i = 1, self.NUM_PROC_BUTTONS do
        local index = i + scrollOffset
        local checkbox = self.configCheckboxes[i]

        if index <= numProcs then
            local procEntry = procList[index]
            local procName = procEntry.name
            local proc = procEntry.data

            -- Set checkbox state
            checkbox:SetChecked(proc.enabled)
            checkbox.procName = procName

            -- Set label with category color
            local label = _G["ProcEmConfigCheckbox" .. tostring(i) .. "Text"]
            if label then
                local categoryColor = ""
                if proc.category == ProcEmData.CATEGORY.WEAPON then
                    categoryColor = "|cffff8000"
                elseif proc.category == ProcEmData.CATEGORY.ENCHANT then
                    categoryColor = "|cff00ff00"
                elseif proc.category == ProcEmData.CATEGORY.TALENT then
                    categoryColor = "|cff8080ff"
                elseif proc.category == ProcEmData.CATEGORY.TRINKET then
                    categoryColor = "|cfffff000"
                else
                    categoryColor = "|cffffffff"
                end

                label:SetText(categoryColor .. tostring(procName) .. "|r |cff888888[" .. tostring(proc.category) .. "]|r")
            end

            checkbox:Show()
        else
            checkbox:Hide()
        end
    end
end

-- Update main display
function ProcEm:UpdateDisplay()
    if not ProcEmFrame or not ProcEmFrame:IsVisible() then
        return
    end

    -- Update boss name
    local bossText = _G["ProcEmFrame_BossName"]
    if bossText then
        if self.currentBoss then
            bossText:SetText("|cffff8000vs " .. tostring(self.currentBoss) .. "|r")
        else
            bossText:SetText("")
        end
    end

    -- Build sorted proc list (only showing procs with counts > 0)
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

    -- Sort by count descending
    table.sort(displayList, function(a, b)
        return a.count > b.count
    end)

    local numProcs = getn(displayList)
    local scrollFrame = _G["ProcEmFrame_ScrollFrame"]
    local scrollOffset = FauxScrollFrame_GetOffset(scrollFrame)
    local numVisible = 18

    -- Update scroll frame
    FauxScrollFrame_Update(scrollFrame, numProcs, numVisible, 16)

    -- Create/update text rows
    for i = 1, numVisible do
        local index = i + scrollOffset
        local rowName = "ProcEmFrame_Row" .. tostring(i)
        local row = _G[rowName]

        if not row then
            row = ProcEmFrame:CreateFontString(rowName, "OVERLAY", "GameFontNormal")
            row:SetFont("Fonts\\FRIZQT__.TTF", 11)
            row:SetWidth(250)
            row:SetHeight(16)
            row:SetJustifyH("LEFT")

            if i == 1 then
                row:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 5, -5)
            else
                row:SetPoint("TOPLEFT", "ProcEmFrame_Row" .. tostring(i-1), "BOTTOMLEFT", 0, -2)
            end
        end

        if index <= numProcs then
            local entry = displayList[index]
            local r, g, b = entry.color[1], entry.color[2], entry.color[3]

            -- Format: "Nightfall: 15"
            local text = tostring(entry.name) .. ": " .. tostring(entry.count)
            row:SetText(text)
            row:SetTextColor(r, g, b)
            row:Show()
        else
            row:Hide()
        end
    end
end

-- Initialize display on load
function ProcEm:InitDisplay()
    -- Restore saved position
    if ProcEmDB.displayPosition then
        local pos = ProcEmDB.displayPosition
        ProcEmFrame:ClearAllPoints()
        ProcEmFrame:SetPoint(pos.point, pos.x, pos.y)
    end

    -- Set locked state
    if ProcEmDB.displayLocked then
        ProcEmFrame:EnableMouse(false)
    else
        ProcEmFrame:EnableMouse(true)
    end

    -- Show frame
    ProcEmFrame:Show()
end
