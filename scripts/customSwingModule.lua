local currSwing = 1

local oldWeaponClass = nil
WeaponClass = nil
local oldToolItem = nil
local toolItem = nil

local holdingBow = nil
local oldHoldingBow = nil
local isHoldingCrossBow = nil
local isHoldingLoadedCross = nil
local oldIsHoldingLoadedCross = nil

local isFishing = nil
local oldIsFishing = nil

IsSwinging = nil
IsCastingSpell = nil

-- Check if itemStack has a class identified with it
function CheckClassItem(item)
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

-- Check if itemStack has tool identified with it
function CheckToolItem(item)
    if (item == nil) then
        return(nil)
    end

    if (string.find(item, "Mining") ~= nil) then
        return("Mining")
    elseif (string.find(item, "Woodcutting") ~= nil) then
        return("Woodcutting")
    elseif (string.find(item, "Farming") ~= nil) then
        return("Farming")
    elseif (string.find(item, "Fishing") ~= nil) then
        return("Fishing")
    end
    return(nil)
end

-- Check if swinging animation is playing 
local function isCustomSwinging()
    for i = 1, #AllSwingingAnimations do
        if (AllSwingingAnimations[i]:isPlaying()) then
            return true
        end
    end
    return false
end

-- Given what animations that need to play, check which one to play under certain conditions on a left click
local function CheckAnimToPlayLeftClick(swingAnimations, numOfSwings, nextIndx)
    -- Get previous swing index
    local prevIndx = nil
    if (nextIndx > 1) then
        prevIndx = nextIndx - 1
    end

    if (not swingAnimations[numOfSwings]:isPlaying()) then
        if (prevIndx ~= nil) then
            swingAnimations[prevIndx]:stop()
        end
        swingAnimations[nextIndx]:play()

        -- Return next swing index
        local nextSwing = nextIndx + 1
        if (nextSwing > numOfSwings) then
            nextSwing = 1
        end
        return nextSwing
    end

    return nextIndx
end

local function StopHandPunchAnimations()
    AnimPunchR:stop()
    GSBlend.stopBlend(AnimPunchR)
    AnimPunchL:stop()
    GSBlend.stopBlend(AnimPunchL)
    AnimMineR:stop()
    GSBlend.stopBlend(AnimMineR)
    AnimMineL:stop()
    GSBlend.stopBlend(AnimMineL)
end

function pings.syncHeldItemIsWeapon(strClass)
    WeaponClass = strClass
    currSwing = 1
end

function pings.syncHeldItemIsTool(strClass)
    toolItem = strClass
    currSwing = 1
end

-- right-clicking detection =============================================================================
local useKey = keybinds:of("Use",keybinds:getVanillaKey("key.use"))
function pings.onRightClickDo()
    ResetIdle()

    if (not IsActionWheelOpen and not IsMiddleSpellCast()) then

        if (WeaponClass == "Archer/Hunter") then
            ArcherShoot:play()
        end
    end
end
useKey.press = pings.onRightClickDo

