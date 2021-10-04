if AZP == nil then AZP = {} end
if AZP.PreparationCheckList == nil then AZP.PreparationCheckList = {} end

AZP.PreparationCheckList.initialConfig =
{
    ["checkItemIDs"] = {}
}

AZP.PreparationCheckList.ItemData =
{
    {
        "Flasks",
        {
            {"Power", {171276}},
            {"Stamina", {171278}},
        },
    },
    {
        "Food",
        {
            {"Feast", {172043, 172042}},
            {"Versatility", {172051, 172050}},
            {"Haste", {172045, 172044}},
            {"Mastery", {172049, 172048}},
            {"Critical Strike", {172041, 172040}},
            {"Stamina", {172069, 172068}},
            {"Mana", {172047, 172046}},
            {"Speed", {172063}},
            {"Heal OOC", {172061}},
            {"Cone Dmg", {172062}},
        }
    },
    {
        "Potions",
        {
            {"Intellect", {171273}},
            {"Agility", {171270}},
            {"Strength", {171275}},
            {"Stamina", {171274}},
            {"Armor", {171271}},
            {"Mana/Heal", {171268, 171272, 176811, 171350}},
            {"Health", {171267, 171269}},
            {"Other", {183823, 184090, 171266, 171370, 171263, 171264, 171349, 171352, 171351}},
        }
    },
    {
        "Runes",
        {
            {"Augment", {181468}},
            {"Vantus", {186662}},
        }
    },
    {
        "Other",
        {
            {"Auto Hammer", {132514}},
        }
    }
}

AZP.PreparationCheckList.EnchantData =
{
    EnchantSlots = {5, 11, 12, 15, 16, 17},      -- Later add Feet (8), Wrist (8) and Hands (10)
    [5] =
    {
        [6230] = "Eternal Stats",
        [6265] = "Eternal Insight",
        [6214] = "Eternal Skirmisher",
        [6217] = "Eternal Bounds",
        [6213] = "Eternal Bulwark",
    },
    [11] =
    {
        [6164] =    "Crit", -- 6264
        [6166] =   "Haste", -- 6266
        [6168] = "Mastery", -- 6268
        [6170] =    "Vers", -- 6270
    },
    [12] =
    {
        [6164] =    "Crit", -- 6264
        [6166] =   "Haste", -- 6266
        [6168] = "Mastery", -- 6268
        [6170] =    "Vers", -- 6270
    },
    [15] =
    {
        [6208] = "Soul Vitality",
        [6204] = "Fortified Leech",
        [6202] = "Fortified Speed",
        [6203] = "Fortified Avoidance",
    },
    [16] =
    {
        [6229] = "Celestial Guidance",
        [6223] = "Lightless Force",
        [6226] = "Eternal Grace",
        [6227] = "Ascended Vigor",
        [6228] = "Sinful Revelation",
        [3368] = "Crusader",
        [3370] = "Razorice",
        [3847] = "Gargoyle (2h)",
        [6241] = "Sanguination",
        [6245] = "Apocalypse",
        [6244] = "Thirst",
    },
    [17] =
    {
        [6229] = "Celestial Guidance",
        [6223] = "Lightless Force",
        [6226] = "Eternal Grace",
        [6227] = "Ascended Vigor",
        [6228] = "Sinful Revelation",
        [3368] = "Crusader",
        [3370] = "Razorice",
        [3847] = "Gargoyle (2h)",
        [6241] = "Sanguination",
        [6245] = "Apocalypse",
        [6244] = "Thirst",
    },
}

AZP.PreparationCheckList.SlotData =
{
     [1] = "Head",
     [2] = "Neck",
     [3] = "Shoulder",
     [5] = "Chest",
     [6] = "Waist",
     [7] = "Legs",
     [8] = "Feet",
     [9] = "Wrist",
    [10] = "Hands",
    [11] = "Ring1",
    [12] = "Ring2",
    [13] = "Trinket1",
    [14] = "Trinket2",
    [15] = "Back",
    [16] = "MainHand",
    [17] = "OffHand",
}

AZP.PreparationCheckList.SocketData =
{
    SocketSlots = {1, 2, 3, 5, 6, 8, 9, 10, 11, 12, 15},
    [173127] = "Crit",
    [173128] = "Haste",
    [173129] = "Vers",
    [173130] = "Mastery",
}