-- ///////////////////////////////////////////////////////////////// --
--                          Wynn Extra Bends
--                              Vance568
--                               v1.1
--
--               Helper Library Authors: Squishy, Katt962
-- ///////////////////////////////////////////////////////////////// --

local squapi = require("SquAPI")
local squassets = require("SquAssets")

-- Hide vanilla model
vanilla_model.PLAYER:setVisible(false)

-- Get model type
function events.entity_init() --=====================================================================================================================
    if (player:getModelType() == "DEFAULT") then
        models.model.Player.Upper.body.Arms.Arm_L.Bicep_Default_L:setVisible(true)
        models.model.Player.Upper.body.Arms.Arm_L.Bicep_Slim_L:setVisible(false)
        models.model.Player.Upper.body.Arms.Arm_L.Elbow_L.Limb_Default_L:setVisible(true)
        models.model.Player.Upper.body.Arms.Arm_L.Elbow_L.Limb_Slim_L:setVisible(false)

        models.model.Player.Upper.body.Arms.Arm_R.Bicep_Default_R:setVisible(true)
        models.model.Player.Upper.body.Arms.Arm_R.Bicep_Slim_R:setVisible(false)
        models.model.Player.Upper.body.Arms.Arm_R.Elbow_R.Limb_Default_R:setVisible(true)
        models.model.Player.Upper.body.Arms.Arm_R.Elbow_R.Limb_Slim_R:setVisible(false)
    else
        models.model.Player.Upper.body.Arms.Arm_L.Bicep_Default_L:setVisible(false)
        models.model.Player.Upper.body.Arms.Arm_L.Bicep_Slim_L:setVisible(true)
        models.model.Player.Upper.body.Arms.Arm_L.Elbow_L.Limb_Default_L:setVisible(false)
        models.model.Player.Upper.body.Arms.Arm_L.Elbow_L.Limb_Slim_L:setVisible(true)

        models.model.Player.Upper.body.Arms.Arm_R.Bicep_Default_R:setVisible(false)
        models.model.Player.Upper.body.Arms.Arm_R.Bicep_Slim_R:setVisible(true)
        models.model.Player.Upper.body.Arms.Arm_R.Elbow_R.Limb_Default_R:setVisible(false)
        models.model.Player.Upper.body.Arms.Arm_R.Elbow_R.Limb_Slim_R:setVisible(true)
    end
end

-- global vars ==========================================================================================

-- Settings
local sheathOption = true;
local idleAnimations = true;

-- Animation states/ticks
local state
local oldState
local randAnim
local rightWasPressed
local randTick = 400
local fallTimer = 0
local startFallTime = 0
local startedFall = false
local idleTick = 0
local jump = false

-- BlockBench model parts
local pModel = models.model.Player
local modelHead = pModel.Upper.head
local modelMainBody = pModel.Upper
local modelRightArm = pModel.Upper.body.Arms.Arm_R
local modelLeftArm = pModel.Upper.body.Arms.Arm_L

-- Set players skin to their own skin
pModel:setPrimaryTexture("SKIN")

-- Basic Action Animations ==============================================================================
AnimIdle = animations.model["Idle_0"]
AnimIdling1 = animations.model["Idle_1"]
AnimIdling2 = animations.model["Idle_2"]
AnimIdling3 = animations.model["Idle_3"]

AnimWalk = animations.model["Walking"]
AnimCrouching = animations.model["Crouch_0"]
AnimCrouch = animations.model["Crouch_1"]
AnimUnCrouch = animations.model["Crouch_2"]
AnimCrouchWalk = animations.model["Sneaking"]

AnimCrawl = animations.model["Crawl_Still"]
AnimCrawling = animations.model["Crawling"]

AnimFloat = animations.model["Float"]
AnimSwim = animations.model["Swim_0"]

AnimClimb = animations.model["Climbing"]
AnimClimbHold = animations.model["Climb_Hold"]

AnimJumping = animations.model["Jump_0"]
AnimJump = animations.model["Jump_1"]
AnimJumpLand = animations.model["Jump_2"]
AnimJumpMove1 = animations.model["Sprint_Jump_1"]
AnimJumpMoveStop1 = animations.model["Sprint_Jump_2"]
AnimJumpMove2 = animations.model["Sprint_Jump_3"]
AnimJumpMoveStop2 = animations.model["Sprint_Jump_4"]
AnimCrouchJumping = animations.model["Crouch_3"]

AnimShortFalling = animations.model["Fall_0"]
AnimFall = animations.model["Fall_1"]
AnimShortLand = animations.model["Fall_2"]
AnimFalling = animations.model["Falling"]
AnimFallLand = animations.model["Land"]

AnimSprint = animations.model["Sprinting"]

AnimSit = animations.model["Sit"]
AnimHorseSit = animations.model["Horse_Sitting"]
AnimHorseRiding = animations.model["Horse_Riding"]

AnimTaunt1 = animations.model["Taunt_1"]
AnimTaunt2a = animations.model["Taunt_2"]
AnimTaunt2b = animations.model["Taunt_3"]
AnimTaunt3 = animations.model["Taunt_4"]
AnimTaunt4 = animations.model["Taunt_5"]

-- Attacks ----------------------------------------------------------

AnimPunch = animations.model["Punch"]

-- Warrior ------
WarriorSwing1 = animations.model["Spear_Swing_1"]
WarriorSwing2 = animations.model["Spear_Swing_2"]
WarriorSwing3 = animations.model["Spear_Swing_3"]

-- Mage ---------
MageSwing1 = animations.model["Wand_Wave_1"]
MageSwing2 = animations.model["Wand_Wave_2"]
MageSwing3 = animations.model["Wand_Wave_3"]

-- Assassin -----
AssassinSwing1 = animations.model["Sword_Swing_1"]
AssassinSwing2 = animations.model["Sword_Swing_2"]
AssassinSwing3 = animations.model["Sword_Swing_3"]

-- Shaman -------
ShamanSwing = animations.model["Relik_Strike"]

-- Archer -------
ArcherShoot = animations.model["Bow_Shoot"]
ArcherShootHold = animations.model["Bow_Shoot_Hold"]

-- Wynncraft Spells -------------------------------------------------
-- R1, L2, R3 = s1
-- R1, L2, L3 = s2
-- R1, R2, L3 = s3
-- R1, R2, R3 = Move

