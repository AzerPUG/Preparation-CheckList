if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end
if AZP.OnLoad == nil then AZP.OnLoad = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end
if AZP.OnEvent == nil then AZP.OnEvent = {} end

AZP.VersionControl.PreparationCheckList = 24
if AZP.PreparationChecklist == nil then AZP.PreparationChecklist = {} end

local itemCheckListFrame
local AZPPCLSelfOptionPanel = nil
local optionHeader = "|cFF00FFFFPreparation CheckList|r"

function AZP.VersionControl:PreparationCheckList()
    return AZP.VersionControl.PreparationCheckList
end

function AZP.PreparationCheckList:OnLoadBoth()

end

function AZP.PreparationCheckList:OnLoadCore()
    AZP.PreparationCheckList:OnLoadBoth()

    AZP.OptionsPanels:Generic("Preparation CheckList", optionHeader, function (frame)
        AZP.PreparationCheckList:FillOptionsPanel(frame)
    end)
end

function AZP.PreparationCheckList:OnLoadSelf()
    AZPPCLSelfOptionPanel = CreateFrame("FRAME", nil)
    AZPPCLSelfOptionPanel.name = optionHeader
    InterfaceOptions_AddCategory(AZPPCLSelfOptionPanel)
    AZPPCLSelfOptionPanel.header = AZPPCLSelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPPCLSelfOptionPanel.header:SetPoint("TOP", 0, -10)
    AZPPCLSelfOptionPanel.header:SetText("|cFF00FFFFAzerPUG's Preparation CheckList Options!|r")

    AZPPCLSelfOptionPanel.footer = AZPPCLSelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    AZPPCLSelfOptionPanel.footer:SetPoint("TOP", 0, -300)
    AZPPCLSelfOptionPanel.footer:SetText(
        "|cFF00FFFFAzerPUG Links:\n" ..
        "Website: www.azerpug.com\n" ..
        "Discord: www.azerpug.com/discord\n" ..
        "Twitch: www.twitch.tv/azerpug\n|r"
    )

    -- Remove button and make dynamic. On bag change event, maybe?
    -- create frame for Preparation CheckList non-core
    CheckButton = CreateFrame("Button", nil, AZP.Core.AddOns.PCL.MainFrame, "UIPanelButtonTemplate")
    CheckButton.contentText = CheckButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    CheckButton.contentText:SetText("Check Items!")
    CheckButton:SetWidth("100")
    CheckButton:SetHeight("25")
    CheckButton.contentText:SetWidth("100")
    CheckButton.contentText:SetHeight("15")
    CheckButton:SetPoint("TOPLEFT", 5, -5)
    CheckButton.contentText:SetPoint("CENTER", 0, -1)
    CheckButton:SetScript("OnClick", function() 
        for itemID, val in pairs(AIUCheckedData["checkItemIDs"]) do
            if val == true then
                AIUCheckedData["checkItemIDs"][itemID] = 1
            end
        end
        AZP.PreparationCheckList:getItemsCheckListFrame()
    end )
    AZP.PreparationCheckList:initializeConfig()
    AZP.PreparationCheckList:OnLoadBoth()
end

function AZP.PreparationCheckList:ChangeOptionsText()
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

function AZP.PreparationCheckList:initializeConfig()
    if AIUCheckedData == nil then
        AIUCheckedData = AZP.PreparationChecklist.initialConfig
    end
    AZP.PreparationCheckList:createTreeGroupList();
end

function AZP.OnEvent:PreparationCheckList(event, ...)
end

function AZP.PreparationCheckList:createTreeGroupList()
    local scrollFrame = CreateFrame("ScrollFrame", "scrollFrame", CheckListSubPanel, "UIPanelScrollFrameTemplate");
    scrollFrame:SetSize(600, 500)
    scrollFrame:SetPoint("TOPLEFT", -2, -60)
    local scrollPanel = CreateFrame("Frame", "scrollPanel")
    scrollPanel:SetSize(500, 1000)
    scrollPanel:SetPoint("TOP")
    scrollFrame:SetScrollChild(scrollPanel)
    local lastFrame = nil

    for _, itemSections in ipairs(AZP.itemData) do
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
                AZP.PreparationCheckList:tryGetItemID(itemID, parentFrame)
            end
        end
    end
end

function AZP.PreparationCheckList:tryGetItemID(itemID, parentFrame)
    local itemName, itemIcon = AZP.AddonHelper:GetItemNameAndIcon(itemID)
    if itemName == nil then
        AZP.AddonHelper:DelayedExecution(5, (function()
            itemName, itemIcon = AZP.AddonHelper:GetItemNameAndIcon(itemID)
            if itemName == nil then
                AZP.PreparationCheckList:tryGetItemID(itemID, parentFrame)
            else
                AZP.PreparationCheckList:drawCheckboxItem(itemID, parentFrame, itemName, itemIcon)
            end
        end))
    else
        AZP.PreparationCheckList:drawCheckboxItem(itemID, parentFrame, itemName, itemIcon)
    end
