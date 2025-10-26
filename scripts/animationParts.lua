local anims = require("libraries/EZAnims")
GSBlend = require("libraries/GSAnimBlend")

anims:setOneJump(true)
anims:setFallVel(-0.6)

local animModel = anims:addBBModel(animations.model)
animModel:setBlendTimes(2,2)
BlendController = anims:addBBModel(animations.model)

local handType = "R"

-- Basic Actions --
AnimIdle = animations.model["idle"]
AnimIdle:setBlendCurve("easeInOutSine")
AnimIdling1 = animations.model["Idle_1"]
AnimIdling1:setBlendTime(2, 4)
AnimIdling1:setBlendCurve("easeInOutSine")
AnimIdling2 = animations.model["Idle_2"]
AnimIdling2:setBlendTime(2, 4)
AnimIdling2:setBlendCurve("easeInOutSine")
AnimIdling3 = animations.model["Idle_3"]
AnimIdling3:setBlendTime(2, 4)
AnimIdling3:setBlendCurve("easeInOutSine")

AnimWalk = animations.model["walk"]
AnimWalk:setBlendCurve("easeInOutSine")
AnimCrouching = animations.model["crouch"]
AnimCrouching:setBlendTime(4)
AnimCrouching:setBlendCurve("easeInOutSine")
AnimUnCrouchJUp = animations.model["crouchjumpup"]
AnimUnCrouchJUp:setBlendTime(4)
AnimUnCrouchJUp:setBlendCurve("easeInOutSine")
AnimCrouchJDown = animations.model["crouchjumpdown"]
AnimCrouchJDown:setBlendTime(5)
AnimCrouchJDown:setBlendCurve("easeInOutSine")
AnimCrouchWalk = animations.model["crouchwalk"]
AnimCrouchWalk:setBlendTime(4)
AnimCrouchWalk:setBlendCurve("easeInOutSine")

AnimCrawl = animations.model["crawlstill"]
AnimCrawling = animations.model["crawl"]

AnimFloat = animations.model["water"]
AnimFloat:setBlendTime(4)
AnimSwim = animations.model["swim"]
AnimSwim:setBlendTime(4)

AnimClimb = animations.model["climb"]
AnimClimb:setBlendTime(4)
AnimClimbCrouch = animations.model["climbcrouch"]
AnimClimbCrouch:setBlendTime(4)
AnimClimbCrouchWalk = animations.model["climbcrouchwalk"]
AnimClimbCrouchWalk:setBlendTime(4)

AnimJumpingUp = animations.model["jumpup"]
AnimJumpingUp:setBlendTime(4, 5)
AnimJumpingUp:setBlendCurve("easeOutQuad")
AnimJumpingDown = animations.model["jumpdown"]
AnimJumpingDown:setBlendTime(4, 5)
AnimJumpingDown:setBlendCurve("easeOutQuad")
AnimSprintJumpUp = animations.model["sprintjumpup"]
AnimSprintJumpUp:setBlendTime(6.5)
AnimSprintJumpDown = animations.model["sprintjumpdown"]
AnimSprintJumpDown:setBlendTime(6.5, 3)

AnimShortFalling = animations.model["Fall_0"]
AnimShortFalling:setBlendTime(5, 2)
AnimShortFalling:setBlendCurve("easeInOutSine")
AnimFreeFalling = animations.model["freeFall"]
AnimFreeFalling:setBlendTime(4, 3)
AnimLand = animations.model["land"]
AnimLand:setBlendTime(1)

AnimSprint = animations.model["sprint"]
AnimSprint:setBlendTime(2, 2)
AnimSprint:setBlendCurve("easeInOutSine")

