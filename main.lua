local GlobalAddonName, AIU = ...

local addonChannelName = "AZP-IT-AC"
local OptionsSubPanelChecklist
local itemCheckListFrame
local addonLoaded = false
local itemData = AIU.itemData
local initialConfig = AIU.initialConfig

local AZPIUCheckListVersion = "v0.3"
local dash = " - "
local name = "InstanceUtility" .. dash .. " CheckList"
local nameFull = ("AzerPUG " .. name)
local nameShort = "AIU-CL"
local promo = (nameFull .. dash ..  AZPIUCheckListVersion)

local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility-CheckList", "AceConsole-3.0")

function addonMain:OnLoad(self)
    local InstanceUtilityAddonFrame = CreateFrame("FRAME", "InstanceUtilityAddonFrame", UIParent)
    InstanceUtilityAddonFrame:SetPoint("CENTER", 0, 0)
    InstanceUtilityAddonFrame.texture = InstanceUtilityAddonFrame:CreateTexture()
    InstanceUtilityAddonFrame.texture:SetAllPoints(true)
    InstanceUtilityAddonFrame:EnableMouse(true)
    InstanceUtilityAddonFrame:SetMovable(true)
    InstanceUtilityAddonFrame:SetScript("OnEvent", function(...) addonMain:OnEvent(...) end)
    InstanceUtilityAddonFrame:RegisterForDrag("LeftButton")
    InstanceUtilityAddonFrame:SetScript("OnDragStart", InstanceUtilityAddonFrame.StartMoving)
    InstanceUtilityAddonFrame:SetScript("OnDragStop", InstanceUtilityAddonFrame.StopMovingOrSizing)
    InstanceUtilityAddonFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    InstanceUtilityAddonFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    InstanceUtilityAddonFrame:RegisterEvent("PLAYER_LOGIN")
    InstanceUtilityAddonFrame:RegisterEvent("ADDON_LOADED")
    InstanceUtilityAddonFrame:SetSize(400, 250)
    InstanceUtilityAddonFrame.texture:SetColorTexture(0.5, 0.5, 0.5, 0.5)

    local AddonTitle = InstanceUtilityAddonFrame:CreateFontString("AddonTitle", "ARTWORK", "GameFontNormal")
    AddonTitle:SetText(nameFull)
    AddonTitle:SetHeight("10")
    AddonTitle:SetPoint("TOP", "InstanceUtilityAddonFrame", -100, -3)

    TempTestButton1 = CreateFrame("Button", "TempTestButton1", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    TempTestButton1.contentText = TempTestButton1:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    TempTestButton1.contentText:SetText("Check Items!")
    TempTestButton1:SetWidth("100")
    TempTestButton1:SetHeight("25")
    TempTestButton1.contentText:SetWidth("100")
    TempTestButton1.contentText:SetHeight("15")
    TempTestButton1:SetPoint("TOP", 125, -25)
    TempTestButton1.contentText:SetPoint("CENTER", 0, -1)
    TempTestButton1:SetScript("OnClick", function() addonMain:checkListButtonClicked() end )

    ReloadButton = CreateFrame("Button", "ReloadButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    ReloadButton.contentText = ReloadButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    ReloadButton.contentText:SetText("Reload!")
    ReloadButton:SetWidth("100")
    ReloadButton:SetHeight("25")
    ReloadButton.contentText:SetWidth("100")
    ReloadButton.contentText:SetHeight("15")
    ReloadButton:SetPoint("TOP", 125, -50)
    ReloadButton.contentText:SetPoint("CENTER", 0, -1)
    ReloadButton:SetScript("OnClick", function() ReloadUI(); end )

    OptionsSubPanelChecklist = CreateFrame("FRAME", "AZP-IU-OptionsSubPanelChecklist")
    OptionsSubPanelChecklist.name = "Checklist"
    OptionsSubPanelChecklist.parent = OptionsSubPanelChecklist
    InterfaceOptions_AddCategory(OptionsSubPanelChecklist);

    OpenSettingsButton = CreateFrame("Button", "OpenSettingsButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    OpenSettingsButton.contentText = OpenSettingsButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    OpenSettingsButton.contentText:SetText("Open Options!")
    OpenSettingsButton:SetWidth("100")
    OpenSettingsButton:SetHeight("25")
    OpenSettingsButton.contentText:SetWidth("100")
    OpenSettingsButton.contentText:SetHeight("15")
    OpenSettingsButton:SetPoint("TOP", 125, -75)
    OpenSettingsButton.contentText:SetPoint("CENTER", 0, -1)
    OpenSettingsButton:SetScript("OnClick", function() InterfaceOptionsFrame_OpenToCategory(OptionsSubPanelChecklist); InterfaceOptionsFrame_OpenToCategory(OptionsSubPanelChecklist); end )

    AZPReadyCheckButton = CreateFrame("Button", "AZPReadyCheckButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    AZPReadyCheckButton.contentText = AZPReadyCheckButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    AZPReadyCheckButton.contentText:SetText("Ready Check!")
    AZPReadyCheckButton:SetWidth("100")
    AZPReadyCheckButton:SetHeight("25")
    AZPReadyCheckButton.contentText:SetWidth("100")
    AZPReadyCheckButton.contentText:SetHeight("15")
    AZPReadyCheckButton:SetPoint("TOP", 125, -100)
    AZPReadyCheckButton.contentText:SetPoint("CENTER", 0, -1)
    AZPReadyCheckButton:SetScript("OnClick", function() DoReadyCheck() end )

    local OptionsSubChecklistHeader = OptionsSubPanelChecklist:CreateFontString("OptionsSubChecklistHeader", "ARTWORK", "GameFontNormalHuge")
    OptionsSubChecklistHeader:SetText(promo)
    OptionsSubChecklistHeader:SetWidth(OptionsSubPanelChecklist:GetWidth())
    OptionsSubChecklistHeader:SetHeight(OptionsSubPanelChecklist:GetHeight())
    OptionsSubChecklistHeader:SetPoint("TOP", 0, -10)

    local OptionsSubChecklistSubHeader = OptionsSubPanelChecklist:CreateFontString("OptionsSubChecklistSubHeader", "ARTWORK", "GameFontNormalHuge")
    OptionsSubChecklistSubHeader:SetText("Checklist Options")
    OptionsSubChecklistSubHeader:SetWidth(OptionsSubPanelChecklist:GetWidth())
    OptionsSubChecklistSubHeader:SetHeight(OptionsSubPanelChecklist:GetHeight() - 10)
    OptionsSubChecklistSubHeader:SetPoint("TOP", 0, -40)
end

function addonMain:initConfigSection()
    addonMain:createTreeGroupList();
end

function addonMain:initializeConfig()
    if AIUCheckedData == nil then
        AIUCheckedData = initialConfig
    end
    addonMain:initConfigSection()
end

function addonMain:OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
    elseif event == "PLAYER_LOGIN" then
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
    elseif event == "ADDON_LOADED" then
        if addonLoaded == false then
            AZPAddonHelper:DelayedExecution(5, function() addonMain:initializeConfig() end)
            addonLoaded = true
        end
    end
end

function addonMain:checkListButtonClicked()     -- A function to call a function?
    addonMain:getItemsCheckListFrame()
end

function addonMain:createTreeGroupList()
    local scrollFrame = CreateFrame("ScrollFrame", "scrollFrame", OptionsSubPanelChecklist, "UIPanelScrollFrameTemplate");
    scrollFrame:SetSize(600, 500)
    scrollFrame:SetPoint("TOPLEFT", -2, -60)
    local scrollPanel = CreateFrame("Frame", "scrollPanel")
    scrollPanel:SetSize(500, 1000)
    scrollPanel:SetPoint("TOP")
    scrollFrame:SetScrollChild(scrollPanel)
    local lastFrame = nil

    for _, itemSections in pairs(itemData) do
        local sectionHeaderFrame = CreateFrame("Frame", "sectionHeaderFrame", scrollPanel)
        sectionHeaderFrame.contentText = sectionHeaderFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        sectionHeaderFrame.contentText:SetPoint("TOPLEFT", 10, 0)
        sectionHeaderFrame.contentText:SetText(itemSections[1])
        sectionHeaderFrame:SetSize(400, 20)

        if lastFrame == nil then
            sectionHeaderFrame:SetPoint("TOPLEFT", 0, 0)
        else
            sectionHeaderFrame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", -25, 0)
        end

        lastFrame = sectionHeaderFrame

        for j,itemSection in ipairs(itemSections[2]) do
            local sectionFrame = CreateFrame("Frame", "sectionFrame", scrollPanel)
            if lastFrame:GetName() == "sectionHeaderFrame" then
                sectionFrame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 25, 0)
            else
                sectionFrame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, 0)
            end
            sectionFrame:SetSize(400, 30 + 20 * #itemSection[2])
            lastFrame = sectionFrame
            sectionFrame.contentText = sectionFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            sectionFrame.contentText:SetPoint("TOPLEFT", 10, 0)
            sectionFrame.contentText:SetText(itemSection[1])
            for i,itemID in ipairs(itemSection[2]) do
                local parentFrame = CreateFrame("Frame", "parentFrame", sectionFrame)
                parentFrame:SetSize(500,20)
                parentFrame:SetPoint("TOPLEFT", 25, i * -20 + 5)
                addonMain:tryGetItemID(itemID, parentFrame)
            end
        end
    end
end

function addonMain:tryGetItemID(itemID, parentFrame)
    local itemName, itemIcon = AZPAddonHelper:GetItemNameAndIcon(itemID)
    if itemName == nil then
        AZPAddonHelper:DelayedExecution(5, (function()
            itemName, itemIcon = AZPAddonHelper:GetItemNameAndIcon(itemID)
            if itemName == nil then
                addonMain:tryGetItemID(itemID, parentFrame)
            else
                addonMain:drawCheckboxItem(itemID, parentFrame, itemName, itemIcon)
            end
        end))
    else
        addonMain:drawCheckboxItem(itemID, parentFrame, itemName, itemIcon)
    end
end

function addonMain:drawCheckboxItem(itemID, parentFrame, itemName, itemIcon)
    local itemCheckBox = CreateFrame("CheckButton", "itemCheckBox", parentFrame, "ChatConfigCheckButtonTemplate")
    itemCheckBox:SetSize(20, 20)
    itemCheckBox:SetPoint("LEFT", 5, 0)
    itemCheckBox:SetChecked(AIUCheckedData["checkItemIDs"][itemID])
    itemCheckBox:SetScript("OnClick", function()
        if itemCheckBox:GetChecked() == true then
            AIUCheckedData["checkItemIDs"][itemID] = true
        elseif itemCheckBox:GetChecked() == false then
            AIUCheckedData["checkItemIDs"][itemID] = nil
        end
    end)

    local itemIconLabel = CreateFrame("Frame", "checkIcon", parentFrame)
    itemIconLabel:SetSize(15, 15)
    itemIconLabel:SetPoint("TOPLEFT", 35, 0)
    itemIconLabel.texture = itemIconLabel:CreateTexture(nil, "BACKGROUND")
    itemIconLabel.texture:SetPoint("LEFT", 0, 0)
    itemIconLabel.texture:SetTexture(itemIcon)
    itemIconLabel.texture:SetSize(15, 15)

    local itemNameLabel = CreateFrame("Frame", "itemNameLabel", parentFrame)
    itemNameLabel:SetSize(175, 10)
    itemNameLabel:SetPoint("TOPLEFT", 55, -2)
    itemNameLabel.contentText = itemNameLabel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    itemNameLabel.contentText:SetPoint("LEFT", 0, 0)
    itemNameLabel.contentText:SetText(itemName)

    itemCheckBox:SetScript("OnEnter", function()
        GameTooltip:SetOwner(itemCheckBox)
        GameTooltip:SetItemByID(itemID)
        GameTooltip:SetSize(200, 200)
        GameTooltip:Show()
    end)
    itemCheckBox:SetScript("OnLeave", function() GameTooltip:Hide() end)

    itemIconLabel:SetScript("OnEnter", function()
        GameTooltip:SetOwner(itemIconLabel)
        GameTooltip:SetItemByID(itemID)
        GameTooltip:SetSize(200, 200)
        GameTooltip:Show()
    end)
    itemIconLabel:SetScript("OnLeave", function() GameTooltip:Hide() end)

    itemNameLabel:SetScript("OnEnter", function()
        GameTooltip:SetOwner(itemNameLabel)
        GameTooltip:SetItemByID(itemID)
        GameTooltip:SetSize(200, 200)
        GameTooltip:Show()
    end)
    itemNameLabel:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

function addonMain:getItemsCheckListFrame()
    local i = 0
    if itemCheckListFrame ~= nil then
        itemCheckListFrame:Hide()
        itemCheckListFrame:SetParent(nil)
    end
    itemCheckListFrame = CreateFrame("Frame", "itemCheckListFrame", InstanceUtilityAddonFrame)
    itemCheckListFrame:SetSize(400, 300)
    itemCheckListFrame:SetPoint("TOPLEFT")
    for _, section in ipairs(itemData) do
        for _, stat in ipairs(section[2]) do
            for _, itemID in ipairs(stat[2]) do
                if AIUCheckedData["checkItemIDs"][itemID] ~= nil then
                    i = i + 1
                    local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
                    local parentFrame = CreateFrame("Frame", "parentFrame", itemCheckListFrame)
                    parentFrame:SetSize(300,20)
                    parentFrame:SetPoint("TOPLEFT", 10, -20 * i)

                    local itemCountLabel = CreateFrame("Frame", "itemCountLabel", parentFrame)
                    itemCountLabel:SetSize(20, 15)
                    itemCountLabel:SetPoint("LEFT")
                    itemCountLabel.contentText = itemCountLabel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                    itemCountLabel.contentText:SetPoint("CENTER")
                    local iCountCurrent = GetItemCount(itemID)
                    if (GetItemCount(itemID) == 0) then
                        itemCountLabel.contentText:SetText("\124cFFFF0000" .. iCountCurrent .. "\124r")
                    else
                        itemCountLabel.contentText:SetText("\124cFF00FF00" .. iCountCurrent .. "\124r")
                    end

                    local itemIconLabel = CreateFrame("Frame", "checkIcon", parentFrame)
                    itemIconLabel:SetSize(15, 15)
                    itemIconLabel:SetPoint("LEFT", 25, 0)
                    itemIconLabel.texture = itemIconLabel:CreateTexture(nil, "BACKGROUND")
                    itemIconLabel.texture:SetPoint("LEFT", 0, 0)
                    itemIconLabel.texture:SetTexture(itemIcon)
                    itemIconLabel.texture:SetSize(15, 15)

                    local itemNameLabel = CreateFrame("Frame", "itemNameLabel", parentFrame)
                    itemNameLabel:SetSize(175, 15)
                    itemNameLabel:SetPoint("LEFT", 45, 0)
                    itemNameLabel.contentText = itemNameLabel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                    itemNameLabel.contentText:SetPoint("LEFT", 0, 0)
                    itemNameLabel.contentText:SetText(itemName)

                    itemIconLabel:SetScript("OnEnter", function()
                        GameTooltip:SetOwner(itemIconLabel)
                        GameTooltip:SetItemByID(itemID)
                        GameTooltip:SetSize(200, 200)
                        GameTooltip:Show()
                    end)
                    itemIconLabel:SetScript("OnLeave", function() GameTooltip:Hide() end)

                    itemNameLabel:SetScript("OnEnter", function()
                        GameTooltip:SetOwner(itemNameLabel)
                        GameTooltip:SetItemByID(itemID)
                        GameTooltip:SetSize(200, 200)
                        GameTooltip:Show()
                    end)
                    itemNameLabel:SetScript("OnLeave", function() GameTooltip:Hide() end)
                end
            end
        end
    end
end

addonMain:OnLoad()