AnimR1 = animations.model["R1"]
AnimR2 = animations.model["R2"]
AnimL2 = animations.model["L2"]

-- AnimMovement = animations.model["animation.model.movement"]
AnimThirdSpell = animations.model["spell3"]
AnimSecondSpell = animations.model["spell2"]
-- AnimFirstSpell = animations.model["animation.model.FirstSpell"]

-- Katt Armor Handling ==================================================================================
local kattArmor = require("KattArmor")()
kattArmor.Armor.Helmet
-- the `addParts` function is not strict with the number of ModelParts provided. Add or remove parts as desired.
    :addParts(
        pModel.Upper.head.Helmet,
        pModel.Upper.head.HelmetHat
    )
kattArmor.Armor.Chestplate
    :addParts(
      pModel.Upper.body.Chestplate,
      pModel.Upper.body.Arms.Arm_R.RightArmArmor,
      pModel.Upper.body.Arms.Arm_L.LeftArmArmor
    )
kattArmor.Armor.Leggings
    :addParts(
      pModel.Upper.body.Belt,
      pModel.Lower.Leg_R.RightLeggingsArmor,
      pModel.Lower.Leg_R.Knee_R.RightAnkleArmor,
      pModel.Lower.Leg_L.LeftLeggingsArmor,
      pModel.Lower.Leg_L.Knee_L.LeftAnkleArmor
    )
kattArmor.Armor.Boots
    :addParts(
      pModel.Lower.Leg_R.Knee_R.RightBootArmor,
      pModel.Lower.Leg_L.Knee_L.LeftBootArmor
    )

-- Helper Functions =====================================================================================

-- Stop playing all animations pertaining to combat
function StopAllSpell()
    AnimR1:stop()
    AnimR2:stop()
    AnimL2:stop()

    -- Warrior -----
    WarriorSwing1:stop()
    WarriorSwing2:stop()
    WarriorSwing3:stop()

    -- Mage -----
    MageSwing1:stop()
    MageSwing2:stop()
    MageSwing3:stop()

    -- Assassin -----
    AssassinSwing1:stop()
    AssassinSwing2:stop()
    AssassinSwing3:stop()

    -- Shaman -----
    ShamanSwing:stop()

    -- Archer -----
    ArcherShoot:stop()

    -- AnimFirstSpell:stop()
    AnimSecondSpell:stop()
    AnimThirdSpell:stop()
    -- AnimMovement:stop()
end

function StopAllIdle()
    AnimIdling1:stop()
    AnimIdling2:stop()
    AnimIdling3:stop()
    AnimTaunt1:stop()
    AnimTaunt3:stop()
    AnimTaunt4:stop()
end

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

-- Check if given number is in array
function NumInArray(num, arr)
    for i=1, #arr do
        if (num == arr[i]) then
            return true
        end
    end
    return false
end

-- Given what animations that need to play, check which one to play under certain conditions on a left click
function CheckAnimToPlayLeftClick(r1, r2, l2, swing1, swing2, swingCombo, secondSpell, thirdSpell)
    if (l2:isPlaying() and not secondSpell:isPlaying()) then        -- R1, L2, s2
        StopAllSpell()
        secondSpell:play()
    elseif (r2:isPlaying() and not thirdSpell:isPlaying()) then    -- R1, R2, s3
        StopAllSpell()
        thirdSpell:play()
    elseif (r1:isPlaying() and not l2:isPlaying()) then             -- R1, L2
        l2:play()
    elseif (swing2 ~= nil and swingCombo ~= nil) then
        -- Three swing combo attack
        if (swing2:isPlaying() and not swingCombo:isPlaying()) then
            swing2:stop()
            swingCombo:play()
        elseif (swing1:isPlaying() and not swing2:isPlaying() and not swingCombo:isPlaying()) then
            swing1:stop()
            swing2:play()
        elseif (not swing1:isPlaying() and not swing2:isPlaying() and not swingCombo:isPlaying()) then
            swing1:play()
        end
    else
        -- One swing attack
        swing1:restart()
    end
end

-- Given what animations that need to play, check which one to play under certain conditions on a right click
function CheckAnimToPlayRightClick(r1, r2, l2, firstSpell, movement)
    if (l2:isPlaying() and not r2:isPlaying()) then                                         -- R1, L2, s1
        StopAllSpell()
        firstSpell:play()
    elseif (r2:isPlaying() and not movement:isPlaying()) then                               -- R1, R2, Movement
        StopAllSpell()
        movement:play()
    elseif (r1:isPlaying() and not r2:isPlaying()) then                                     -- R1, R2
        r2:play()
    elseif (not r1:isPlaying() and not r2:isPlaying() and not movement:isPlaying()) then    -- R1
        r1:play()
    end
end

-- Given what animation to play, play it without interference of other animations and with small delay
function PlaySpellWithDelay(spell)
    StopAllSpell()
    spell:setStartDelay(0.3)
    spell:play()
    spell:setStartDelay(0)
end

-- Better isGrounded function with small fence fix (curtosy of @Discord User: 4P5)
local CLEARANCE = 0.1 -- How many blocks you can hover above the ground and still be considered touching it
local function isOnGround(entity)
    local pos = entity:getPos()
    local hitbox = entity:getBoundingBox().x_z / 2
    local min = pos - hitbox - vec(0, CLEARANCE, 0)
    local max = pos + hitbox
    local search_min = min:copy():floor()
    local search_max = max:copy():floor()
    for x = search_min.x, search_max.x do
        for y = search_min.y, search_max.y do
            for z = search_min.z, search_max.z do
                local block_pos = vec(x,y,z)
                local block = world.getBlockState(block_pos)
                local boxes = block:getCollisionShape()
                for i = 1, #boxes do
                    local box = boxes[i]
                    local box1_min = box[1] + block_pos
                    local box1_max = box[2] + block_pos
                    if not (box1_max.x <= min.x or max.x <= box1_min.x or
                            box1_max.y <= min.y or max.y <= box1_min.y or
                            box1_max.z <= min.z or max.z <= box1_min.z) then
                        return true
                    end
                end
            end
        end
    end

    local blockBelow = world.getBlockState(player:getPos():add(0,-0.51,0)).id
    local i, j
    i, j = string.find(blockBelow, "fence")
    if (i ~= nil and j ~= nil) then
        return true
    end
    i, j = string.find(blockBelow, "wall")
    if (i ~= nil and j ~= nil) then
        return true
    end

    return false