AnimSit = animations.model["sit"]
AnimSit:setBlendTime(2, 2)
AnimSit:setBlendCurve("easeInOutSine")
AnimSitPassenger = animations.model["sitpass"]
AnimSitPassenger:setBlendTime(2, 2)
AnimSitPassenger:setBlendCurve("easeInOutSine")
AnimHorseSit = animations.model["sitHorse"]
AnimHorseSit:setBlendTime(2, 2)
AnimHorseSit:setBlendCurve("easeInOutSine")
AnimHorseRiding = animations.model["sitmoveHorse"]
AnimHorseRiding:setBlendTime(2, 2)
AnimHorseRiding:setBlendCurve("easeInOutSine")

-- Taunts --
AnimTaunt1 = animations.model["Taunt_1"]
AnimTaunt2a = animations.model["Taunt_2"]
AnimTaunt2b = animations.model["Taunt_3"]
AnimTaunt3 = animations.model["Taunt_4"]
AnimTaunt4 = animations.model["Taunt_5"]
AnimTaunt1:setBlendTime(3, 4)
AnimTaunt2a:setBlendTime(2, 4)
AnimTaunt2b:setBlendTime(2, 4)
AnimTaunt3:setBlendTime(2, 4)
AnimTaunt4:setBlendTime(2, 4)

-- Attack Swinging --
AnimCombatReady = animations.model["combatReady"]
AnimPunchR = animations.model["attackR"]
AnimPunchR:setBlendTime(1, 4)
AnimPunchR:setBlendCurve("easeInOutSine")
AnimMineR = animations.model["mineR"]
AnimMineR:setBlendTime(1, 5)
AnimMineR:setBlendCurve("easeInOutSine")

AnimPunchL = animations.model["attackL"]
AnimPunchL:setBlendTime(1, 4)
AnimPunchL:setBlendCurve("easeInOutSine")
AnimMineL = animations.model["mineL"]
AnimMineL:setBlendTime(1, 5)
AnimMineL:setBlendCurve("easeInOutSine")

AnimShieldR = animations.model["blockR"]
AnimShieldR:setBlendTime(2, 3)
AnimShieldR:setBlendCurve("easeInOutSine")
AnimShieldL = animations.model["blockL"]
AnimShieldL:setBlendTime(2, 3)
AnimShieldL:setBlendCurve("easeInOutSine")

AnimPickaxe1 = nil
AnimPickaxe2 = nil

AnimAxe1 = nil
AnimAxe2 = nil

AnimShovel1 = nil
AnimShovel2 = nil

AnimHoe1 = nil
AnimHoe2 = nil

AnimFishing1 = nil
AnimFishing2 = nil
AnimIsFishing = nil

WarriorSwing1 = nil
WarriorSwing2 = nil
WarriorSwing3 = nil

MageSwing1 = nil
MageSwing2 = nil
MageSwing3 = nil

AssassinSwing1 = nil
AssassinSwing2 = nil
AssassinSwing3 = nil
AssassinSwing4 = nil

ShamanSwing1 = nil
ShamanSwing2 = nil
ShamanSwing3 = nil

AnimBowShootHold = nil
ArcherShoot = nil
AnimCrossBowLoad = nil
AnimCrossBowHold = nil
AnimCrossBowShoot = nil

-- Wynncraft Spells --
WarriorBash = nil
WarriorUppercut = nil
WarriorScream = nil

MageHeal = nil
MageIceSnake = nil
MageMeteor = nil

AssassinSpin = nil
AssassinMultiHit = nil
AssassinSmokeBomb = nil

ArcherArrowStorm = nil
ArcherArrowBomb = nil
ArcherArrowShield = nil

ShamanTotem = nil
ShamanAura = nil
ShamanUproot = nil

-- Collections --
AllSwingingAnimations = nil
AllSpellAnimations = nil

-- Animation overrides
animModel:addExcluOverrider(AnimFreeFalling)
animModel:addIncluOverrider()

