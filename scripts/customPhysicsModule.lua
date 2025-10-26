require("scripts/blockbenchParts")
local squapi = require("libraries/SquAPI")
local squassets = require("libraries/SquAssets")

squapi.smoothHead:new({ModelHead, ModelMainBody}, {0.6, 0.25}, 0.1, 1.75, false)

local rArm = squassets.BERP:new()
local lArm = squassets.BERP:new()
local head = squassets.BERP:new()

function events.render(delta, context)

    -- Physics handling ---------------------------------------------------------
	local yvel = squassets.verticalVel()
    local xvel = squassets.forwardVel()
    local armTarget
    local headTarget

    -- Arm physics --------------------------------------------------------------
    ModelRightArm:setRot(0, 0, rArm.pos*2)
    ModelLeftArm:setRot(0, 0, -lArm.pos*2)
	armTarget = -yvel * 80
    if (armTarget > 30) then
        armTarget = 30
    elseif (armTarget < -3) then
        armTarget = -3
    end

    if (IsSwinging or IsCastingSpell) then
        rArm:berp(0, 0.25, 0.01, 0.2)
        lArm:berp(0, 0.25, 0.01, 0.2)
    else
        rArm:berp(armTarget, 0.25, 0.01, 0.2)
        lArm:berp(armTarget, 0.25, 0.01, 0.2)
    end

    -- Head physics -------------------------------------------------------------
    ModelHead:setRot(head.pos*2, 0, 0)
    headTarget = -yvel * 20
    if (headTarget > 20) then
        headTarget = 20
    elseif (headTarget < -10) then
        headTarget = -10
    end

end