end

-- Given which jump to play, play that particular jump. returns next jump value
function WhichJump(j1Anim, j2Anim)
    if (jump) then
        j1Anim:play()
        pings.legJump(false)
        return
    end
    j2Anim:play()
    pings.legJump(true)
end

-- Get random number between 400 and 600 that is also divisible by 80
function GetRandIdleTick()
    local num = math.random(400, 600)
    while (num % 80 ~= 0) do
        num = math.random(400, 600)
    end
    return(num)
end

-- Stop playing all 'basic action' animations except animations given
function stopBasicAnims(exceptionTable)
    local animationTable = {AnimIdle, AnimWalk, AnimCrouching, AnimCrouchWalk, AnimSprint, AnimCrawl, AnimCrawling, AnimJumping, AnimShortFalling,
                            AnimClimb, AnimClimbHold, AnimFloat, AnimSwim, AnimSit, AnimHorseSit, AnimHorseRiding, AnimCrouchJumping}
    local isException
    for i,anim in ipairs(animationTable) do
        isException = false
        for j,exception in ipairs(exceptionTable) do
            if (anim == exception) then
                isException = true
            end
        end

        if (not isException) then
            anim:stop()
        end
    end
end

-- Get the priority of the animation currently playing
function getAnimPriority()
    local animationTable = {AnimJump, AnimJumpLand, AnimCrouch, AnimUnCrouch, AnimFall, AnimShortLand, AnimFallLand,
                            AnimJumpMove1, AnimJumpMove2, AnimJumpMoveStop1, AnimJumpMoveStop2, AnimIdle, AnimCrouching,
                            AnimCrouchWalk, AnimWalk, AnimSprint, AnimCrawl, AnimCrawling, AnimJumping, AnimCrouchJumping, AnimShortFalling,
                            AnimFalling, AnimSwim, AnimFloat, AnimClimb, AnimClimbHold, AnimSit, AnimHorseSit, AnimHorseRiding}
    for i,anim in ipairs(animationTable) do
        if (anim == AnimIdle and anim:isPlaying() and not AnimCrouching:isPlaying()) then
            return(anim:getPriority()+1)
        elseif (anim:isPlaying()) then
            return(anim:getPriority())
        end
    end
    return(0)
end

-- Host Synchronization Values ==========================================================================
local weaponClass
local isActionWheelOpen
local oldWeaponClass
local wheelCheck
local oldWheelCheck

function pings.syncHeldItemIsWeapon(strClass)
    weaponClass = strClass
end

function pings.syncAcitonWheel(bool)
    isActionWheelOpen = bool
end

function pings.legJump(bool)
    jump = bool
end

function events.render(delta)
    -- Is Action Wheel Open
    wheelCheck = action_wheel:isEnabled()
    if (wheelCheck ~= oldWheelCheck) then
        pings.syncAcitonWheel(wheelCheck)
    end
    oldWheelCheck = wheelCheck

    -- Held Item Wynncraft Class
    local currItem = player:getHeldItem()
    local currItemStack = currItem:toStackString()
    local class = CheckClassItem(currItemStack)
    if (class ~= oldWeaponClass) then
        pings.syncHeldItemIsWeapon(class)
    end
    oldWeaponClass = class

end

-- left-clicking detection ==============================================================================
local hitKey = keybinds:of("Punch",keybinds:getVanillaKey("key.attack"))

function pings.onHitDo()
    if (not isActionWheelOpen) then

        -- Spears --
        if (weaponClass == "Warrior/Knight") then
            CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, WarriorSwing1, WarriorSwing2, WarriorSwing3, AnimSecondSpell, AnimThirdSpell)
            return
        end

        -- Wands --
        if (weaponClass == "Mage/Dark Wizard") then
            CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, MageSwing1, MageSwing2, MageSwing3, AnimSecondSpell, AnimThirdSpell)
            return
        end

        -- Daggers --
        if (weaponClass == "Assassin/Ninja" or string.find(player:getHeldItem():toStackString(), "sword") ~= nil) then
            CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, AssassinSwing1, AssassinSwing2, AssassinSwing3, AnimSecondSpell, AnimThirdSpell)
            return
        end

        -- Reliks --
        if (weaponClass == "Shaman/Skyseer") then
            CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, ShamanSwing, nil, nil, AnimSecondSpell, AnimThirdSpell)
            return
        end

        -- Bows --
        -- if (weaponClass == "Archer/Hunter") then
        --     -- use opposite click for archer
        --     CheckAnimToPlayRightClick(AnimR1, AnimR2, AnimL2, AnimFirstSpell, AnimMovement)
        --     return
        -- end

        -- Holding none weapon --
        AnimPunch:restart()
    
    end
end

hitKey.press = pings.onHitDo

-- right-clicking detection =============================================================================
local useKey = keybinds:of("Use",keybinds:getVanillaKey("key.use"))

function pings.onRightClickDo()
    if (not isActionWheelOpen) then
        -- local currItem = player:getHeldItem()
        -- local currItemStack = currItem:toStackString()

        -- -- Spears --
        -- if (CheckClassItem(currItemStack) == "Warrior/Knight") then
        --     CheckAnimToPlayRightClick(AnimR1, AnimR2, AnimL2, AnimFirstSpell, AnimMovement)
        -- end

        -- -- Wands --
        -- if (CheckClassItem(currItemStack) == "Mage/Dark Wizard") then
        --     CheckAnimToPlayRightClick(AnimR1, AnimR2, AnimL2, AnimFirstSpell, AnimMovement)
        -- end

        -- -- Daggers --
        -- if (CheckClassItem(currItemStack) == "Assassin/Ninja") then
        --     CheckAnimToPlayRightClick(AnimR1, AnimR2, AnimL2, AnimFirstSpell, AnimMovement)
        -- end

        -- -- Reliks --
        -- if (CheckClassItem(currItemStack) == "Shaman/Skyseer") then
        --     CheckAnimToPlayRightClick(AnimR1, AnimR2, AnimL2, AnimFirstSpell, AnimMovement)
        -- end

        -- Bows --
        if (weaponClass == "Archer/Hunter") then
            -- use opposite click for archer
            CheckAnimToPlayLeftClick(AnimR1, AnimR2, AnimL2, ArcherShoot, nil, nil, AnimSecondSpell, AnimThirdSpell)
        end -- hold down button to attack?

    end
