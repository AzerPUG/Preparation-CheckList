if AZP == nil then AZP = {} end
if AZP.VersionControl == nil then AZP.VersionControl = {} end

AZP.VersionControl["Preparation CheckList"] = 29
if AZP.PreparationCheckList == nil then AZP.PreparationCheckList = {} end
if AZP.PreparationCheckList.Events == nil then AZP.PreparationCheckList.Events = {} end

local itemCheckListFrame
local AZPPCLSelfOptionPanel = nil
local optionPanel = nil
local optionHeader = "|cFF00FFFFPreparation CheckList|r"
local PreparationCheckListSelfFrame
local EventFrame, UpdateFrame
local HaveShowedUpdateNotification = false
local scrollFrameHeight = 0

function AZP.PreparationCheckList:OnLoadBoth(frame)
    CheckButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    CheckButton.contentText = CheckButton:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    CheckButton.contentText:SetText("Check Items!")
    CheckButton:SetWidth("100")
    CheckButton:SetHeight("25")
    CheckButton.contentText:SetWidth("100")
    CheckButton.contentText:SetHeight("15")
    CheckButton:SetPoint("TOPLEFT", 5, -5)
    CheckButton.contentText:SetPoint("CENTER", 0, -1)
    CheckButton:SetScript("OnClick", function() 
        for itemID, val in pairs(AZPPCLCheckedData["checkItemIDs"]) do
            if val == true then
                AZPPCLCheckedData["checkItemIDs"][itemID] = 1
            end
        end
        AZP.PreparationCheckList:getItemsCheckListFrame(frame)
    end )
end

function AZP.PreparationCheckList:OnLoadCore()
    AZP.PreparationCheckList:OnLoadBoth(AZP.Core.AddOns.PCL.MainFrame)
    AZP.Core:RegisterEvents("VARIABLES_LOADED", function() AZP.PreparationCheckList.Events:VariablesLoaded() end)

    scrollFrameHeight = 350

    AZP.OptionsPanels:RemovePanel("Preparation CheckList")
    AZP.OptionsPanels:Generic("Preparation CheckList", optionHeader, function(frame)
        AZP.PreparationCheckList:FillOptionsPanel(frame)
    end)
end

function AZP.PreparationCheckList:OnLoadSelf()
    C_ChatInfo.RegisterAddonMessagePrefix("AZPVERSIONS")

    EventFrame = CreateFrame("Frame")
    EventFrame:SetScript("OnEvent", function(...) AZP.PreparationCheckList:OnEvent(...) end)
    EventFrame:RegisterEvent("VARIABLES_LOADED")
    EventFrame:RegisterEvent("CHAT_MSG_ADDON")
    EventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")

    UpdateFrame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    UpdateFrame:SetPoint("CENTER", 0, 250)
    UpdateFrame:SetSize(400, 200)
    UpdateFrame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    UpdateFrame:SetBackdropColor(0.25, 0.25, 0.25, 0.80)
    UpdateFrame.header = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalHuge")
    UpdateFrame.header:SetPoint("TOP", 0, -10)
    UpdateFrame.header:SetText("|cFFFF0000AzerPUG's Preparation CheckList is out of date!|r")

    UpdateFrame.text = UpdateFrame:CreateFontString("UpdateFrame", "ARTWORK", "GameFontNormalLarge")
    UpdateFrame.text:SetPoint("TOP", 0, -40)
    UpdateFrame.text:SetText("Error!")

    UpdateFrame:Hide()

    AZPPCLSelfOptionPanel = CreateFrame("FRAME", nil)
    AZPPCLSelfOptionPanel.name = optionHeader
    InterfaceOptions_AddCategory(AZPPCLSelfOptionPanel)
    AZPPCLSelfOptionPanel.header = AZPPCLSelfOptionPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalHuge")
    AZPPCLSelfOptionPanel.header:SetPoint("TOP", 0, -10)
    AZPPCLSelfOptionPanel.header:SetText("|cFF00FFFFAzerPUG's Preparation CheckList Options!|r")

    PreparationCheckListSelfFrame = CreateFrame("FRAME", nil, UIParent, "BackdropTemplate")
    PreparationCheckListSelfFrame:SetBackdrop({
            bgFile = "Interface/Tooltips/UI-Tooltip-Background",
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            edgeSize = 12,
            insets = { left = 1, right = 1, top = 1, bottom = 1 },
        })
    PreparationCheckListSelfFrame:SetBackdropColor(0.75, 0.75, 0.75, 0.5)
    PreparationCheckListSelfFrame:SetSize(325, 220)
    PreparationCheckListSelfFrame:SetPoint("CENTER", 0, 0)
    PreparationCheckListSelfFrame:SetScript("OnDragStart", PreparationCheckListSelfFrame.StartMoving)
    PreparationCheckListSelfFrame:SetScript("OnDragStop", function()
        PreparationCheckListSelfFrame:StopMovingOrSizing()
        AZP.PreparationCheckList:SaveMainFrameLocation()
    end)
    PreparationCheckListSelfFrame:RegisterForDrag("LeftButton")
    PreparationCheckListSelfFrame:EnableMouse(true)
    PreparationCheckListSelfFrame:SetMovable(true)

    local IUAddonFrameCloseButton = CreateFrame("Button", nil, PreparationCheckListSelfFrame, "UIPanelCloseButton")
    IUAddonFrameCloseButton:SetSize(20, 21)
    IUAddonFrameCloseButton:SetPoint("TOPRIGHT", PreparationCheckListSelfFrame, "TOPRIGHT", 2, 2)
    IUAddonFrameCloseButton:SetScript("OnClick", function() AZP.PreparationCheckList:ShowHideFrame() end )

    scrollFrameHeight = 500

    AZP.PreparationCheckList:FillOptionsPanel(AZPPCLSelfOptionPanel)
    AZP.PreparationCheckList:OnLoadBoth(PreparationCheckListSelfFrame)