function events.tick()

    -- Set Hand
    handType = player:isLeftHanded() and "L" or "R"
    local mainHandItem = player:getHeldItem(false)
    local offhandItem = player:getHeldItem(true)

    local bowMainHand = string.find(mainHandItem.id, "bow") or (CheckClassItem(mainHandItem:toStackString()) == "Archer/Hunter")
    local bowOffHand = string.find(offhandItem.id, "bow") or (CheckClassItem(offhandItem:toStackString()) == "Archer/Hunter")
    local bowHeldInLeft = ((handType == "L" and bowMainHand) or (handType == "R" and bowOffHand)) and 1 or 0
    local bowHeldInRight = ((handType == "R" and bowMainHand) or (handType == "L" and bowOffHand)) and 1 or 0
    local activeBowHandType = ((bowHeldInLeft == 1) and "L") or ((bowHeldInRight == 1) and "R") or "R"

    local fishingRodMainHand = string.find(mainHandItem.id, "fishing_rod") or (CheckToolItem(mainHandItem:toStackString()) == "Fishing")
    local fishingRodOffHand = string.find(offhandItem.id, "fishing_rod") or (CheckToolItem(offhandItem:toStackString()) == "Fishing")
    local fishingRodHeldInLeft = ((handType == "L" and fishingRodMainHand) or (handType == "R" and fishingRodOffHand)) and 1 or 0
    local fishingRodHeldInRight = ((handType == "R" and fishingRodMainHand) or (handType == "L" and fishingRodOffHand)) and 1 or 0
    local activeFishingHandType = ((fishingRodHeldInLeft == 1) and "L") or ((fishingRodHeldInRight == 1) and "R") or "R"

    -- Warrior ------
    WarriorSwing1 = animations.model["Spear_Swing_1" .. handType]
    WarriorSwing1:setBlendTime(3,7)
    WarriorSwing1:setBlendCurve("easeInOutSine")
    WarriorSwing2 = animations.model["Spear_Swing_2" .. handType]
    WarriorSwing2:setBlendTime(4,7)
    WarriorSwing2:setBlendCurve("easeInOutSine")
    WarriorSwing3 = animations.model["Spear_Swing_3" .. handType]
    WarriorSwing3:setBlendTime(3,7)
    WarriorSwing3:setBlendCurve("easeOutSine")

    WarriorBash = animations.model["Warrior_bash" .. handType]
    WarriorBash:setBlendTime(3, 6)
    WarriorBash:setBlendCurve("easeOutQuad")
    WarriorUppercut = animations.model["Warrior_uppercut" .. handType]
    WarriorUppercut:setBlendTime(2, 8)
    WarriorUppercut:setBlendCurve("easeOutQuad")
    WarriorScream = animations.model["Warrior_scream" .. handType]
    WarriorScream:setBlendTime(3, 8)
    WarriorScream:setBlendCurve("easeInOutSine")

    -- Mage ---------
    MageSwing1 = animations.model["Wand_Wave_1" .. handType]
    MageSwing1:setBlendTime(3, 7)
    MageSwing1:setBlendCurve("easeInOutSine")
    MageSwing2 = animations.model["Wand_Wave_2" .. handType]
    MageSwing2:setBlendTime(3, 6.5)
    MageSwing2:setBlendCurve("easeInOutSine")
    MageSwing3 = animations.model["Wand_Wave_3" .. handType]
    MageSwing3:setBlendTime(3, 6.5)
    MageSwing3:setBlendCurve("easeInOutSine")

    MageHeal = animations.model["Mage_heal" .. handType]
    MageHeal:setBlendTime(3, 8)
    MageHeal:setBlendCurve("easeInOutSine")
    MageMeteor = animations.model["Mage_Meteor" .. handType]
    MageMeteor:setBlendTime(5, 10)
    MageMeteor:setBlendCurve("easeInOutSine")
    MageIceSnake = animations.model["Mage_IceSnake" .. handType]
    MageIceSnake:setBlendTime(2, 10)
    MageIceSnake:setBlendCurve("easeInOutSine")

    -- Assassin -----
    AssassinSwing1 = animations.model["Sword_Swing_1" .. handType]
    AssassinSwing1:setBlendTime(3, 5.5)
    AssassinSwing1:setBlendCurve("easeInOutSine")
    AssassinSwing2 = animations.model["Sword_Swing_2" .. handType]
    AssassinSwing2:setBlendTime(3, 5.5)
    AssassinSwing2:setBlendCurve("easeInOutSine")
    AssassinSwing3 = animations.model["Sword_Swing_3" .. handType]
    AssassinSwing3:setBlendTime(4, 5.5)
    AssassinSwing3:setBlendCurve("easeInOutSine")
    AssassinSwing4 = animations.model["Sword_Swing_4" .. handType]
    AssassinSwing4:setBlendTime(3, 5.5)

    AssassinSpin = animations.model["Assassin_Spin" .. handType]
    AssassinSpin:setBlendTime(1, 5.5)
    AssassinMultiHit = animations.model["Assassin_MultiHit" .. handType]
    AssassinMultiHit:setBlendTime(1, 8)
    AssassinMultiHit:setBlendCurve("easeInOutSine")
    AssassinSmokeBomb = animations.model["Assassin_SmokeBomb" .. handType]
    AssassinSmokeBomb:setBlendTime(2, 8)
    AssassinSmokeBomb:setBlendCurve("easeInOutSine")

    -- Shaman -------
    ShamanSwing1 = animations.model["Relik_Strike_1" .. handType]
    ShamanSwing1:setBlendTime(2, 7)
    ShamanSwing1:setBlendCurve("easeInOutSine")
    ShamanSwing2 = animations.model["Relik_Strike_2" .. handType]
    ShamanSwing2:setBlendTime(3, 6.5)
    ShamanSwing2:setBlendCurve("easeInOutSine")
    ShamanSwing3 = animations.model["Relik_Strike_3" .. handType]
    ShamanSwing3:setBlendTime(3, 8)
    ShamanSwing3:setBlendCurve("easeInOutSine")

    ShamanTotem = animations.model["Shaman_Totem" .. handType]
    ShamanTotem:setBlendTime(3, 6)
    ShamanTotem:setBlendCurve("easeInOutSine")
    ShamanAura = animations.model["Shaman_Aura" .. handType]
    ShamanAura:setBlendTime(6, 8)
    ShamanAura:setBlendCurve("easeInOutSine")
    ShamanUproot = animations.model["Shaman_Uproot" .. handType]
    ShamanUproot:setBlendTime(3, 8)
    ShamanUproot:setBlendCurve("easeInOutSine")


    -- Archer -------
    AnimBowShootHold = animations.model["bow" .. activeBowHandType]
    AnimBowShootHold:setBlendTime(3,1)
    AnimBowShootHold:setBlendCurve("easeInSine")
    ArcherShoot = animations.model["Bow_Shoot" .. activeBowHandType]
    ArcherShoot:setBlendTime(2, 4.5)
    ArcherShoot:setBlendCurve("easeOutSine")

    AnimCrossBowLoad = animations.model["load" .. activeBowHandType]
    AnimCrossBowLoad:setBlendTime(10,3)
    AnimCrossBowLoad:setBlendCurve("easeInOutSine")
    AnimCrossBowHold = animations.model["cross" .. activeBowHandType]
    AnimCrossBowHold:setBlendTime(4,0)
    AnimCrossBowHold:setBlendCurve("easeInSine")
    AnimCrossBowShoot = animations.model["Cross_Shoot" .. activeBowHandType]
    AnimCrossBowShoot:setBlendTime(0, 4.5)
    AnimCrossBowShoot:setBlendCurve("easeOutSine")

    ArcherArrowStorm = animations.model["Archer_ArrowStorm" .. handType]
    ArcherArrowStorm:setBlendTime(2, 8)
    ArcherArrowStorm:setBlendCurve("easeOutSine")
    ArcherArrowBomb = animations.model["Archer_ArrowBomb" .. handType]
    ArcherArrowBomb:setBlendTime(2, 8)
    ArcherArrowBomb:setBlendCurve("easeOutSine")
    ArcherArrowShield = animations.model["Archer_ArrowShield" .. handType]
    ArcherArrowShield:setBlendTime(2, 8)
    ArcherArrowShield:setBlendCurve("easeInOutSine")

    -- Mining -------
    AnimPickaxe1 = animations.model["pickaxe_1" .. handType]
    AnimPickaxe1:setBlendTime(2, 7)
    AnimPickaxe1:setBlendCurve("easeInOutSine")
    AnimPickaxe2 = animations.model["pickaxe_2" .. handType]
    AnimPickaxe2:setBlendTime(2, 7)
    AnimPickaxe2:setBlendCurve("easeInOutSine")

    -- Woodcutting --
    AnimAxe1 = animations.model["axe_1" .. handType]
    AnimAxe1:setBlendTime(3, 5)
    AnimAxe1:setBlendCurve("easeInOutSine")
    AnimAxe2 = animations.model["axe_2" .. handType]
    AnimAxe2:setBlendTime(3, 5)
    AnimAxe2:setBlendCurve("easeInOutSine")

    -- Shoveling ----
    AnimShovel1 = animations.model["shovel_1" .. handType]
    AnimShovel1:setBlendTime(3, 6)
    AnimShovel1:setBlendCurve("easeInOutSine")
    AnimShovel2 = animations.model["shovel_2" .. handType]
    AnimShovel2:setBlendTime(3, 6)
    AnimShovel2:setBlendCurve("easeInOutSine")

    -- Farming ------
    AnimHoe1 = animations.model["hoe_1" .. handType]
    AnimHoe1:setBlendTime(2, 5)
    AnimHoe1:setBlendCurve("easeInOutSine")
    AnimHoe2 = animations.model["hoe_2" .. handType]
    AnimHoe2:setBlendTime(2, 5)
    AnimHoe2:setBlendCurve("easeInOutSine")

    -- Fishing ------
    AnimFishing1 = animations.model["fishing_1" .. activeFishingHandType]
    AnimFishing1:setBlendTime(3, 6)
    AnimFishing1:setBlendCurve("easeInOutSine")
    AnimFishing2 = animations.model["fishing_2" .. activeFishingHandType]
    AnimFishing2:setBlendTime(3, 6)
    AnimFishing2:setBlendCurve("easeInOutSine")
    AnimIsFishing = animations.model["is_fishing" .. activeFishingHandType]
    AnimIsFishing:setBlendTime(6, 2)
    AnimIsFishing:setBlendCurve("easeInOutSine")

    -- Collections --
    AllSwingingAnimations = {
        AnimPunchR, AnimPunchL,
        AnimMineR, AnimMineL,
        AnimPickaxe1, AnimPickaxe2,
        AnimAxe1, AnimAxe2,
        AnimHoe1, AnimHoe2,
        AnimShovel1, AnimShovel2,
        AnimFishing1, AnimFishing2, AnimIsFishing,
        WarriorSwing1, WarriorSwing2, WarriorSwing3,
        MageSwing1, MageSwing2, MageSwing3,
        AssassinSwing1, AssassinSwing2, AssassinSwing3, AssassinSwing4,
        ShamanSwing1, ShamanSwing2, ShamanSwing3,
        ArcherShoot
    }

    for i = 1, #AllSwingingAnimations do
        AllSwingingAnimations[i]:setPriority(1)
    end

    AllSpellAnimations = {
        WarriorBash, WarriorUppercut, WarriorScream,
        MageHeal, MageMeteor, MageIceSnake,
        AssassinSpin, AssassinMultiHit, AssassinSmokeBomb,
        ArcherArrowStorm, ArcherArrowBomb, ArcherArrowShield,
        ShamanTotem, ShamanAura, ShamanUproot
    }

    for i = 1, #AllSpellAnimations do
        AllSpellAnimations[i]:setPriority(1)
    end

end