end

useKey.press = pings.onRightClickDo

-- Key Bind detection (wynntils macros) =================================================================

-- function pings.onZPressDo()
--     local currItem = player:getHeldItem()
--     local currItemStack = currItem:toStackString()

--     if (string.find(currItemStack, "Warrior/Knight") ~= nil) then
--         PlaySpellWithDelay(AnimFirstSpell)
--     elseif (string.find(currItemStack, "Mage/Dark Wizard") ~= nil) then
--         PlaySpellWithDelay(AnimFirstSpell)
--     elseif (string.find(currItemStack, "Assassin/Ninja") ~= nil) then
--         PlaySpellWithDelay(AnimFirstSpell)
--     elseif (string.find(currItemStack, "Shaman/Skyseer") ~= nil) then
--         PlaySpellWithDelay(AnimFirstSpell)
--     end
-- end

-- function pings.onXPressDo()
--     local currItem = player:getHeldItem()
--     local currItemStack = currItem:toStackString()

--     if (string.find(currItemStack, "Warrior/Knight") ~= nil) then
--         PlaySpellWithDelay(AnimMovement)
--     elseif (string.find(currItemStack, "Mage/Dark Wizard") ~= nil) then
--         PlaySpellWithDelay(AnimMovement)
--     elseif (string.find(currItemStack, "Assassin/Ninja") ~= nil) then
--         PlaySpellWithDelay(AnimMovement)
--     elseif (string.find(currItemStack, "Shaman/Skyseer") ~= nil) then
--         PlaySpellWithDelay(AnimMovement)
--     end
-- end

-- function pings.onCPressDo()
--     local currItem = player:getHeldItem()
--     local currItemStack = currItem:toStackString()

--     if (string.find(currItemStack, "Warrior/Knight") ~= nil) then
--         PlaySpellWithDelay(AnimSecondSpell)
--     elseif (string.find(currItemStack, "Mage/Dark Wizard") ~= nil) then
--         PlaySpellWithDelay(AnimSecondSpell)
--     elseif (string.find(currItemStack, "Assassin/Ninja") ~= nil) then
--         PlaySpellWithDelay(AnimSecondSpell)
--     elseif (string.find(currItemStack, "Shaman/Skyseer") ~= nil) then
--         PlaySpellWithDelay(AnimSecondSpell)
--     end
-- end

-- function pings.onVPressDo()
--     local currItem = player:getHeldItem()
--     local currItemStack = currItem:toStackString()

--     if (string.find(currItemStack, "Warrior/Knight") ~= nil) then
--         PlaySpellWithDelay(AnimThirdSpell)
--     elseif (string.find(currItemStack, "Mage/Dark Wizard") ~= nil) then
--         PlaySpellWithDelay(AnimThirdSpell)
--     elseif (string.find(currItemStack, "Assassin/Ninja") ~= nil) then
--         PlaySpellWithDelay(AnimThirdSpell)
--     elseif (string.find(currItemStack, "Shaman/Skyseer") ~= nil) then
--         PlaySpellWithDelay(AnimThirdSpell)
--     end
-- end

-- local zKey = keybinds:of("Z","key.keyboard.z")
-- local xKey = keybinds:of("X","key.keyboard.x")
-- local cKey = keybinds:of("C","key.keyboard.c")
-- local vKey = keybinds:of("V","key.keyboard.v")
-- zKey.press = pings.onZPressDo
-- xKey.press = pings.onXPressDo
-- cKey.press = pings.onCPressDo
-- vKey.press = pings.onVPressDo

-- SquAPI Animation Handling ============================================================================

squapi.smoothHead:new({modelHead, modelMainBody}, {0.6, 0.25}, 0.1, 1.75, false)

-- Render animation conditions by in game ticks
function events.tick() --============================================================================================================================
    -- Attack animation priorities ----------------------------------------------
    local p = getAnimPriority()

    AnimPunch:setPriority(p)

    WarriorSwing1:setPriority(p)
    WarriorSwing2:setPriority(p)
    WarriorSwing3:setPriority(p)

    MageSwing1:setPriority(p)
    MageSwing2:setPriority(p)
    MageSwing3:setPriority(p)

    AssassinSwing1:setPriority(p)
    AssassinSwing2:setPriority(p)
    AssassinSwing3:setPriority(p)

    ArcherShoot:setPriority(p)
    ArcherShootHold:setPriority(p)

    ShamanSwing:setPriority(p)

    -- AnimMovement:setPriority(4)
    -- AnimFirstSpell:setPriority(4)
    -- AnimSecondSpell:setPriority(4)
    -- AnimThirdSpell:setPriority(4)

    -- Basic action animation prioirites ----------------------------------------
    AnimIdle:setPriority(1)
    AnimIdling1:setPriority(2)
    AnimIdling2:setPriority(2)
    AnimIdling3:setPriority(2)

    AnimCrouching:setPriority(1)
    AnimCrouchWalk:setPriority(1)
    AnimCrouch:setPriority(2)
    AnimUnCrouch:setPriority(2)

    AnimWalk:setPriority(2)
    AnimSprint:setPriority(2)

    AnimCrawl:setPriority(2)
    AnimCrawling:setPriority(2)

    AnimJumping:setPriority(1)
    AnimJump:setPriority(2)
    AnimJumpLand:setPriority(2)
    AnimJumpMove1:setPriority(2)
    AnimJumpMove2:setPriority(2)
    AnimJumpMoveStop1:setPriority(2)
    AnimJumpMoveStop2:setPriority(2)
    AnimCrouchJumping:setPriority(2)

    AnimShortFalling:setPriority(1)
    AnimFall:setPriority(2)
    AnimShortLand:setPriority(2)
    AnimFalling:setPriority(2)
    AnimFallLand:setPriority(2)

    AnimSwim:setPriority(1)
    AnimFloat:setPriority(1)

    AnimClimb:setPriority(1)
    AnimClimbHold:setPriority(1)

    AnimSit:setPriority(1)
    AnimHorseSit:setPriority(1)
    AnimHorseRiding:setPriority(1)

    AnimTaunt1:setPriority(4)
    AnimTaunt2a:setPriority(p)
    AnimTaunt2b:setPriority(p)
    AnimTaunt3:setPriority(4)
    AnimTaunt4:setPriority(4)

    -- Handle crouch model position ---------------------------------------------
    if (player:getPose() == "CROUCHING") then
        pModel:setPos(0,2,0)
    else
        pModel:setPos(0,0,0)
    end

    -- Idling -------------------------------------------------------------------
    if (idleAnimations) then
        if (state == "idle") then
            idleTick = idleTick + 1
            if (idleTick == randTick) then
                randAnim = math.random(0, 2)
                if (randAnim == 0) then
                    AnimIdling1:play()
                elseif (randAnim == 1) then
                    AnimIdling2:play()
                else
                    AnimIdling3:play()
                end
                idleTick = 0
                randTick = GetRandIdleTick()
            end
        else
            idleTick = 0
            StopAllIdle()
        end

        if (hitKey:isPressed() and not action_wheel:isEnabled()) then
            idleTick = 0
            StopAllIdle()
        end
    end

    -- Bow Shooting -------------------------------------------------------------
    if (weaponClass ~= "Archer/Hunter" and string.find(player:getHeldItem():toStackString(), "bow") ~= nil) then
        ShootingAction = player:getActiveItem():getUseAction() == "BOW" or player:getActiveItem():getUseAction() == "CROSSBOW"
    end
    if (ShootingAction) then
        ArcherShootHold:play()
    else
        ArcherShootHold:stop()
    end

    -- Dedect right click use arm swing -----------------------------------------
    if (useKey:isPressed()) then
        rightWasPressed = true
    end
    if (rightWasPressed and player:isSwingingArm() and player:getSwingTime() == 1) then
        AnimPunch:restart()
        rightWasPressed = false
    end

    -- Scales walk/run speed animation based on player vel -------------------
    local horizontalVel = player:getVelocity().x_z:length()

    -- Walking
    if (horizontalVel*3.8 >= 2) then
        AnimWalk:setSpeed(2)
    else
        AnimWalk:setSpeed(horizontalVel*3.8)
    end
    -- Sprinting
    if (horizontalVel*3.4 >= 1.1) then
        AnimSprint:setSpeed(1.1)
    else
        AnimSprint:setSpeed(horizontalVel*3.4)
    end
    -- Crouch Walking
    AnimCrouchWalk:setSpeed(horizontalVel*10)

    -- Handle Helmet/Hat visibility ---------------------------------------------
    if (string.find(player:getItem(6).id, "helmet") ~= nil) then
        vanilla_model.ARMOR:setVisible(false)
    else
        vanilla_model.ARMOR:setVisible(true)
    end

