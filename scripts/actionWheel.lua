IsActionWheelOpen = nil
local wheelCheck
local oldWheelCheck

function pings.syncAcitonWheel(bool)
    IsActionWheelOpen = bool
end

function events.render(delta, context)
    -- Is Action Wheel Open ---------------------------------------------------
    wheelCheck = action_wheel:isEnabled()
    if (wheelCheck ~= oldWheelCheck) then
        pings.syncAcitonWheel(wheelCheck)
    end
    oldWheelCheck = wheelCheck
end

-- Action Wheel Setting actions -----------------------------------------------
function SheathWeapon(bool)
    WeaponHolsterSetting = bool
end
pings.actionSheath = SheathWeapon

function IdleAnimation(bool)
    IdleAnimationSetting = bool
end
pings.actionIdleAnims = IdleAnimation

-- Action Wheel Taunt actions
function pings.taunt1Dance()
    if (not AnimTaunt1:isPlaying()) then
        ResetIdle()
        AnimTaunt1:play()
    end
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
    if (not AnimTaunt3:isPlaying()) then
        ResetIdle()
        AnimTaunt3:play()
    end
end

function pings.taunt4Inspect()
    if (not AnimTaunt4:isPlaying()) then
        ResetIdle()
        AnimTaunt4:play()
    end
end

function pings.taunt5KickDirt()
    if (not AnimIdling1:isPlaying()) then
        ResetIdle()
        AnimIdling1:play()
    end
end

function pings.taunt6Look()
    if (not AnimIdling2:isPlaying()) then
        ResetIdle()
        AnimIdling2:play()
    end
end

function pings.taunt7Wait()
    if (not AnimIdling3:isPlaying()) then
        ResetIdle()
        AnimIdling3:play()
    end
end

-- Action Wheel Page Elements -------------------------------------------------
local mainPage = action_wheel:newPage("Taunts")
local settingPage = action_wheel:newPage("Settings")
action_wheel:setPage(mainPage)

local toSettings = mainPage:newAction()
    :title("Go to Settings")
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
    :toggled(WeaponHolsterSetting)

local setting2 = settingPage:newAction()
    :title("Enable Idle Animations")
    :toggleTitle("Disable Idle Animations")
    :item("minecraft:armor_stand")
    :hoverColor(1, 1, 1)
    :onToggle(pings.actionIdleAnims)
    :toggled(IdleAnimationSetting)

local setting3 = settingPage:newAction()
    :title("Enable New Armor")
    :toggleTitle("Disable New Armor")
    :item("minecraft:diamond_chestplate")
    :hoverColor(1, 1, 1)
    :onToggle(pings.actionArmorTexture)
    :toggled(NewTextureSetting)

local setting4 = settingPage:newAction()
local setting5 = settingPage:newAction()
local setting6 = settingPage:newAction()
local setting7 = settingPage:newAction()