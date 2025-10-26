WeaponHolsterSetting = true;

local task

local oldItemInFirst
local changedToEmpty = false

local syncedItemID
local oldItemID

local syncedPlayerSlot = 0
local oldSlot

local currWeapon
local oldWeapon

local taskRotation
local taskPosition

local classDefaults = {
    ["Archer/Hunter"] = "bows",
    ["Assassin/Ninja"] = "daggers",
    ["Mage/Dark Wizard"] = "wands",
    ["Shaman/Skyseer"] = "reliks",
    ["Warrior/Knight"] = "spears"
}

local weaponCustomModelIDs = {
    scythes = {1662, 1663, 1664},
    swordsSpears = {1687, 1695, 1730},
    shortWands = {1489, 1497, 1500},
    shortDaggers = {1400, 1401, 1408, 1414, 1417},
    frontClaws = {1405, 1406, 1407, 1411, 1412, 1413},
    sideClaws = {},
    lanternReliks = {},
    crossbows = {1321, 1322, 1323},
    longbows = {},
    handCannons = {}
}

-- Weapon Orientation ((Position x, y, z), (Roation x, y, z))
local weaponOrientations = {
    spears        = {{0, 20, 4}, {0, 90, 125}},
    scythes       = {{0, 15, 4}, {0, 270, 50}},
    swordsSpears  = {{5, 25, 4}, {0, 90, 135}},
    wands         = {{0, 20, 4}, {0, 90, 125}},
    shortWands    = {{5, 25, 4}, {0, 90, 135}},
    daggers       = {{5, 25, 4}, {0, 90, 130}},
    shortDaggers  = {{4.9, 12, -2}, {120, 0, 0}},
    frontClaws    = {{0, 20, 5.5}, {90, 0, 320}},
    sideClaws     = {{0, 18, 5.5}, {90, 90, 320}},
    reliks        = {{4, 20, 4}, {0, 270, 135}},
    lanternReliks = {{5, 16, 0}, {0, 90, -30}},
    bows          = {{6, 17.5, 4}, {25, 90, 340}},
    crossbows     = {{3, 20, 4}, {90, 0, 315}},
    longbows      = {{3, 18, 4}, {25, 90, 340}},
    handCannons   = {{3, 23, 4}, {90, 0, 315}},
}

local weaponOffsetIDs = {1491, 1687}

function pings.updateItemID(id)
    syncedItemID = id
end

function pings.updateSlot(slot)
    syncedPlayerSlot = slot
end

function pings.updateSlotKey()
    syncedPlayerSlot = 0
end

function pings.updateSlotNonZeroKey()
    syncedPlayerSlot = 1
end

function pings.updateWeaponClass(class)
    currWeapon = class
end

function pings.updateWeaponTask(vectRotX, vectRotY, vectRotZ, vecPosX, vecPosY, vecPosZ)
    taskRotation = vectors.vec3(vectRotX, vectRotY, vectRotZ)
    taskPosition = vectors.vec3(vecPosX, vecPosY, vecPosZ)
end

-- Check if itemStack has a class identified with it
local function CheckClassItem(item)
    if (item == nil) then
        return(nil)
    end

    if (string.find(item, "Warrior/Knight") ~= nil) then
        return("Warrior/Knight")
    elseif (string.find(item, "Mage/Dark Wizard") ~= nil) then
        return("Mage/Dark Wizard")
    elseif (string.find(item, "Assassin/Ninja") ~= nil) then
        return("Assassin/Ninja")
    elseif (string.find(item, "Shaman/Skyseer") ~= nil) then
        return("Shaman/Skyseer")
    elseif (string.find(item, "Archer/Hunter") ~= nil) then
        return("Archer/Hunter")
    end
    return(nil)
end

-- Check if given number is in array
local function NumInArray(num, arr)
    for i=1, #arr do
        if (num == arr[i]) then
            return true
        end
    end
    return false
end

-- Set position/rotation of itemTask by key
local function ApplyOrientation(key)
    local orient = weaponOrientations[key]
    if orient then
        local pos, rot = orient[1], orient[2]
        task:setPos(pos[1], pos[2], pos[3])
        task:setRot(rot[1], rot[2], rot[3])
        return true
    end
    return false
end


function events.entity_init() --=====================================================================================================================
    task = PModel.Upper.body.SheathedWeapon:newItem("weapon")
    task:setDisplayMode("THIRD_PERSON_RIGHT_HAND")
end