end

-- Render animation condtions using render function
function events.render(delta, context) --============================================================================================================================
    local crouching = player:getPose() == "CROUCHING"
    local swimming = player:isVisuallySwimming()
    local floating = player:isInWater()
    local sprinting = player:isSprinting()
    local walking = player:getVelocity().xz:length() > .001
    local climbing = player:isClimbing()
    local isGrounded = isOnGround(player)
    local sitting = player:getVehicle()
    local horseSitting = player:getVehicle() and (player:getVehicle():getType() == "minecraft:horse")
    local ridingMount = player:getVehicle() and (horseSitting or player:getVehicle():getType() == "minecraft:pig")
    local ridingSeat = player:getVehicle() and (player:getVehicle():getType() == "minecraft:minecart"
                                            or player:getVehicle():getType() == "minecraft:boat")

    -- Play animation under certain conditions ----------------------------------

    -- Interacting with water
    if (floating or (swimming and floating)) then
        if (floating and not swimming and isGrounded) then
            -- On the ground, Underwater 
            if (crouching) then
                if (walking) then
                    state = "crouch walking"
                    stopBasicAnims({AnimCrouchWalk})
                    AnimCrouchWalk:play()
                else
                    state = "crouching"
                    stopBasicAnims({AnimCrouching, AnimIdle})
                    AnimIdle:play()
                    AnimCrouching:play()
                end
            elseif (not crouching) then
                if (walking and not crouching and not sprinting) then
                    state = "walking"
                    stopBasicAnims({AnimWalk, AnimJumping})
                    AnimWalk:play()
                else
                    state = "idle"
                    stopBasicAnims({AnimIdle, AnimJumping})
                    AnimIdle:play()
                end
            end
        elseif (floating and not swimming and not isGrounded) then
            state = "floatingAir"
            stopBasicAnims({AnimFloat})
            AnimFloat:play()
        elseif (swimming) then
            state = "swimming"
            stopBasicAnims({AnimSwim})
            AnimSwim:play()
        end
    else
        -- Outside of water
        if (isGrounded and (not ridingSeat and not sitting)) then
            -- On the ground
            if (crouching) then
                if (walking) then
                    state = "crouch walking"
                    stopBasicAnims({AnimCrouchWalk, AnimCrouchJumping})
                    AnimCrouchWalk:play()
                else
                    state = "crouching"
                    stopBasicAnims({AnimCrouching, AnimIdle})
                    AnimIdle:play()
                    AnimCrouching:play()
                end
            elseif (not crouching) then
                if (player:isVisuallySwimming()) then
                    if (not walking) then
                        state = "crawling"
                        stopBasicAnims({AnimCrawl})
                        AnimCrawl:play()
                    elseif (walking) then
                        state = "crawl walking"
                        stopBasicAnims({AnimCrawling})
                        AnimCrawling:play()
                    end
                elseif (walking and not crouching and not sprinting) then
                    state = "walking"
                    stopBasicAnims({AnimWalk, AnimJumping})
                    AnimWalk:play()
                elseif (sprinting) then
                    state = "sprinting"
                    stopBasicAnims({AnimSprint})
                    AnimSprint:play()
                else
                    state = "idle"
                    stopBasicAnims({AnimIdle, AnimJumping, AnimShortFalling})
                    AnimIdle:play()
                end
            end
        else
            -- Not on the ground
            if (climbing) then
                -- Interacting with ladder
                if (player:getVelocity()[2] ~= 0) then
                    state = "climbing"
                else
                    state = "holdingLadder"
                end
            elseif (sitting ~= nil) then
                -- Sitting/Riding
                if (ridingMount and walking) then
                    if (horseSitting) then
                        state = "ridingHorse"
                        stopBasicAnims({AnimHorseRiding})
                        AnimHorseRiding:play()
                    else
                        state = "sitting"
                        stopBasicAnims({AnimSit})
                        AnimSit:play()
                    end
                elseif (ridingSeat and walking) then
                    state = "sitting"
                    stopBasicAnims({AnimSit})
                    AnimSit:play()
                elseif (not walking and (sitting or ridingMount or ridingSeat)) then
                    if (horseSitting) then
                        state = "horseSitting"
                        stopBasicAnims({AnimHorseSit})
                        AnimHorseSit:play()
                    else
                        state = "sitting"
                        stopBasicAnims({AnimSit})
                        AnimSit:play()
                    end
                end
            else
                state = "inAir"
                stopBasicAnims({AnimJumping, AnimShortFalling, AnimCrouching, AnimCrouchWalk, AnimCrouchJumping})
            end
        end
    end

    -- Falling conditions
    --print((client:getSystemTime() % 10000) / 1000)
    if (state == "inAir" or state == "falling") then
        if (not startedFall) then
            startFallTime = client:getSystemTime() / 1000
            startedFall = true
        end
        fallTimer = (client:getSystemTime() / 1000 - startFallTime)

        if (fallTimer > 0.7) then
            state = "falling"
        end
    else
        startedFall = false
    end

    -- Crouching conditions
    if (state ~= oldState) then
        if (state == "crouching" and (oldState == "idle" or oldState == "inAir")) then
            AnimCrouch:play()
        elseif (oldState == "crouching" and state == "idle") then
            AnimUnCrouch:play()
        elseif (state == "crouch walking" and oldState == "walking") then
            AnimCrouch:play()
        elseif (oldState == "crouch walking" and state == "walking") then
            AnimUnCrouch:play()
        end
    end

    -- Jumping/InAir conditions
    if (state ~= oldState) then
        -- Stop Jump Sprinting
        if (AnimJumpMove1:isPlaying()) then
            AnimJumpMove1:stop()
            AnimJumpMoveStop1:play()
        elseif (AnimJumpMove2:isPlaying()) then
            AnimJumpMove2:stop()
            AnimJumpMoveStop2:play()
        end

        if (oldState == "sprinting" and state == "inAir" and player:getVelocity()[2] > 0) then
            -- Jump sprinting
            WhichJump(AnimJumpMove1, AnimJumpMove2)
        elseif (oldState == "inAir" and state == "falling") then
            -- Going into Long falling
            AnimJumping:stop()
            AnimShortFalling:stop()
            AnimFalling:play()
        elseif (AnimFalling:isPlaying()) then
            -- Stop long Falling
            AnimFalling:stop()
            AnimFallLand:play()
        elseif ((oldState == "idle" or oldState == "walking") and state == "inAir" and player:getVelocity()[2] > 0) then
            -- Going into Jumping
            AnimJump:play()
            AnimJumping:play()
        elseif ((oldState == "crouching" or oldState == "crouch walking") and state == "inAir" and player:getVelocity()[2] > 0) then
            -- Going into Crouch Jump
            AnimUnCrouch:play()
            AnimCrouchJumping:play()
        elseif (AnimCrouchJumping:isPlaying() and isGrounded) then
            -- Stop Crouch Jumping
            AnimCrouchJumping:stop()
            if (state == "crouching" or state == "crouch walking") then
                AnimCrouch:play()
            end
        elseif (AnimJumping:isPlaying() and isGrounded) then
            -- Stop Jumping
            AnimJumping:stop()
            AnimJumpLand:play()
        elseif ((oldState == "idle" or oldState == "walking" or oldState == "sprinting") and state == "inAir") then
            -- Going into short Falling
            AnimFall:play()
            AnimShortFalling:play()
        elseif (AnimShortFalling:isPlaying()) then
            -- Stop short Falling
            AnimShortFalling:stop()
            AnimShortLand:play()
        end
    end

    -- Climbing conditions
    local facing = world.getBlockState(player:getPos()):getProperties()["facing"]
    if (oldState ~= state) then
        -- play respective animation
        if (state == "climbing") then
            stopBasicAnims({AnimClimb})
            AnimClimb:play()
        elseif (state == "holdingLadder") then
            stopBasicAnims({AnimClimbHold})
            AnimClimbHold:play()
        else
            AnimClimb:stop()
            AnimClimbHold:stop()
        end
    end
    if (state == "climbing" or state == "holdingLadder") then
        -- rotate player towards ladder
        local rot
        if (facing == "south") then
            rot = player:getBodyYaw(delta)-180
        elseif (facing == "north") then
            rot = player:getBodyYaw(delta)
        elseif (facing == "west") then
            rot = player:getBodyYaw(delta)+90
        elseif (facing == "east") then
            rot = player:getBodyYaw(delta)-90
        end
        pModel:setOffsetRot(0,rot,0)
        --pModel.Upper:setRot(-player:getLookDir()[2]*45,0,0)

        -- rotate more when at top of ladder
        if (world.getBlockState(player:getPos()).id == "minecraft:ladder" and world.getBlockState(player:getPos():add(0,1,0)).id == "minecraft:air") then
            pModel.Upper:setRot(-player:getLookDir()[2]*45-35,0,0)
        else
            pModel.Upper:setRot(0,0,0)
        end
    else
        pModel:setOffsetRot(0,0,0)
        pModel.Upper:setRot(0,0,0)
    end

    -- print("---")
    -- print(state)
    -- if (state ~= oldState) then
    --     print(oldState, "->", state)
    -- end

    oldState = state
