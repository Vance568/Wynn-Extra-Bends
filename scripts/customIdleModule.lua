IdleAnimationSetting = true; -- Idle animation Setting

local idleTick = 0
local randTick = 400
local randAnim = nil

-- Is Player Taunting
local function IsTaunting()
    if (AnimTaunt1:isPlaying() or AnimTaunt3:isPlaying() or AnimTaunt4:isPlaying()) then
        return true
    end
    return false
end

-- Get random number between 400 and 600 that is also divisible by 80
local function GetRandIdleTick()
    local num = math.random(400, 600)
    while (num % 80 ~= 0) do
        num = math.random(400, 600)
    end
    return(num)
end

-- Reset Idle tick
function ResetIdle()
    idleTick = 0
    AnimIdling1:stop()
    AnimIdling2:stop()
    AnimIdling3:stop()
    AnimTaunt1:stop()
    AnimTaunt3:stop()
    AnimTaunt4:stop()
end

function events.tick()
    -- Idling -------------------------------------------------------------------
    if (IdleAnimationSetting) then
        if (AnimIdle:isPlaying()) then
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
            ResetIdle()
        end

        if (player:getSwingTime() ~= 0) then
            ResetIdle()
        end

        if (IsTaunting()) then
            idleTick = 0
        end
    elseif (not AnimIdle:isPlaying() or player:getSwingTime() ~= 0) then
        ResetIdle()
    end
end