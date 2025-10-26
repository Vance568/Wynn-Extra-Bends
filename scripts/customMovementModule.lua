local PLAYER_WALK_SPEED = 4.5
local PLAYER_SPRINT_SPEED = 3.565
local PLAYER_CROUCH_WALK_SPEED = 15
local FALL_TIME = 0.75

local rightLeg = false
local wasSprintJup = false
local wasSprintJDown = false
local isSprintJup
local isSprintJDown

local fallTimer = 0
local startFallTime = 0
local startedFall = false
local yVel = 0
local oldYVel = 0

local isRidingHorse
local oldIsRidingHorse

local facing
local oldFacing

local blendClimb = true
local blendClimbDone = false
local climbBlendInRot
local climbBlendOutRot

local blendClimbTop = false
local climbTopBlendInRot
local climbTopBlendOutRot

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

function events.tick()

    -- Scales walk/run speed animation based on player vel --------------------
    local horizontalVel = player:getVelocity().x_z:length()
    local walkSpeed = horizontalVel * PLAYER_WALK_SPEED
    local sprintSpeed = horizontalVel * PLAYER_SPRINT_SPEED
    local crouchWalkSpeed = horizontalVel * PLAYER_CROUCH_WALK_SPEED

    -- Walking
    if (walkSpeed >= 1.5) then
        AnimWalk:setSpeed(1.5)
    elseif (walkSpeed <= 0.5) then
        AnimWalk:setSpeed(0.5)
    else
        AnimWalk:setSpeed(walkSpeed)
    end

    -- Sprinting
    if (sprintSpeed >= 1) then
        AnimSprint:setSpeed(1)
    elseif (sprintSpeed <= 0.5) then
        AnimSprint:setSpeed(0.5)
    else
        AnimSprint:setSpeed(sprintSpeed)
    end

    -- Crouch Walking
    if (crouchWalkSpeed >= 1) then
        AnimCrouchWalk:setSpeed(1)
    else
        AnimCrouchWalk:setSpeed(crouchWalkSpeed)
    end
end