end

-- Physics variables ====================================================================================
local rArm = squassets.BERP:new()
local lArm = squassets.BERP:new()
local head = squassets.BERP:new()

-- "delta" is the percentage between the last and the next tick (as a decimal value, 0.0 to 1.0)
-- "context" is a string that tells from where this render event was called (the paperdoll, gui, player render, first person)
function events.render(delta, context) --============================================================================================================

    -- First person hand model --------------------------------------------------
    if (player:isLeftHanded()) then
        vanilla_model.LEFT_ARM:setVisible(renderer:isFirstPerson() and context == "FIRST_PERSON")
        vanilla_model.RIGHT_ARM:setVisible(false)
    else
        vanilla_model.RIGHT_ARM:setVisible(renderer:isFirstPerson() and context == "FIRST_PERSON")
        vanilla_model.LEFT_ARM:setVisible(false)
    end

    -- Physics handling ---------------------------------------------------------
    local vel = squassets.forwardVel()
	local yvel = squassets.verticalVel()
    local headRot = (modelHead:getOffsetRot()+180)%360-180
    local armTarget
    local headTarget

    -- Arm physics --------------------------------------------------------------
    modelRightArm:setRot(0, 0, rArm.pos*2)
    modelLeftArm:setRot(0, 0, -lArm.pos*2)
	armTarget = -yvel * 80
    if (armTarget > 30) then
        armTarget = 30
    elseif (armTarget < -3) then
        armTarget = -3
    end

    rArm:berp(armTarget, 0.25, 0.01, 0.2)
    lArm:berp(armTarget, 0.25, 0.01, 0.2)

    -- Head physics -------------------------------------------------------------
    modelHead:setRot(head.pos*1.5, 0, 0)
    headTarget = -yvel * 20
    if (headTarget > 20) then
        headTarget = 20
    elseif (headTarget < -10) then
        headTarget = -10
    end

    if (-yvel*20 > -10) then
        head:berp(headTarget, 0.25, 0.01, 0.2)
    end