function events.tick()

    -- Item Use Priority --------------------------------------------------------
    AnimBowShootHold:setPriority(player:isUsingItem() and 1 or 0)
    AnimCrossBowLoad:setPriority(player:isUsingItem() and 2 or 1)
    AnimShieldL:setPriority((player:isUsingItem()) and 1 or 0)
    AnimShieldR:setPriority((player:isUsingItem()) and 1 or 0)

    -- Swing Priority -----------------------------------------------------------
    IsSwinging = isCustomSwinging()
    IsCastingSpell = IsSpellCastingAnimation()

    AnimIdle:setPriority((IsSwinging and 1) or (IsCastingSpell and 1) or 0)
    AnimCrouching:setPriority((IsSwinging and 1) or (IsCastingSpell and 1) or 0)
    AnimCrouchWalk:setPriority((IsSwinging and 1) or (IsCastingSpell and 1) or 0)
    AnimFreeFalling:setPriority((IsSwinging and 1) or (IsCastingSpell and 1) or 0)
    AnimLand:setPriority((IsSwinging and 1) or (IsCastingSpell and 1) or 0)
    AnimFloat:setPriority((IsSwinging and 1) or (IsCastingSpell and 1) or 0)

    -- Handle Custom Attacking --------------------------------------------------
    local heldItem = player:getHeldItem()
    local heldItemIsSword = string.find(heldItem.id, "sword")
    local mainHandItem = player:getHeldItem(false)
    local offhandItem = player:getHeldItem(true)
    local readyToSwing = AnimCombatReady:isPlaying() or currSwing == 1

    if (player:getSwingTime() == 1) then
        -- Dont punch while holding a weapon
        if (WeaponClass ~= nil or heldItemIsSword) then
            StopHandPunchAnimations()
        end

        -- Dont swing if spell casting
        if (IsMiddleSpellCast()) then
            return
        end

        if (readyToSwing and WeaponClass == "Warrior/Knight") then
            currSwing = CheckAnimToPlayLeftClick({WarriorSwing1, WarriorSwing2, WarriorSwing3}, 3, currSwing)
        end

        if (readyToSwing and WeaponClass == "Mage/Dark Wizard") then
            currSwing = CheckAnimToPlayLeftClick({MageSwing1, MageSwing2, MageSwing3}, 3, currSwing)
        end

        if (readyToSwing and WeaponClass == "Assassin/Ninja") then
            currSwing = CheckAnimToPlayLeftClick({AssassinSwing1, AssassinSwing2, AssassinSwing3}, 3, currSwing)
        end

        if (readyToSwing and WeaponClass == "Shaman/Skyseer") then
            currSwing = CheckAnimToPlayLeftClick({ShamanSwing1, ShamanSwing2, ShamanSwing3}, 3, currSwing)
        end

        if (readyToSwing and heldItemIsSword) then
            currSwing = CheckAnimToPlayLeftClick({AssassinSwing1, AssassinSwing2, AssassinSwing3, AssassinSwing4}, 4, currSwing)
        end

    end

    -- Reset attack combo when not swinging
    if (not AnimCombatReady:isPlaying() and not isCustomSwinging()) then
        currSwing = 1
    end

    -- Bow Shooting -------------------------------------------------------------
    holdingBow = player:getActiveItem():getUseAction() == "BOW"
    if (oldHoldingBow ~= nil and holdingBow == false and holdingBow ~= oldHoldingBow) then
        ArcherShoot:play()
    end
    oldHoldingBow = holdingBow

    isHoldingLoadedCross = AnimCrossBowHold:isPlaying()
    local crossbowMainHand = string.find(mainHandItem.id, "crossbow")
    local crossbowOffHand = string.find(offhandItem.id, "crossbow")
    isHoldingCrossBow = (crossbowMainHand or crossbowOffHand) and true or false

    AnimCrossBowHold:setPriority(isHoldingLoadedCross and 1 or 0)
    if (oldIsHoldingLoadedCross ~= nil and isHoldingCrossBow and isHoldingLoadedCross == false and isHoldingLoadedCross ~= oldIsHoldingLoadedCross) then
        AnimCrossBowShoot:play()
    end
    oldIsHoldingLoadedCross = isHoldingLoadedCross

    -- Mining Tools -------------------------------------------------------------
    local heldItemIsMiningTool = (heldItem and toolItem == "Mining")
    local heldItemIsWoodcuttingTool = (heldItem and toolItem == "Woodcutting")
    local heldItemIsFarmingTool = (heldItem and toolItem == "Farming")
    local heldItemIsFishingTool = (heldItem and toolItem == "Fishing")

    local heldItemIsPickaxe = (string.find(heldItem.id, "_pickaxe") ~= nil or heldItemIsMiningTool)
    local heldItemIsAxe = (string.find(heldItem.id, "_axe") ~= nil or heldItemIsWoodcuttingTool)
    local heldItemIsShovel = (string.find(heldItem.id, "_shovel") ~= nil)
    local heldItemIsHoe = (string.find(heldItem.id, "_hoe") ~= nil or heldItemIsFarmingTool)

    local fishingMainHand = string.find(mainHandItem.id, "fishing_rod")
    local fishingOffHand = string.find(offhandItem.id, "fishing_rod")
    local heldItemIsFishingRod = (fishingMainHand or fishingOffHand or heldItemIsFishingTool)

    if (player:getSwingTime() == 1 and WeaponClass == nil) then
        if (heldItemIsPickaxe or heldItemIsAxe or heldItemIsShovel or heldItemIsHoe or heldItemIsFishingRod) then
            StopHandPunchAnimations()
        end

        if (readyToSwing and heldItemIsPickaxe) then
            if (not AnimPickaxe1:isPlaying()) then
                AnimPickaxe1:play()
                AnimPickaxe2:stop()
                currSwing = 2
            else
                AnimPickaxe1:stop()
                AnimPickaxe2:play()
            end
        end

        if (readyToSwing and heldItemIsAxe) then
            if (not AnimAxe1:isPlaying()) then
                AnimAxe1:play()
                AnimAxe2:stop()
                currSwing = 2
            else
                AnimAxe1:stop()
                AnimAxe2:play()
            end
        end

        if (readyToSwing and heldItemIsShovel) then
            if (not AnimShovel1:isPlaying()) then
                AnimShovel1:play()
                AnimShovel2:stop()
                currSwing = 2
            else
                AnimShovel1:stop()
                AnimShovel2:play()
            end
        end

        if (readyToSwing and heldItemIsHoe) then
            if (not AnimHoe1:isPlaying()) then
                AnimHoe1:play()
                AnimHoe2:stop()
                currSwing = 2
            else
                AnimHoe1:stop()
                AnimHoe2:play()
            end
        end
    end

    -- Fishing ------------------------------------------------------------------
    isFishing = player:isFishing()
    if (heldItemIsFishingRod) then
        if (isFishing and player:getSwingTime() ~= 1 and not AnimFishing1:isPlaying()) then
            AnimIsFishing:play()
        end
    end

    if (not isFishing and isFishing ~= oldIsFishing) then
        AnimIsFishing:setPriority(0)
        AnimIsFishing:stop()
    end

    oldIsFishing = isFishing

    if (player:getSwingTime() == 1 and readyToSwing and heldItemIsFishingRod) then
        StopHandPunchAnimations()

        if (isFishing) then
            AnimFishing1:play()
            AnimFishing2:stop()
            currSwing = 2
        else
            AnimFishing2:play()
            AnimFishing1:stop()
        end
    end

end

function events.render(delta, context)

    -- Held Item Wynncraft Class ------------------------------------------------
    local class = CheckClassItem(player:getHeldItem():toStackString())
    if (class ~= oldWeaponClass) then
        pings.syncHeldItemIsWeapon(class)
    end
    oldWeaponClass = class

    -- Held Item Wynncraft Tool -------------------------------------------------
    local tool = CheckToolItem(player:getHeldItem():toStackString())
    if (toolItem ~= oldToolItem) then
        pings.syncHeldItemIsTool(tool)
    end
    oldToolItem = tool

end