end

function AZP.PreparationCheckList:ShowHideFrame()
    if PreparationCheckListSelfFrame:IsShown() then
        PreparationCheckListSelfFrame:Hide()
        AZPPCLShown = false
    elseif not PreparationCheckListSelfFrame:IsShown() then
        PreparationCheckListSelfFrame:Show()
        AZPPCLShown = true
    end
end

function AZP.PreparationCheckList:SaveMainFrameLocation()
    local temp = {}
    temp[1], temp[2], temp[3], temp[4], temp[5] = PreparationCheckListSelfFrame:GetPoint()
    AZPPCLLocation = temp
end

function AZP.PreparationCheckList:createTreeGroupList(panel)
    local scrollFrame = CreateFrame("ScrollFrame", "scrollFrame", panel, "UIPanelScrollFrameTemplate");
    scrollFrame:SetSize(600, scrollFrameHeight)
    scrollFrame:SetPoint("TOPLEFT", -2, -35)
    local scrollPanel = CreateFrame("Frame", "scrollPanel")
    scrollPanel:SetSize(500, 1000)
    scrollPanel:SetPoint("TOP")
    scrollFrame:SetScrollChild(scrollPanel)
    local lastFrame = nil

    for _, itemSections in ipairs(AZP.PreparationCheckList.ItemData) do
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

function AZP.PreparationCheckList:GetItemNameAndIcon(itemID)
    local itemName, _, _, _, _, _, _, _, _, itemIcon = GetItemInfo(itemID)
    return itemName, itemIcon
end

function AZP.PreparationCheckList:tryGetItemID(itemID, parentFrame)
    local itemName, itemIcon = AZP.PreparationCheckList:GetItemNameAndIcon(itemID)
    if itemName == nil then
        C_Timer.After(5, function()
            itemName, itemIcon = AZP.PreparationCheckList:GetItemNameAndIcon(itemID)
            if itemName == nil then
                AZP.PreparationCheckList:tryGetItemID(itemID, parentFrame)
            else
                AZP.PreparationCheckList:drawCheckboxItem(itemID, parentFrame, itemName, itemIcon)
            end
        end)
    else
        AZP.PreparationCheckList:drawCheckboxItem(itemID, parentFrame, itemName, itemIcon)
    end
end

function AZP.PreparationCheckList:drawCheckboxItem(itemID, parentFrame, itemName, itemIcon)
    local itemCheckBox = CreateFrame("CheckButton", "itemCheckBox", parentFrame, "ChatConfigCheckButtonTemplate")
    itemCheckBox:SetSize(20, 20)
    itemCheckBox:SetPoint("LEFT", 5, 0)
    itemCheckBox:SetHitRectInsets(0, 0, 0, 0)

    itemCheckBox:SetChecked(AZPPCLCheckedData["checkItemIDs"][itemID])
    local itemCountEditBox
    itemCheckBox:SetScript("OnClick", function()
        if itemCheckBox:GetChecked() == true then
            itemCountEditBox:SetEnabled(true)
        elseif itemCheckBox:GetChecked() == false then
            AZPPCLCheckedData["checkItemIDs"][itemID] = nil
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
        if AZPPCLCheckedData["checkItemIDs"][itemID] ~= nil then
            itemCountEditBox:SetText(tostring(AZPPCLCheckedData["checkItemIDs"][itemID]))
        else
            itemCountEditBox:SetEnabled(false)
        end
    end)
    itemCountEditBox:SetScript("OnEditFocusLost", function() AZPPCLCheckedData["checkItemIDs"][itemID] = tonumber(itemCountEditBox:GetText(), 10) end)

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

