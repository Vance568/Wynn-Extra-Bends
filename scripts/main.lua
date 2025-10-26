-- ///////////////////////////////////////////////////////////////// --
--                          Wynn Extra Bends
--                              Vance568
--                                v1.3
--
--   Helper Library Authors: Jimmy H., GrandpaScout, Squishy, Katt962
-- ///////////////////////////////////////////////////////////////// --

require("scripts/animationParts")
require("scripts/blockbenchParts")
require("scripts/customArmorModule")
require("scripts/customSwingModule")
require("scripts/customSpellModule")
require("scripts/customIdleModule")
require("scripts/customMovementModule")
require("scripts/customPhysicsModule")
require("scripts/customHolsterModule")
require("scripts/actionWheel")

-- Initial model conditions
function events.entity_init()

    -- Hide vanilla model
    vanilla_model.PLAYER:setVisible(false)
    vanilla_model.CAPE:setVisible(false)

    -- Set player textures
    PModel:setPrimaryTexture("SKIN")
    ModelCape:setPrimaryTexture("CAPE")

    -- Set arm type
    if (player:getModelType() == "DEFAULT") then
        ModelLeftArm.Bicep_Default_L:setVisible(true)
        ModelLeftArm.Bicep_Slim_L:setVisible(false)
        ModelLeftArm.Elbow_L.Limb_Default_L:setVisible(true)
        ModelLeftArm.Elbow_L.Limb_Slim_L:setVisible(false)

        ModelRightArm.Bicep_Default_R:setVisible(true)
        ModelRightArm.Bicep_Slim_R:setVisible(false)
        ModelRightArm.Elbow_R.Limb_Default_R:setVisible(true)
        ModelRightArm.Elbow_R.Limb_Slim_R:setVisible(false)
    else
        ModelLeftArm.Bicep_Default_L:setVisible(false)
        ModelLeftArm.Bicep_Slim_L:setVisible(true)
        ModelLeftArm.Elbow_L.Limb_Default_L:setVisible(false)
        ModelLeftArm.Elbow_L.Limb_Slim_L:setVisible(true)

        ModelRightArm.Bicep_Default_R:setVisible(false)
        ModelRightArm.Bicep_Slim_R:setVisible(true)
        ModelRightArm.Elbow_R.Limb_Default_R:setVisible(false)
        ModelRightArm.Elbow_R.Limb_Slim_R:setVisible(true)
    end
end

-- Render model conditions by in game ticks
function events.tick()

    -- Handle crouch model position
    if (player:getPose() == "CROUCHING") then
        PModel:setPos(0,2,0)
        ModelCape:setPos(0,2,0)
    else
        PModel:setPos(0,0,0)
        ModelCape:setPos(0,0,0)
    end

    -- Handle Helmet/Hat visibility
    if (string.find(player:getItem(6).id, "helmet") ~= nil) then
        vanilla_model.ARMOR:setVisible(false)
    else
        vanilla_model.ARMOR:setVisible(true)
    end

    -- Skin layer visibility
    ModelJacket:setVisible(player:isSkinLayerVisible("JACKET"))
    ModelHat:setVisible(player:isSkinLayerVisible("HAT"))
    ModelRightArmDefaultSleeveUpper:setVisible(player:isSkinLayerVisible("RIGHT_SLEEVE"))
    ModelRightArmDefaultSleeveLower:setVisible(player:isSkinLayerVisible("RIGHT_SLEEVE"))
    ModelRightArmSlimSleeveUpper:setVisible(player:isSkinLayerVisible("RIGHT_SLEEVE"))
    ModelRightArmSlimSleeveLower:setVisible(player:isSkinLayerVisible("RIGHT_SLEEVE"))
    ModelLeftArmDefaultSleeveUpper:setVisible(player:isSkinLayerVisible("LEFT_SLEEVE"))
    ModelLeftArmDefaultSleeveLower:setVisible(player:isSkinLayerVisible("LEFT_SLEEVE"))
    ModelLeftArmSlimSleeveUpper:setVisible(player:isSkinLayerVisible("LEFT_SLEEVE"))
    ModelLeftArmSlimSleeveLower:setVisible(player:isSkinLayerVisible("LEFT_SLEEVE"))
    ModelRightLegPantUpper:setVisible(player:isSkinLayerVisible("RIGHT_PANTS"))
    ModelRightLegPantLower:setVisible(player:isSkinLayerVisible("RIGHT_PANTS"))
    ModelLeftLegPantUpper:setVisible(player:isSkinLayerVisible("LEFT_PANTS"))
    ModelLeftLegPantLower:setVisible(player:isSkinLayerVisible("LEFT_PANTS"))

end

-- Render model condtions using render function
function events.render(delta, context)

    -- First person hand model
    if (player:isLeftHanded()) then
        vanilla_model.LEFT_ARM:setVisible(renderer:isFirstPerson() and context == "FIRST_PERSON")
        vanilla_model.RIGHT_ARM:setVisible(false)
    else
        vanilla_model.RIGHT_ARM:setVisible(renderer:isFirstPerson() and context == "FIRST_PERSON")
        vanilla_model.LEFT_ARM:setVisible(false)
    end

end