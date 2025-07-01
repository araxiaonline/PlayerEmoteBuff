print("[Eluna] Class Emote Buffs loaded")

local PLAYER_EVENT_ON_TEXT_EMOTE = 24
local COOLDOWN_SECONDS = 7200  -- 2 hours cooldown
local cooldowns = {}

-- Class-based configuration
local classConfig = {
    [1] = { -- Warrior
        emote = 136, -- /taunt
        buffs = {23735, 23737, 23767}, -- Strength, Stamina, Armor
        message = "You taunt your enemies, daring them to try their luck."
    },
    [2] = { -- Paladin
        emote = 78, -- /salute
        buffs = {23767, 23735, 23738}, -- Armor, Strength, Spirit
        message = "You raise your hand in salute, a beacon of righteous order."
    },
    [3] = { -- Hunter
        emote = 44, -- /gaze (fallback to /salute)
        buffs = {23736, 23769, 23768}, -- Agility, Resistance, Damage
        message = "You scan the horizon, locking eyes with your next prey."
    },
    [4] = { -- Rogue
        emote = 131, -- /smirk
        buffs = {23736, 23735, 23768}, -- Agility, Strength, Damage
        message = "You smirk knowingly. They never saw you coming."
    },
    [5] = { -- Priest
        emote = 74, -- /pray
        buffs = {23738, 23766, 23769}, -- Spirit, Intelligence, Resistance
        message = "You kneel and murmur a forgotten prayer, feeling your deity’s gaze linger upon you for but a moment."
    },
    [6] = { -- Death Knight
        emote = 98, -- /threat
        buffs = {23735, 23737, 23767}, -- Strength, Stamina, Armor
        message = "You dare challenge the power of the Scourge?"
    },
    [7] = { -- Shaman
        emote = 407, -- /mutter
        buffs = {23769, 23738, 23766}, -- Resistance, Spirit, Intelligence
        message = "You mutter an invocation to the elemental spirits."
    },
    [8] = { -- Mage
        emote = 120, -- /ponder
        buffs = {23766, 23738, 23768}, -- Intelligence, Spirit, Damage
        message = "You stroke your chin, unraveling arcane mysteries."
    },
    [9] = { -- Warlock
        emote = 20, -- /cackle
        buffs = {23768, 23766, 23769}, -- Damage, Intelligence, Resistance
        message = "You cackle madly as shadow energies gather around you."
    },
    [11] = { -- Druid
        emote = 75, -- /roar
        buffs = {23738, 23736, 23737}, -- Spirit, Agility, Stamina
        message = "You let out a primal roar, channeling the wilds within."
    }
}

local function OnClassPrayer(event, player, textEmote, emoteNum, guid)
    local classId = player:GetClass()
    local config = classConfig[classId]
    if not config then return end

    if textEmote ~= config.emote then return end

    local guid = player:GetGUIDLow()
    local now = os.time()
    local last = cooldowns[guid] or 0

    if now - last < COOLDOWN_SECONDS then
        local remaining = COOLDOWN_SECONDS - (now - last)
        local mins = math.floor(remaining / 60)
        local secs = remaining % 60
        player:SendBroadcastMessage(string.format("|cffff0000You must wait %d minutes and %d seconds before invoking your ritual again.", mins, secs))
        return
    end

    cooldowns[guid] = now

    local buffId = config.buffs[math.random(1, #config.buffs)]
    player:AddAura(buffId, player)
    player:SendBroadcastMessage(config.message)
end

RegisterPlayerEvent(PLAYER_EVENT_ON_TEXT_EMOTE, OnClassPrayer)