end

-- Sheathing weapon
local task

local syncedItemID
local oldItemID

local syncedPlayerSlot
local oldSlot

local currWeapon
local oldWeapon

local taskRotation
local taskPosition

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

function events.entity_init() --=====================================================================================================================
    task = pModel.Upper.body.SheathedWeapon:newItem("weapon")
    task:setDisplayMode("THIRD_PERSON_RIGHT_HAND")
end

if (host:isHost()) then
    local eventOldItemId
    function events.render()
        if (sheathOption) then
            -- Sync item id and damage value
            local itemInFirst = host:getSlot(0)
            local itemInFirstStack = itemInFirst:toStackString()

            local itemID
            local customModelData = itemInFirst["tag"]["CustomModelData"]

            if (customModelData ~= nil) then
                itemID = itemInFirst.id.."{CustomModelData:"..customModelData.."}"
                local classItem = CheckClassItem(itemInFirstStack)

                -- Edit scale and rotation depending on its customModelData value
                if (classItem == "Warrior/Knight") then  -- (data = 445->507)
                    if (NumInArray(customModelData, {448, 449, 470, 473, 476})) then
                        -- Scythe
                        task:setPos(0, 15, 4)
                        task:setRot(0, 270, 50)
                        if (customModelData == 449) then -- Air Scythe
                            task:setPos(5, 15, 4)
                        end
                    elseif (NumInArray(customModelData, {475, 482, 488, 494, 497, 498, 502, 505})) then
                        -- Sword
                        task:setPos(5, 25, 4)
                        task:setRot(0, 90, 135)
                    else
                        -- Spear
                        task:setPos(0, 20, 4)
                        task:setRot(0, 90, 125)
                        if (customModelData == 503) then
                            task:setPos(0, 20, 5)
                        end
                    end
                elseif (classItem == "Mage/Dark Wizard") then  -- (data = 312->378)
                    if (NumInArray(customModelData, {323, 326, 335, 344, 349, 350, 357, 363, 366, 374})) then
                        -- Short Wand
                        task:setPos(5, 25, 4)
                        task:setRot(0, 90, 135)
                        if (customModelData == 366) then -- Lantern Wand
                            task:setPos(-3, 18, 4)
                            task:setRot(0, 270, 57)
                        end
                    else
                        -- Wand
                        task:setPos(0, 20, 4)
                        task:setRot(0, 90, 125)
                    end
                elseif (classItem == "Assassin/Ninja") then  -- (data = 246->311)
                    if (NumInArray(customModelData, {246, 247, 254, 267, 270, 285, 289, 298, 305})) then
                        -- Short Dagger
                        task:setPos(4.9, 12, -2)
                        task:setRot(120, 0, 0)
                        if (customModelData == 267) then -- Enchanted Dagger
                            task:setPos(3, 25, 4)
                            task:setRot(90, 80, 233)
                        elseif (customModelData == 270) then -- Nunchucks
                            task:setPos(4.5, 8, -2)
                            task:setRot(30, 0, 0)
                        elseif (customModelData == 289) then -- Pan
                            task:setPos(5, 25, 5)
                            task:setRot(0, 0, 130)
                        elseif (customModelData == 298) then -- Saxaphone
                            task:setPos(0, 20, 6)
                            task:setRot(45, 88, 0)
                        elseif (customModelData == 305) then -- Enchanted Sword
                            task:setPos(5, 25, 5)
                        task:setRot(0, 80, 135)
                        end
                    elseif (NumInArray(customModelData, {251, 252, 253, 257, 258, 259, 268, 279, 301, 311})) then
                        -- Front Claw
                        task:setPos(0, 20, 5.5)
                        task:setRot(90, 0, 320)
                    elseif (NumInArray(customModelData, {291, 297, 308})) then
                        -- Side Claw
                        task:setPos(0, 18, 5.5)
                        task:setRot(90, 90, 320)
                        if (customModelData == 308) then -- Tesla Claw
                            task:setPos(3, 18, 4.8)
                            task:setRot(90, 80, 320)
                        end
                    else
                        -- Dagger
                        task:setPos(5, 25, 4)
                        task:setRot(0, 90, 130)
                    end
                elseif (classItem == "Archer/Hunter") then  -- (data = 182->245)
                    if (NumInArray(customModelData, {187, 188, 189, 204, 206, 213, 234, 240, 243})) then
                        -- Crossbows
                        task:setPos(3, 20, 4)
                        task:setRot(90, 0, 315)
                        if (customModelData == 206) then -- Boltslinger Repeater
                            task:setPos(1, 23, 4)
                            task:setRot(110, 0, 315)
                        elseif (customModelData == 213) then -- Crimson Crossbow
                            task:setRot(100, 0, 315)
                        elseif (customModelData == 240) then -- Spectral Crossbow
                            task:setRot(80, 0, 315)
                        elseif (customModelData == 243) then -- Slingshot
                            task:setPos(6.5, 10, 0)
                            task:setRot(0, 90, 0)
                        end
                    elseif (NumInArray(customModelData, {209, 211, 232, 236, 239})) then
                        -- Hand Cannon
                        task:setPos(3, 23, 4)
                        task:setRot(90, 0, 315)
                        if (customModelData == 209) then -- Brawler Blunderbuss
                            task:setPos(2, 22, 4)
                            task:setRot(110, 0, 325)
                        elseif (customModelData == 232) then -- Flamethrower
                            task:setPos(-1, 18, 4)
                            task:setRot(-90, 0, 135)
                        elseif (customModelData == 211) then -- Flame Cannon
                            task:setRot(-90, 0, 135)
                        end
                    elseif (NumInArray(customModelData, {203, 215, 216, 219, 220, 228, 230, 233, 237, 238, 245})) then
                        -- Long Bow
                        task:setPos(3, 18, 4)
                        task:setRot(25, 90, 340)
                        if (customModelData == 219 or customModelData == 220 or customModelData == 228) then -- Dusack/Banana/Spiral
                            task:setPos(3, 16, 4)
                        elseif (customModelData == 233) then -- Harp
                            task:setPos(6, 14, 4)
                        elseif (customModelData == 237 or customModelData == 245) then -- Futuristic/Tropical
                            task:setPos(1, 16, 4)
                            task:setRot(25, 90, 330)
                        end
                    else
                        -- Bows
                        task:setPos(6, 17.5, 4)
                        task:setRot(25, 90, 340)
                    end
                elseif (classItem == "Shaman/Skyseer") then -- (data = 379->444)
                    if (NumInArray(customModelData, {403, 415, 433, 435, 438, 440, 442, 444})) then
                        -- Lantern
                        task:setPos(5, 16, 0)
                        task:setRot(0, 90, -30)
                        if (customModelData == 415) then -- Dynasty Fan 
                            task:setPos(4, 23, 4)
                            task:setRot(0, 65, 140)
                        elseif (customModelData == 433) then -- Pan Pipes
                            task:setPos(5, 14, -1)
                            task:setRot(0, 0, 0)
                        elseif (customModelData == 435) then -- Ritualist Focus
                            task:setPos(-3, 15, 4)
                            task:setRot(0, 270, 60)
                        elseif (customModelData == 440) then -- Summoner's Marionette
                            task:setPos(2, 19, 5)
                            task:setRot(0, 280, 65)
                        elseif (customModelData == 442 or customModelData == 444) then -- Voodoo Dolls
                            task:setPos(3, 15, 5)
                            task:setRot(10, 280, 0)
                        end
                    else
                        -- Relik
                        task:setPos(4, 20, 4)
                        task:setRot(0, 270, 135)
                        if (NumInArray(customModelData, {421, 422, 424, 427, 428})) then -- Hand Offset Models
                            task:setPos(4, 20, 2)
                            task:setRot(0, 270, 135)
                        end
                    end
                end

                -- Hand Offset Models
                if (NumInArray(customModelData, {202, 221, 224, 225, 227, 230, 231, 274, 282, 286, 290, 293, 296, 333, 352, 355, 356, 358, 361, 362, 465, 483, 486, 487, 489, 492, 493, 505})) then
                    task:setPos(task:getPos().x, task:getPos().y, 6)
                end
            end

            -- ping only when item has changed
            if (eventOldItemId == itemInFirst) then
                return
            end
            eventOldItemId = itemInFirst

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
        if (not player:isLoaded() or host:getScreen() ~= nil or isActionWheelOpen) then
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
    if (sheathOption) then
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

