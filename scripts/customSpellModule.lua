local HUD_UNICODE_EXPRESSION = "\xEE[\x80-\xBF]*"
local SPELL_CODES_START = 0x0100
local SPELL_CODES_END = 0x0105

local spellChars = {"L","R","-"}
local spellArray = {"-", "-", "-"}

local allSpells = {
    Warrior = {
        RLR = "Bash",
        RLL = "Uppercut",
        RRL = "WarScream",
        RRR = "Charge"
    },
    Mage = {
        RLR = "Heal",
        RLL = "Meteor",
        RRL = "IceSnake",
        RRR = "Teleport"
    },
    Assassin = {
        RLR = "SpinAttack",
        RLL = "MultiHit",
        RRL = "SmokeBomb",
        RRR = "Dash"
    },
    Shaman = {
        RLR = "Totem",
        RLL = "Aura",
        RRL = "Uproot",
        RRR = "Haul"
    },
    Archer = {
        LRL = "ArrowStorm",
        LRR = "ArrowBomb",
        LLR = "ArrowShield",
        LLL = "Escape"
    }
}

local foundSpell = false
local spellToPing
local oldSpellToPing
local currentSpell
local oldCurrentSpell

function IsSpellCastingAnimation()
    for i = 1, #AllSpellAnimations do
        if (AllSpellAnimations[i]:isPlaying()) then
            return true
        end
    end
    return false
end

function IsMiddleSpellCast()
    if (currentSpell == nil or WeaponClass == nil) then
        return false
    end

    if ((string.sub(currentSpell, 1, 1) ~= '-' or string.sub(currentSpell, 2, 2) ~= '-') and string.sub(currentSpell, 3, 3) == '-') then
        return true
    end
    return false
end

local function StopAllSwingAnimations()
    for i = 1, #AllSwingingAnimations do
        AllSwingingAnimations[i]:stop()
        GSBlend.stopBlend(AllSwingingAnimations[i])
    end
end

local function StopAllSpellAnimations()
    for i = 1, #AllSpellAnimations do
        AllSpellAnimations[i]:stop()
        GSBlend.stopBlend(AllSpellAnimations[i])
    end
end

local function CheckSpellAction(class, spellCombo)
    local classSpells = allSpells[class]
    if classSpells then
        return classSpells[spellCombo]
    end
    return nil
end

local function playSpell(class, spell)
    local classSpellMap = {
        Warrior = {
            Bash = WarriorBash,
            Uppercut = WarriorUppercut,
            WarScream = WarriorScream
        },
        Mage = {
            Heal = MageHeal,
            Meteor = MageMeteor,
            IceSnake = MageIceSnake
        },
        Assassin = {
            SpinAttack = AssassinSpin,
            MultiHit = AssassinMultiHit,
            SmokeBomb = AssassinSmokeBomb
        },
        Shaman = {
            Totem = ShamanTotem,
            Aura = ShamanAura,
            Uproot = ShamanUproot,
        },
        Archer = {
            ArrowStorm = ArcherArrowStorm,
            ArrowBomb = ArcherArrowBomb,
            ArrowShield = ArcherArrowShield,
        }
    }

    local classSpellAnims = classSpellMap[class]
    if (classSpellAnims ~= nil and classSpellAnims[spell] ~= nil) then
        classSpellAnims[spell]:play()
    end
end

function pings.syncCurrentSpell(spellGiven)
    currentSpell = spellGiven
end

function events.tick()

    if (host:isHost()) then
        -- Parse Action Bar
        local actionBar = client:getActionbar()
        if (actionBar ~= nil) then
            -- Find Unicode for spells
            local input = 0
            foundSpell = false
            for unicode in string.gmatch(actionBar, HUD_UNICODE_EXPRESSION) do
                local bytes = #unicode

                if (bytes == 3) then
                    -- utf8 Conversion
                    local c1, c2, c3 = string.match(unicode, "^(.)(.)(.)$")
                    if (c1 == '\xEE') then
                        local hudCode = (c2:byte() % 0x40) * 0x40 + (c3:byte() % 0x40)

                        if (hudCode >= SPELL_CODES_START and hudCode <= SPELL_CODES_END) then
                            foundSpell = true
                            input = input + 1
                            spellArray[input] = spellChars[((hudCode - SPELL_CODES_START) % 3) + 1]
                        end
                    end
                end
            end

            if (foundSpell) then
                spellToPing = spellArray[1] .. spellArray[2] .. spellArray[3]
            else
                spellToPing = '---'
                foundSpell = false
            end
        end
    end

    -- Spell Animation Handling
    if (WeaponClass ~= nil and currentSpell ~= nil and currentSpell ~= oldCurrentSpell) then
        if (string.sub(currentSpell, 3, 3) ~= "-") then
            pings.syncCurrentSpell(currentSpell)
            local class = string.sub(WeaponClass, 0, string.find(WeaponClass, "/") - 1)
            local spell = CheckSpellAction(class, currentSpell)
            StopAllSpellAnimations()
            ResetIdle()

            playSpell(class, spell)
        end
    end

    if (IsSpellCastingAnimation()) then
        StopAllSwingAnimations()
    end

    oldCurrentSpell = currentSpell
end

function events.render(delta, context)

    -- Sync Spell Animation
    if (spellToPing ~= oldSpellToPing) then
        pings.syncCurrentSpell(spellToPing)
    end
    oldSpellToPing = spellToPing

end