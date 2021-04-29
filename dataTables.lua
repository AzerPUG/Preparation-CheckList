if AZP == nil then AZP = {} end
if AZP.PreparationCheckList == nil then AZP.PreparationCheckList = {} end

AZP.PreparationCheckList.initialConfig =
{
    ["checkItemIDs"] = {}
}

if AZP.PreparationCheckList.ItemData == nil then
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
                {"Int", {171273}},
                {"Agi", {171270}},
                {"Str", {171275}},
                {"Stam", {171274}},
                {"Armor", {171271}},
                {"Mana/Heal", {171268, 171272, 176811, 171350}},
                {"Health", {171267, 171269}},
                {"Other", {183823, 184090, 171266, 171370, 171263, 171264, 171349, 171352, 171351}}
            }
        },
        {
            "Runes",
            {
                {"Augment", {181468}},
                {"Vantus", {171203}}
            }
        }
    }
end