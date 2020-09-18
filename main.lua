local GlobalAddonName, AIU = ...

local AZPIUCheckListVersion = 0.9
local dash = " - "
local name = "InstanceUtility" .. dash .. "CheckList"
local nameFull = ("AzerPUG " .. name)
local promo = (nameFull .. dash ..  AZPIUCheckListVersion)
local addonMain = LibStub("AceAddon-3.0"):NewAddon("InstanceUtility-CheckList", "AceConsole-3.0")

local itemCheckListFrame
local itemData = AIU.itemData
local initialConfig = AIU.initialConfig

function AZP.IU.VersionControl:CheckList()
    return AZPIUCheckListVersion
end

function AZP.IU.OnLoad:CheckList(self)
    addonMain:ChangeOptionsText()

    CheckButton = CreateFrame("Button", "CheckButton", InstanceUtilityAddonFrame, "UIPanelButtonTemplate")
    CheckButton.contentText = CheckButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    CheckButton.contentText:SetText("Check Items!")
    CheckButton:SetWidth("100")
    CheckButton:SetHeight("25")
    CheckButton.contentText:SetWidth("100")
    CheckButton.contentText:SetHeight("15")
    CheckButton:SetPoint("TOPLEFT", 5, -100)
    CheckButton.contentText:SetPoint("CENTER", 0, -1)
    CheckButton:SetScript("OnClick", function() 
        -- Migrate from checked boolean to nr of wanted items
        for itemID, val in pairs(AIUCheckedData["checkItemIDs"]) do
            if val == true then
                AIUCheckedData["checkItemIDs"][itemID] = 1
            end
        end
        addonMain:getItemsCheckListFrame()
    end )
    addonMain:initializeConfig()
end

function addonMain:ChangeOptionsText()
    CheckListSubPanelPHTitle:Hide()
    CheckListSubPanelPHText:Hide()
    CheckListSubPanelPHTitle:SetParent(nil)
    CheckListSubPanelPHText:SetParent(nil)

    local CheckListSubPanelHeader = CheckListSubPanel:CreateFontString("CheckListSubPanelHeader", "ARTWORK", "GameFontNormalHuge")
    CheckListSubPanelHeader:SetText(promo)
    CheckListSubPanelHeader:SetWidth(CheckListSubPanel:GetWidth())
    CheckListSubPanelHeader:SetHeight(CheckListSubPanel:GetHeight())
    CheckListSubPanelHeader:SetPoint("TOP", 0, -10)
end

function addonMain:initializeConfig()
    if AIUCheckedData == nil then
        AIUCheckedData = initialConfig
    end
    addonMain:createTreeGroupList();
end

function AZP.IU.OnEvent:CheckList(event, ...)
end