-- Action Wheel =========================================================================================

function SheathWeapon(bool)
    sheathOption = bool
end
pings.actionSheath = SheathWeapon

function IdleAnimation(bool)
    idleAnimations = bool
end
pings.actionIdleAnims = IdleAnimation

function pings.taunt1Dance()
    StopAllIdle()
    AnimTaunt1:play()
end

function pings.taunt2Nod()
    Rand = math.random(0,1)
    if (Rand == 0) then
        AnimTaunt2b:stop()
        AnimTaunt2a:restart()
    else
        AnimTaunt2a:stop()
        AnimTaunt2b:restart()
    end
end

function pings.taunt3JumpingJacks()
    StopAllIdle()
    AnimTaunt3:play()
end

function pings.taunt4Inspect()
    StopAllIdle()
    AnimTaunt4:play()
end

function pings.taunt5KickDirt()
    StopAllIdle()
    AnimIdling1:play()
end

function pings.taunt6Look()
    StopAllIdle()
    AnimIdling2:play()
end

function pings.taunt7Wait()
    StopAllIdle()
    AnimIdling3:play()
end

local mainPage = action_wheel:newPage("Taunts")
local settingPage = action_wheel:newPage("Settings")
action_wheel:setPage(mainPage)

local toSettings = mainPage:newAction()
    :title("Go to settings")
    :item("minecraft:writable_book")
    :onLeftClick(function()
    action_wheel:setPage(settingPage)
end)

local toTaunts = settingPage:newAction()
    :title("Go to Taunts")
    :item("minecraft:writable_book")
    :onLeftClick(function()
    action_wheel:setPage(mainPage)
end)

local taunt1 = mainPage:newAction()
    :title("Dance")
    :item("minecraft:music_disc_chirp")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt1Dance)

local taunt2 = mainPage:newAction()
    :title("Nod")
    :item("minecraft:player_head")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt2Nod)

local taunt3 = mainPage:newAction()
    :title("Jumping Jacks")
    :item("minecraft:feather")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt3JumpingJacks)

local taunt4 = mainPage:newAction()
    :title("Inspect Item")
    :item("minecraft:experience_bottle")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt4Inspect)

local taunt5 = mainPage:newAction()
    :title("Boredom")
    :item("minecraft:enchanted_book")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt5KickDirt)

local taunt6 = mainPage:newAction()
    :title("Look Around")
    :item("minecraft:ender_eye")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt6Look)

local taunt7 = mainPage:newAction()
    :title("Wait")
    :item("minecraft:clock")
    :hoverColor(1, 1, 1)
    :onLeftClick(pings.taunt7Wait)

local setting1 = settingPage:newAction()
    :title("Enable Sheath")
    :toggleTitle("Disable Sheath")
    :item("minecraft:diamond_sword")
    :hoverColor(1, 1, 1)
    :onToggle(pings.actionSheath)
    :toggled(sheathOption)

local setting2 = settingPage:newAction()
    :title("Enable Idle Animations")
    :toggleTitle("Disable Idle Animations")
    :item("minecraft:armor_stand")
    :hoverColor(1, 1, 1)
    :onToggle(pings.actionIdleAnims)
    :toggled(idleAnimations)

local setting3 = settingPage:newAction()
local setting4 = settingPage:newAction()
local setting5 = settingPage:newAction()
local setting6 = settingPage:newAction()