function events.render(delta, context)

    -- Player Conditions --------------------------------------------------------
    local currItem = player:getHeldItem()
    local currItemStack = currItem:toStackString()
    local swimming = player:isVisuallySwimming()
    local floating = player:isInWater()
    local walking = player:getVelocity().xz:length() > .001
    local climbing = player:isClimbing()
    local isGrounded = isOnGround(player)
    local sitting = player:getVehicle()
    local ridingSeat = sitting and (sitting:getType() == "minecraft:minecart" or string.find(sitting:getType(), "boat"))

    -- Spirnt Jumping ---------------------------------------------------------
    isSprintJup = AnimSprintJumpUp:isPlaying()
    isSprintJDown = AnimSprintJumpDown:isPlaying()

    if wasSprintJup ~= isSprintJup and (isSprintJup and not isGrounded) then
        rightLeg = not rightLeg
        if (rightLeg) then
            AnimSprintJumpUp:setTime(0.0)
        else
            AnimSprintJumpUp:setTime(0.3)
        end
    end
    if wasSprintJDown ~= isSprintJDown and isSprintJDown then
        AnimSprintJumpDown:setTime(AnimSprintJumpUp:getTime())
    end

    wasSprintJup = isSprintJup and not isGrounded
    wasSprintJDown = isSprintJDown

    -- Falling condition --------------------------------------------------------
    local airState = not (floating or (swimming and floating)) and not isGrounded and not ridingSeat and not (ridingSeat and walking) and not sitting and not climbing

    if (airState) then
        if (not startedFall) then
            startFallTime = client:getSystemTime() / 1000
            startedFall = true
        end
        fallTimer = (client:getSystemTime() / 1000 - startFallTime)

        if (fallTimer > FALL_TIME) then
            AnimFreeFalling:play()
            AnimJumpingUp:stop()
            AnimJumpingDown:stop()
            AnimSprintJumpUp:stop()
            AnimSprintJumpDown:stop()
        end
    else
        if (AnimFreeFalling:isPlaying()) then
            AnimFreeFalling:stop()
            AnimLand:play()
        end
        startedFall = false
    end

    -- Horseback Riding ---------------------------------------------------------
    isRidingHorse = sitting and string.find(sitting:getType(), "horse")
    if (isRidingHorse) then
        AnimSit:stop()
        AnimSitPassenger:stop()
        if (walking) then
            AnimHorseSit:stop()
            AnimHorseRiding:play()
        else
            AnimHorseSit:play()
            AnimHorseRiding:stop()
        end
    elseif (not isRidingHorse and isRidingHorse ~= oldIsRidingHorse) then
        AnimHorseSit:stop()
        AnimHorseRiding:stop()
    end

    oldIsRidingHorse = isRidingHorse

    -- Climbing conditions ------------------------------------------------------
    facing = world.getBlockState(player:getPos()):getProperties()["facing"]

    local blockIsClimbable = string.find(world.getBlockState(player:getPos():add(0,0,0)).id, "vine") ~= nil or facing ~= nil
    local offBlockIsClimbable = string.find(world.getBlockState(player:getPos():add(0,0.33,0)).id, "vine") ~= nil
                            or string.find(world.getBlockState(player:getPos():add(0,0.33,0)).id, "ladder") ~= nil

    if (AnimClimb:isPlaying() or AnimClimbCrouch:isPlaying() or AnimClimbCrouchWalk:isPlaying()) then
        -- rotate player towards ladder
        local desiredRot
        if (facing == "south") then
            desiredRot = player:getBodyYaw(delta)-180
        elseif (facing == "north") then
            desiredRot = player:getBodyYaw(delta)
        elseif (facing == "west") then
            desiredRot = player:getBodyYaw(delta)+90
        elseif (facing == "east") then
            desiredRot = player:getBodyYaw(delta)-90
        else
            desiredRot = 0
        end

        if (blendClimb) then
            climbBlendInRot = 0
            blendClimb = false
        end

        climbBlendInRot = math.lerpAngle(climbBlendInRot, desiredRot, 0.075)
        if (not blendClimbDone) then
            PModel:setRot(0,climbBlendInRot,0)
        else
            PModel:setRot(0,desiredRot,0)
        end

        if (oldFacing ~= facing) then
            blendClimbDone = false
        end
        if (math.round(climbBlendInRot) == math.round(((desiredRot % 360) + 360) % 360)) then
            blendClimbDone = true
        end
        oldFacing = facing

        -- rotate upper body when at top of ladder
        local upperBlock = world.getBlockState(player:getPos():add(0,1,0)).id
        local upperBlockOff = world.getBlockState(player:getPos():add(0,1.33,0)).id
        local desiredUpperRot = 0
        if (offBlockIsClimbable and upperBlockOff == "minecraft:air") then
            if (player:getPos()[2] < 0) then
                desiredUpperRot = ((math.abs(player:getPos()[2]+0.33) % 1) * 60) - 60
            else
                desiredUpperRot = -((math.abs(player:getPos()[2]+0.33) % 1) * 60)
            end
        elseif (blockIsClimbable and upperBlock == "minecraft:air") then
            desiredUpperRot = 300
        end
        desiredUpperRot = ((desiredUpperRot % 360) + 360) % 360

        if (blendClimbTop) then
            climbTopBlendInRot = 0
            blendClimbTop = false
        end

        if (climbTopBlendInRot == nil) then
            climbTopBlendInRot = 0
        else
            climbTopBlendInRot = math.lerpAngle(climbTopBlendInRot, desiredUpperRot, 0.075)
        end
        PModel.Upper:setRot(climbTopBlendInRot,0,0)

    else
        -- blend out of rotation toward ladder
        blendClimbDone = false
        if (not blendClimb) then
            climbBlendOutRot = climbBlendInRot
            blendClimb = true
        end
        if (blendClimb and climbBlendOutRot ~= nil) then
            climbBlendOutRot = math.lerpAngle(climbBlendOutRot, 0, 0.075)
            PModel:setRot(0,climbBlendOutRot,0)
        else
            PModel:setRot(0,0,0)
        end

        -- blend upper body out of rotation at top of ladder 
        if (not blendClimbTop) then
            climbTopBlendOutRot = climbTopBlendInRot
            blendClimbTop = true
        end
        if (blendClimbTop and climbTopBlendOutRot ~= nil) then
            climbTopBlendOutRot = math.lerpAngle(climbTopBlendOutRot,0,0.075)
            PModel.Upper:setRot(climbTopBlendOutRot,0,0)
        else
            PModel.Upper:setRot(0,0,0)
        end

    end
end