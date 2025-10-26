NewTextureSetting = true
local kattArmor = require("libraries/KattArmor")()

kattArmor.Armor.Helmet
    :addParts(
        PModel.Upper.head.Helmet,
        PModel.Upper.head.HelmetHat
    )
    :addTrimParts(
        PModel.Upper.head.HelmetTrim,
        PModel.Upper.head.HelmetHatTrim
    )
kattArmor.Armor.Chestplate
    :addParts(
        PModel.Upper.body.Chestplate,
        PModel.Upper.body.Arms.Arm_R.RightArmArmor,
        PModel.Upper.body.Arms.Arm_R.Elbow_R.RightLimbArmor,
        PModel.Upper.body.Arms.Arm_L.LeftArmArmor,
        PModel.Upper.body.Arms.Arm_L.Elbow_L.LeftLimbArmor
    )
    :addTrimParts(
        PModel.Upper.body.ChestplateTrim,
        PModel.Upper.body.Arms.Arm_R.RightArmArmorTrim,
        PModel.Upper.body.Arms.Arm_R.Elbow_R.RightLimbArmorTrim,
        PModel.Upper.body.Arms.Arm_L.LeftArmArmorTrim,
        PModel.Upper.body.Arms.Arm_L.Elbow_L.LeftLimbArmorTrim
    )
kattArmor.Armor.Leggings
    :addParts(
        PModel.Upper.body.Belt,
        PModel.Lower.Leg_R.RightLeggingsArmor,
        PModel.Lower.Leg_R.Knee_R.RightAnkleArmor,
        PModel.Lower.Leg_L.LeftLeggingsArmor,
        PModel.Lower.Leg_L.Knee_L.LeftAnkleArmor
    )
    :addTrimParts(
        PModel.Upper.body.BeltTrim,
        PModel.Lower.Leg_R.RightLeggingsArmorTrim,
        PModel.Lower.Leg_R.Knee_R.RightAnkleArmorTrim,
        PModel.Lower.Leg_L.LeftLeggingsArmorTrim,
        PModel.Lower.Leg_L.Knee_L.LeftAnkleArmorTrim
    )
kattArmor.Armor.Boots
    :addParts(
        PModel.Lower.Leg_R.Knee_R.RightBootArmor,
        PModel.Lower.Leg_L.Knee_L.LeftBootArmor
    )
    :addTrimParts(
        PModel.Lower.Leg_R.Knee_R.RightBootArmorTrim,
        PModel.Lower.Leg_L.Knee_L.LeftBootArmorTrim
    )

local leather1 = "minecraft:textures/entity/equipment/humanoid/leather_overlay.png"
local leather2 = "minecraft:textures/entity/equipment/humanoid_leggings/leather_overlay.png"
kattArmor.Materials.leather
    :addParts("Helmet",
        PModel.Upper.head.HelmetLeather:setPrimaryTexture("RESOURCE", leather1),
        PModel.Upper.head.HelmetHatLeather:setPrimaryTexture("RESOURCE", leather1)
    )
    :addParts("Chestplate",
        PModel.Upper.body.ChestplateLeather:setPrimaryTexture("RESOURCE", leather1),
        PModel.Upper.body.Arms.Arm_R.RightArmArmorLeather:setPrimaryTexture("RESOURCE", leather1),
        PModel.Upper.body.Arms.Arm_R.Elbow_R.RightLimbArmorLeather:setPrimaryTexture("RESOURCE", leather1),
        PModel.Upper.body.Arms.Arm_L.LeftArmArmorLeather:setPrimaryTexture("RESOURCE", leather1),
        PModel.Upper.body.Arms.Arm_L.Elbow_L.LeftLimbArmorLeather:setPrimaryTexture("RESOURCE", leather1)
    )
    :addParts("Leggings",
        PModel.Upper.body.BeltLeather:setPrimaryTexture("RESOURCE", leather2),
        PModel.Lower.Leg_R.RightLeggingsArmorLeather:setPrimaryTexture("RESOURCE", leather2),
        PModel.Lower.Leg_R.Knee_R.RightAnkleArmorLeather:setPrimaryTexture("RESOURCE", leather2),
        PModel.Lower.Leg_L.LeftLeggingsArmorLeather:setPrimaryTexture("RESOURCE", leather2),
        PModel.Lower.Leg_L.Knee_L.LeftAnkleArmorLeather:setPrimaryTexture("RESOURCE", leather2)
    )
    :addParts("Boots",
        PModel.Lower.Leg_R.Knee_R.RightBootArmorLeather:setPrimaryTexture("RESOURCE", leather1),
        PModel.Lower.Leg_L.Knee_L.LeftBootArmorLeather:setPrimaryTexture("RESOURCE", leather1)
    )

kattArmor.registerOnChange(function(partID, item)
    local materialAsset = item:toStackString():match(("^.*asset_id:\"minecraft:(.-)\"\"*."))
    -- print(materialAsset)
    if (materialAsset ~= nil and materialAsset ~= 'elytra') then
        return materialAsset
    end
end)

-- Wynncraft Armor
local wynncraftArmor = {
    ["hidden"] = "hidden",
    ["leather"] = "leather",
    ["copper"] = "copper",
    ["chainmail"] = "chainmail",
    ["gold"] = "gold",
    ["iron"] = "iron",
    ["diamond"] = "diamond",
    ["netherite"] = "netherite",
    ["pale_leather"] = "pale_leather",
    ["pale_copper"] = "pale_copper",
    ["pale_chainmail"] = "pale_chainmail",
    ["pale_gold"] = "pale_gold",
    ["pale_iron"] = "pale_iron",
    ["pale_diamond"] = "pale_diamond",
    ["infernal"] = "infernal",
    ["tan"] = "tan",
    ["shaman"] = "shaman"
}

local wynncraftArmorPathLayer1 = "minecraft:textures/entity/equipment/humanoid/%s.png"
local wynncraftArmorPathLayer2 = "minecraft:textures/entity/equipment/humanoid_leggings/%s.png"
local oldWynncraftArmorPathLayer1 = "minecraft:textures/models/armor/%s_layer_1.png"
local oldWwynncraftArmorPathLayer2 = "minecraft:textures/models/armor/%s_layer_2.png"

for material, materialItem in pairs(wynncraftArmor) do
    kattArmor.Materials[material]
        :setTexture(wynncraftArmorPathLayer1:format(materialItem))
        :setTextureLayer2(wynncraftArmorPathLayer2:format(materialItem))
end

kattArmor.Materials.pale_leather:setDefaultColor(0xA06540)

function OldTexture(bool)
    NewTextureSetting = bool
    if (NewTextureSetting) then
        for material, materialItem in pairs(wynncraftArmor) do
            kattArmor.Materials[material]
                :setTexture(wynncraftArmorPathLayer1:format(materialItem))
                :setTextureLayer2(wynncraftArmorPathLayer2:format(materialItem))
        end
    else
        for material, materialItem in pairs(wynncraftArmor) do
            local paleStart, paleEnd = string.find(materialItem, 'pale_')
            if (paleStart ~= nil and paleEnd ~= nil) then
                materialItem = string.sub(materialItem, paleEnd + 1)
            end
            kattArmor.Materials[material]
                :setTexture(oldWynncraftArmorPathLayer1:format(materialItem))
                :setTextureLayer2(oldWwynncraftArmorPathLayer2:format(materialItem))
    end
    end
end
pings.actionArmorTexture = OldTexture