function addonMain:createTreeGroupList()
    local scrollFrame = CreateFrame("ScrollFrame", "scrollFrame", CheckListSubPanel, "UIPanelScrollFrameTemplate");
    scrollFrame:SetSize(600, 500)
    scrollFrame:SetPoint("TOPLEFT", -2, -60)
    local scrollPanel = CreateFrame("Frame", "scrollPanel")
    scrollPanel:SetSize(500, 1000)
    scrollPanel:SetPoint("TOP")
    scrollFrame:SetScrollChild(scrollPanel)
    local lastFrame = nil

    for _, itemSections in ipairs(itemData) do
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
    local itemName, itemIcon = AZP.AddonHelper:GetItemNameAndIcon(itemID)
    if itemName == nil then
        AZP.AddonHelper:DelayedExecution(5, (function()
            itemName, itemIcon = AZP.AddonHelper:GetItemNameAndIcon(itemID)
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
    itemCheckBox:SetHitRectInsets(0, 0, 0, 0)

    itemCheckBox:SetChecked(AIUCheckedData["checkItemIDs"][itemID])
    local itemCountEditBox
    itemCheckBox:SetScript("OnClick", function()
        if itemCheckBox:GetChecked() == true then
            itemCountEditBox:SetEnabled(true)
        elseif itemCheckBox:GetChecked() == false then
            AIUCheckedData["checkItemIDs"][itemID] = nil
            itemCountEditBox:SetEnabled(false)
            itemCountEditBox:SetText("")
        end
    end)

    itemCountEditBox = CreateFrame("EditBox", "ItemCountEditBox" .. tostring(itemId), parentFrame, "InputBoxTemplate")
    itemCountEditBox:SetSize(25, 15)
    itemCountEditBox:SetWidth(25)
    itemCountEditBox:SetScale(0.75)
    itemCountEditBox:SetPoint("LEFT", 40, 0)
    itemCountEditBox:SetAutoFocus(false)
    itemCountEditBox:SetNumeric(true)
    itemCountEditBox:SetScript("OnShow", function ()
        if AIUCheckedData["checkItemIDs"][itemID] ~= nil then
            itemCountEditBox:SetText(tostring(AIUCheckedData["checkItemIDs"][itemID]))
        else
            itemCountEditBox:SetEnabled(false)
        end
    end)
    itemCountEditBox:SetScript("OnEditFocusLost", function() AIUCheckedData["checkItemIDs"][itemID] = tonumber(itemCountEditBox:GetText(), 10) end)

    local itemIconLabel = CreateFrame("Frame", "checkIcon", parentFrame)
    itemIconLabel:SetSize(15, 15)
    itemIconLabel:SetPoint("TOPLEFT", 65, 0)
    itemIconLabel.texture = itemIconLabel:CreateTexture(nil, "BACKGROUND")
    itemIconLabel.texture:SetPoint("LEFT", 0, 0)
    itemIconLabel.texture:SetTexture(itemIcon)
    itemIconLabel.texture:SetSize(15, 15)

    local itemNameLabel = CreateFrame("Frame", "itemNameLabel", parentFrame)
    itemNameLabel:SetSize(175, 10)
    itemNameLabel:SetPoint("TOPLEFT", 85, -2)
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

    local ench = 0
    local enchFrame = CreateFrame("Frame", "enchFrame", itemCheckListFrame)
    enchFrame:SetPoint("TOPLEFT", 0, -30)
    enchFrame.contentText = enchFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    enchFrame.contentText:SetPoint("CENTER")

    --local _, _, _, _, _, Enchant, Gem1, Gem2, Gem3, Gem4 = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*)")
    -- /script _, _, _, _, _, enchantID = string.find(GetInventoryItemLink("Player", 16), "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*)"); print(enchantID);

    -- 11 == ring1      12 == ring2     16 == MH    17 == OH (Sometime need to check OH...?)
    -- GetItemInfo(), 7th return == itemType?
    -- Ring Enchants
    -- Crit -   Haste   -   Mast    -   Vers
    -- 6108 -   6109    -   6110    -   6111
    --
    -- Wep Enchants
    -- Heal -   Leech   -   Elem    -   AtkSpd  -   Vers    -   Haste   -   Mast    -   Crit    -   Armor
    -- 5946 -   5948    -   5949    -   5950    -   5962    -   5963    -   5964    -   5965    -   5966

    local itemText = "\124cFF00FF00All Best Enchants Detected!\124r"
    local itemTextB = ""
    local itemLink, enchantID

    itemLink = GetInventoryItemLink("Player", 11)
    _, _, _, _, _, enchantID = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*)")
    if enchantID ~= "6108" and enchantID ~= "6109" and enchantID ~= "6110" and enchantID ~= "6111" then
        itemText = "\124cFFFF0000Low/No Enchants Detected!\124r"
        itemTextB = "\124cFFFF0000Ring1\124r"
    end

    itemLink = GetInventoryItemLink("Player", 12)
    _, _, _, _, _, enchantID = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*)")
    if enchantID ~= "6108" and enchantID ~= "6109" and enchantID ~= "6110" and enchantID ~= "6111" then
        itemText = "\124cFFFF0000Low/No Enchants Detected!\124r"
        itemTextB = itemTextB .. " \124cFFFF0000Ring2\124r"
    end

    itemLink = GetInventoryItemLink("Player", 16)
    _, _, _, _, _, enchantID = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*)")
    if enchantID ~= "5946" and enchantID ~= "5948" and enchantID ~= "5949" and enchantID ~= "5950" and enchantID ~= "5962" and enchantID ~= "5963" and enchantID ~= "5964" and enchantID ~= "5965" and enchantID ~= "5966" then
        itemText = "\124cFFFF0000Low/No Enchants Detected!\124r"
        itemTextB = itemTextB .. " \124cFFFF0000MainHand\124r"
    end

    itemLink = GetInventoryItemLink("Player", 17)
    if itemLink ~= nil then
        local v1, v2, v3, v4, v5, v6, v7 = GetItemInfo(itemLink)
        if v7 ~= "Miscellaneous" then
            _, _, _, _, _, enchantID = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*)")
            if enchantID ~= "5946" and enchantID ~= "5948" and enchantID ~= "5949" and enchantID ~= "5950" and enchantID ~= "5962" and enchantID ~= "5963" and enchantID ~= "5964" and enchantID ~= "5965" and enchantID ~= "5966" then
                itemText = "\124cFFFF0000Low/No Enchants Detected!\124r"
                itemTextB = itemTextB .. " \124cFFFF0000OffHand\124r"
            end
        end
    end

    if itemTextB ~= "" then
        itemText = itemText .. "\n" .. itemTextB
    end

    enchFrame.contentText:SetText(itemText)
    enchFrame:SetSize(400, 40)
    enchFrame.contentText:SetSize(enchFrame:GetWidth(), enchFrame:GetHeight())

    for _, section in ipairs(itemData) do
        for _, stat in ipairs(section[2]) do
            for _, itemID in ipairs(stat[2]) do
                if AIUCheckedData["checkItemIDs"][itemID] ~= nil then
                    i = i + 1
                    local itemName, itemIcon = AZP.AddonHelper:GetItemNameAndIcon(itemID)
                    local parentFrame = CreateFrame("Frame", "parentFrame", itemCheckListFrame)
                    parentFrame:SetSize(300, 20)
                    parentFrame:SetPoint("TOPLEFT", 115, -20 * i - 45)

                    local itemCountLabel = CreateFrame("Frame", "itemCountLabel", parentFrame)
                    itemCountLabel:SetSize(20, 15)
                    itemCountLabel:SetPoint("LEFT")
                    itemCountLabel.contentText = itemCountLabel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
                    itemCountLabel.contentText:SetPoint("CENTER")
                    local iCountCurrent = GetItemCount(itemID)
                    if GetItemCount(itemID) == 0 then
                        itemCountLabel.contentText:SetText("\124cFFFF0000" .. iCountCurrent .. "/" .. AIUCheckedData["checkItemIDs"][itemID] .. "\124r")
                    elseif GetItemCount(itemID) < AIUCheckedData["checkItemIDs"][itemID] then
                        itemCountLabel.contentText:SetText("\124cFFFF8800" .. iCountCurrent .. "/" ..  AIUCheckedData["checkItemIDs"][itemID] .. "\124r")
                    else
                        itemCountLabel.contentText:SetText("\124cFF00FF00" .. iCountCurrent .. "/" .. AIUCheckedData["checkItemIDs"][itemID] .. "\124r")
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