end

function AZP.PreparationCheckList:drawCheckboxItem(itemID, parentFrame, itemName, itemIcon)
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

function AZP.PreparationCheckList:getItemsCheckListFrame()
    local i = 0
    if itemCheckListFrame ~= nil then
        itemCheckListFrame:Hide()
        itemCheckListFrame:SetParent(nil)
    end
    itemCheckListFrame = CreateFrame("Frame", "itemCheckListFrame", AZP.Core.AddOns.PCL.MainFrame)
    itemCheckListFrame:SetSize(400, 300)
    itemCheckListFrame:SetPoint("TOPLEFT")

    local ench = 0
    local enchFrame = CreateFrame("Frame", "enchFrame", itemCheckListFrame)
    enchFrame:SetPoint("TOPLEFT")
    enchFrame.contentText = enchFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    enchFrame.contentText:SetPoint("CENTER")

    --local itemLink = GetInventoryItemLink("Player", 16)
    --local _, _, _, _, _, Enchant, Gem1, Gem2, Gem3, Gem4 = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*)")
    --print("Info: " .. itemLink .. dash .. Enchant .. dash .. Gem1 .. dash .. Gem2 .. dash .. Gem3 .. dash .. Gem4)

    -- /script _, _, _, _, _, enchantID = string.find(GetInventoryItemLink("Player", 16), "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*)"); print(enchantID);

    --  GemsSStats:     Crit       Mast        Haste       Vers
    --  GemIDs:         ??????     ??????      ??????      ??????

    -- Ring Enchants (SlotID: 11/12)
    -- Crit -   Haste   -   Mast    -   Vers
    -- 6164 -   6166    -   ????    -   6170
    --
    -- Wep Enchants (SlotID: 16/17)
    -- Stats    -   ConeDPS -   Heal    -   HealTaken   -   DmgIncrease
    -- 6229     -   6223    -   6226    -   ????        -   6229
    --
    -- Wep Enchants - DK (SlotID: 16/17)
    -- Crusader -   Razorice    -   Gargoyle (2h)   -   Sanguination    -   Apocalypse      -   Thirst
    -- 3368     -   3370        -   3847            -   6241            -   6245            -   6244
    --
    -- Chest Enchants (SlotID: 5)
    -- Stats    -   Dmg     -   IntDmg  -   Mana    -   Armor
    -- 6230     -   6214    -   ????    -   ????    -   ????
    --
    -- Cloak Enchants  (SlotID: 15)
    -- Stam -   StamSpeed   -   StamLeech   -   StamAvoid
    -- ???? -   6202        -   6204        -   6203

    local itemText = "\124cFF00FF00All Best Enchants/Gems Detected!\124r"
    local itemTextB = ""
    local itemLink, enchantID

    itemLink = GetInventoryItemLink("Player", 5)
    if itemLink ~= nil then
        _, _, _, _, _, enchantID = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*)")
        if enchantID ~= "6230" and enchantID ~= "6214" then
            itemText = "\124cFFFF0000Low/No Enchants/Gems Detected!\124r"
            itemTextB = itemTextB .. " \124cFFFF0000Chest\124r"
        end
    end

    itemLink = GetInventoryItemLink("Player", 11)
    if itemLink ~= nil then
        _, _, _, _, _, enchantID = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*)")
        if enchantID ~= "6164" and enchantID ~= "6166" and enchantID ~= "6170" then
            itemText = "\124cFFFF0000Low/No Enchants/Gems Detected!\124r"
            itemTextB = itemTextB .. " \124cFFFF0000Ring1\124r"
        end
    end

    itemLink = GetInventoryItemLink("Player", 12)
    if itemLink ~= nil then
        _, _, _, _, _, enchantID = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*)")
        if enchantID ~= "6164" and enchantID ~= "6166" and enchantID ~= "6170" then
            itemText = "\124cFFFF0000Low/No Enchants/Gems Detected!\124r"
            itemTextB = itemTextB .. " \124cFFFF0000Ring2\124r"
        end
    end

    itemLink = GetInventoryItemLink("Player", 15)
    if itemLink ~= nil then
        _, _, _, _, _, enchantID = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*)")
        if enchantID ~= "6202" and enchantID ~= "6204" and enchantID ~= "6203" then
            itemText = "\124cFFFF0000Low/No Enchants/Gems Detected!\124r"
            itemTextB = itemTextB .. " \124cFFFF0000Ring1\124r"
        end
    end

    itemLink = GetInventoryItemLink("Player", 16)
    if itemLink ~= nil then
        _, _, _, _, _, enchantID = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*)")
        if enchantID ~= "6229" and enchantID ~= "6223" and enchantID ~= "6226" and enchantID ~= "6229" and enchantID ~= "3368" and enchantID ~= "3370" and enchantID ~= "3847" and enchantID ~= "6241" and enchantID ~= "6245" and enchantID ~= "6244" then
            itemText = "\124cFFFF0000Low/No Enchants/Gems Detected!\124r"
            itemTextB = itemTextB .. " \124cFFFF0000MainHand\124r"
        end
    end

    itemLink = GetInventoryItemLink("Player", 17)
    if itemLink ~= nil then
        local _, _, _, _, _, _, v7 = GetItemInfo(itemLink)
        if v7 ~= "Miscellaneous" then
            _, _, _, _, _, enchantID = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*)")
            if enchantID ~= "6229" and enchantID ~= "6223" and enchantID ~= "6226" and enchantID ~= "6229" and enchantID ~= "3368" and enchantID ~= "3370" and enchantID ~= "3847" and enchantID ~= "6241" and enchantID ~= "6245" and enchantID ~= "6244" then
                itemText = "\124cFFFF0000Low/No Enchants/Gems Detected!\124r"
                itemTextB = itemTextB .. " \124cFFFF0000OffHand\124r"
            end
        end
    end

    for slotID = 6, 10 do
        itemLink = GetInventoryItemLink("Player", slotID)
        if itemLink ~= nil then
            local _, _, _, _, _, _, Gem1, Gem2, Gem3, Gem4 = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*)")
            local stats =  GetItemStats(itemLink)
            local socks
            if stats["EMPTY_SOCKET_PRISMATIC"] ~= nil then 
                socks = stats["EMPTY_SOCKET_PRISMATIC"]
                if Gem1 ~= "168639" and Gem1 ~= "168640" and Gem1 ~= "168641" and Gem1 ~= "168642" and Gem1 ~= "153709" and Gem1 ~= "168638" and Gem1 ~= "153708" and Gem1 ~= "168637" and Gem1 ~= "153707" and Gem1 ~= "168636" then
                    itemText = "\124cFFFF0000Low/No Enchants/Gems Detected!\124r"
                    local itemTextC
                    if slotID == 6 then 
                        itemTextC = " \124cFFFF0000Waist\124r"
                    elseif slotID == 7 then
                        itemTextC = " \124cFFFF0000Legs\124r"
                    elseif slotID == 8 then
                        itemTextC = " \124cFFFF0000Feet\124r"
                    elseif slotID == 9 then
                        itemTextC = " \124cFFFF0000Wrist\124r"
                    elseif slotID == 10 then 
                        itemTextC = " \124cFFFF0000Hands\124r"
                    end
                    itemTextB = itemTextB .. itemTextC
                end
            end
        end
    end

    itemLink = GetInventoryItemLink("Player", 16)
    if itemLink ~= nil then
        local _, _, _, _, _, _, Gem1, Gem2, Gem3, Gem4 = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*)")
        local stats =  GetItemStats(itemLink)
        local socks
        if stats["EMPTY_SOCKET_PRISMATIC"] ~= nil then
            socks = stats["EMPTY_SOCKET_PRISMATIC"]
            if Gem1 ~= "168639" and Gem1 ~= "168640" and Gem1 ~= "168641" and Gem1 ~= "168642" and Gem1 ~= "153709" and Gem1 ~= "168638" and Gem1 ~= "153708" and Gem1 ~= "168637" and Gem1 ~= "153707" and Gem1 ~= "168636" then
                itemText = "\124cFFFF0000Low/No Enchants/Gems Detected!\124r"
                itemTextB = itemTextB .. " \124cFFFF0000MainHand\124r"
            end
        end
    end

    itemLink = GetInventoryItemLink("Player", 17)
    if itemLink ~= nil then
        local _, _, _, _, _, _, Gem1, Gem2, Gem3, Gem4 = string.find(itemLink, "|?c?f?f?(%x*)|?H?([^:]*):?(%d+):?(%d*):?(%d*):?(%d*):?(%d*):?(%d*)")
        local stats =  GetItemStats(itemLink)
        local socks
        if stats["EMPTY_SOCKET_PRISMATIC"] ~= nil then 
            socks = stats["EMPTY_SOCKET_PRISMATIC"]
            if Gem1 ~= "168639" and Gem1 ~= "168640" and Gem1 ~= "168641" and Gem1 ~= "168642" and Gem1 ~= "153709" and Gem1 ~= "168638" and Gem1 ~= "153708" and Gem1 ~= "168637" and Gem1 ~= "153707" and Gem1 ~= "168636" then
                itemText = "\124cFFFF0000Low/No Enchants/Gems Detected!\124r"
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

    for _, section in ipairs(AZP.itemData) do
        for _, stat in ipairs(section[2]) do
            for _, itemID in ipairs(stat[2]) do
                if AIUCheckedData["checkItemIDs"][itemID] ~= nil then
                    i = i + 1
                    local itemName, itemIcon = AZP.AddonHelper:GetItemNameAndIcon(itemID)
                    local parentFrame = CreateFrame("Frame", "parentFrame", itemCheckListFrame)
                    parentFrame:SetSize(300, 20)
                    parentFrame:SetPoint("TOPLEFT", 15, -20 * i - 15)

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

if not IsAddOnLoaded("AzerPUG's Core") then
    AZP.PreparationCheckList:OnLoadSelf()
end