if (host:isHost()) then
    function events.render()

        if (not WeaponHolsterSetting) then
            return
        end

        -- Sync item id and damage value
        local itemInFirst = host:getSlot(0)
        local itemInFirstStack = itemInFirst:toStackString()

        local itemID = itemInFirst.id
        local customModelData = itemInFirst["tag"]["CustomModelData"]

        if (customModelData ~= nil and customModelData.floats ~= nil) then
            customModelData = customModelData.floats[1]
            itemID = itemInFirst.id.."[custom_model_data={floats:["..customModelData.."]}]"
            local classItem = CheckClassItem(itemInFirstStack)

            -- Edit scale and rotation depending on its customModelData value
            local matchedKey
            for key, idList in pairs(weaponCustomModelIDs) do
                if NumInArray(customModelData, idList) then
                    matchedKey = key
                    break
                end
            end

            if matchedKey then
                ApplyOrientation(matchedKey)
            else
                local fallback = classDefaults[classItem]
                if fallback then
                    ApplyOrientation(fallback)
                end
            end

            -- Hand Offset Models
            if NumInArray(customModelData, weaponOffsetIDs) then
                task:setPos(task:getPos().x, task:getPos().y, 5)
            end
        end

        -- ping only when item has changed
        if (oldItemInFirst ~= itemInFirst or (changedToEmpty == false and itemInFirst.id == 'minecraft:air')) then
            changedToEmpty = true
            if (oldItemInFirst ~= itemInFirst) then
                changedToEmpty = false
            end

            oldItemInFirst = itemInFirst

            -- Sync item identifier
            pings.updateItemID(itemID)

            -- Sync bool check if itemstack is weapon
            local hasClassStr = CheckClassItem(itemInFirstStack)
            pings.updateWeaponClass(hasClassStr)

            -- Sync item task vectors
            pings.updateWeaponTask(task:getRot()[1], task:getRot()[2], task:getRot()[3], task:getPos()[1], task:getPos()[2], task:getPos()[3])
        end

    end

    -- Sync selected slot
    function events.MOUSE_SCROLL(delta)
        if (not player:isLoaded() or host:getScreen() ~= nil or IsActionWheelOpen) then
            return
        end

        local eventCurrSlot = player:getNbt().SelectedItemSlot
        if (delta < 0) then
            if (eventCurrSlot == 8) then
                eventCurrSlot = 0
            else
                eventCurrSlot = eventCurrSlot + 1
            end
        else
            if (eventCurrSlot == 0) then
                eventCurrSlot = 8
            else
                eventCurrSlot = eventCurrSlot - 1
            end
        end

        -- ping only when mouse scrolled over 0
        if (eventCurrSlot == 0 or eventCurrSlot == 1 or eventCurrSlot == 8) then
            pings.updateSlot(eventCurrSlot)
        end
    end

    -- Handle changing slot on keypress
    local slotOneKey = keybinds:newKeybind("hotbar1", keybinds:getVanillaKey("key.hotbar.1"))
    slotOneKey.press = pings.updateSlotKey
    local slotTwoKey = keybinds:newKeybind("hotbar2", keybinds:getVanillaKey("key.hotbar.2"))
    local slotThreeKey = keybinds:newKeybind("hotbar3", keybinds:getVanillaKey("key.hotbar.3"))
    local slotFourKey = keybinds:newKeybind("hotbar4", keybinds:getVanillaKey("key.hotbar.4"))
    local slotFiveKey = keybinds:newKeybind("hotbar5", keybinds:getVanillaKey("key.hotbar.5"))
    local slotSixKey = keybinds:newKeybind("hotbar6", keybinds:getVanillaKey("key.hotbar.6"))
    local slotSevenKey = keybinds:newKeybind("hotbar7", keybinds:getVanillaKey("key.hotbar.7"))
    local slotEightKey = keybinds:newKeybind("hotbar8", keybinds:getVanillaKey("key.hotbar.8"))
    local slotNineKey = keybinds:newKeybind("hotbar9", keybinds:getVanillaKey("key.hotbar.9"))
    slotTwoKey.press = pings.updateSlotNonZeroKey
    slotThreeKey.press = pings.updateSlotNonZeroKey
    slotFourKey.press = pings.updateSlotNonZeroKey
    slotFiveKey.press = pings.updateSlotNonZeroKey
    slotSixKey.press = pings.updateSlotNonZeroKey
    slotSevenKey.press = pings.updateSlotNonZeroKey
    slotEightKey.press = pings.updateSlotNonZeroKey
    slotNineKey.press = pings.updateSlotNonZeroKey
end

function events.tick()
    if (WeaponHolsterSetting) then
        if ((syncedPlayerSlot ~= oldSlot and (syncedPlayerSlot == 0 or oldSlot == 0)) or (currWeapon ~= oldWeapon) or (syncedItemID ~= oldItemID)) then
            if (currWeapon ~= nil) then
                task:setItem(syncedItemID)
                task:setRot(taskRotation)
                task:setPos(taskPosition)
            else
                task:setItem("minecraft:air")
            end
        end

        -- holding/not holding weapon
        if (syncedPlayerSlot == 0) then
            task:setVisible(false)
        else
            task:setVisible(true)
        end

        oldItemID = syncedItemID
        oldSlot = syncedPlayerSlot
        oldWeapon = currWeapon
    else
        task:setVisible(false)
    end
end