function AZP.PreparationCheckList:getItemsCheckListFrame(mainFrame)
    local i = 0
    if itemCheckListFrame ~= nil then
        itemCheckListFrame:Hide()
        itemCheckListFrame:SetParent(nil)
    end
    itemCheckListFrame = CreateFrame("Frame", "itemCheckListFrame", mainFrame)
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

    for _, section in ipairs(AZP.PreparationCheckList.ItemData) do
        for _, stat in ipairs(section[2]) do
            for _, itemID in ipairs(stat[2]) do
                if AZPPCLCheckedData["checkItemIDs"][itemID] ~= nil then
                    i = i + 1
                    local itemName, itemIcon = AZP.PreparationCheckList:GetItemNameAndIcon(itemID)
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
                        itemCountLabel.contentText:SetText("\124cFFFF0000" .. iCountCurrent .. "/" .. AZPPCLCheckedData["checkItemIDs"][itemID] .. "\124r")
                    elseif GetItemCount(itemID) < AZPPCLCheckedData["checkItemIDs"][itemID] then
                        itemCountLabel.contentText:SetText("\124cFFFF8800" .. iCountCurrent .. "/" ..  AZPPCLCheckedData["checkItemIDs"][itemID] .. "\124r")
                    else
                        itemCountLabel.contentText:SetText("\124cFF00FF00" .. iCountCurrent .. "/" .. AZPPCLCheckedData["checkItemIDs"][itemID] .. "\124r")
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

function AZP.PreparationCheckList.Events:VariablesLoaded()
    if AZPPCLCheckedData == nil then
        AZPPCLCheckedData = AZP.PreparationCheckList.initialConfig
    end
    AZP.PreparationCheckList:createTreeGroupList(optionPanel);
end

function AZP.PreparationCheckList.Events:VariablesLoadedLocation()
    if AZPPCLShown == false then
        PreparationCheckListSelfFrame:Hide()
    end

    if AZPPCLLocation == nil then
        AZPPCLLocation = {"CENTER", nil, nil, 200, 0}
    end
    PreparationCheckListSelfFrame:SetPoint(AZPPCLLocation[1], AZPPCLLocation[4], AZPPCLLocation[5])
end

function AZP.PreparationCheckList:FillOptionsPanel(frameToFill)
    optionPanel = frameToFill
    frameToFill:Hide()
end

function AZP.PreparationCheckList:DelayedExecution(delayTime, delayedFunction)
    local frame = CreateFrame("Frame")
    frame.start_time = GetServerTime()
    frame:SetScript("OnUpdate",
        function(self)
            if GetServerTime() - self.start_time > delayTime then
                delayedFunction()
                self:SetScript("OnUpdate", nil)
                self:Hide()
            end
        end
    )
    frame:Show()
end

function AZP.PreparationCheckList:ShareVersion() -- Change DelayedExecution to native WoW Function.
    local versionString = string.format("|PCL:%d|", AZP.VersionControl["Preparation CheckList"])
    AZP.PreparationCheckList:DelayedExecution(10, function()
        if UnitInBattleground("player") ~= nil then
            -- BG stuff?
        else
            if IsInGroup() then
                if IsInRaid() then
                    C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"RAID", 1)
                else
                    C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"PARTY", 1)
                end
            end
            if IsInGuild() then
                C_ChatInfo.SendAddonMessage("AZPVERSIONS", versionString ,"GUILD", 1)
            end
        end
    end)
end

function AZP.PreparationCheckList:ReceiveVersion(version)
    if version > AZP.VersionControl["Preparation CheckList"] then
        if (not HaveShowedUpdateNotification) then
            HaveShowedUpdateNotification = true
            UpdateFrame:Show()
            UpdateFrame.text:SetText(
                "Please download the new version through the CurseForge app.\n" ..
                "Or use the CurseForge website to download it manually!\n\n" .. 
                "Newer Version: v" .. version .. "\n" .. 
                "Your version: v" .. AZP.VersionControl["Preparation CheckList"]
            )
        end
    end
end

function AZP.PreparationCheckList:GetSpecificAddonVersion(versionString, addonWanted)
    local pattern = "|([A-Z]+):([0-9]+)|"
    local index = 1
    while index < #versionString do
        local _, endPos = string.find(versionString, pattern, index)
        local addon, version = string.match(versionString, pattern, index)
        index = endPos + 1
        if addon == addonWanted then
            return tonumber(version)
        end
    end
end

function AZP.PreparationCheckList:OnEvent(self, event, ...)
    if event == "VARIABLES_LOADED" then
        AZP.PreparationCheckList.Events:VariablesLoaded()
        AZP.PreparationCheckList.Events:VariablesLoadedLocation()
        AZP.PreparationCheckList:ShareVersion()
    elseif event == "GROUP_ROSTER_UPDATE" then
        AZP.PreparationCheckList:ShareVersion()
    elseif event == "CHAT_MSG_ADDON" then
        local prefix, payload, _, sender = ...
        if prefix == "AZPVERSIONS" then
            local version = AZP.PreparationCheckList:GetSpecificAddonVersion(payload, "PCL")
            if version ~= nil then
                AZP.PreparationCheckList:ReceiveVersion(version)
            end
        end
    end
end

if not IsAddOnLoaded("AzerPUGsCore") then
    AZP.PreparationCheckList:OnLoadSelf()
end

AZP.SlashCommands["PCL"] = function()
    if PreparationCheckListSelfFrame ~= nil then AZP.PreparationCheckList:ShowHideFrame() end
end

AZP.SlashCommands["pcl"] = AZP.SlashCommands["PCL"]
AZP.SlashCommands["check"] = AZP.SlashCommands["PCL"]
AZP.SlashCommands["preparation check list"] = AZP.SlashCommands["PCL"]