ProcEmData = {}

-- Detection types
ProcEmData.DETECTION = {
    COMBAT_LOG = 1,      -- Parse combat log messages
    BUFF = 2,            -- Scan for buff/debuff
    ABILITY_READY = 3,   -- Ability becomes usable
}

-- Proc categories
ProcEmData.CATEGORY = {
    WEAPON = "Weapon",
    ENCHANT = "Enchant",
    TALENT = "Talent",
    ABILITY = "Ability",
    TRINKET = "Trinket",
}

-- Default proc database
ProcEmData.Procs = {
    -- Weapon Procs
    ["Nightfall"] = {
        name = "Nightfall",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Spell Vulnerability",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {0.5, 0, 0.8},
        sound = "LevelUp",
        enabled = true,
    },
    ["Hand of Justice"] = {
        name = "Hand of Justice",
        category = ProcEmData.CATEGORY.TRINKET,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain 1 extra attack",
        event = "CHAT_MSG_SPELL_SELF_BUFF",
        color = {1, 0.8, 0},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Ironfoe"] = {
        name = "Ironfoe",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain 2 extra attacks",
        event = "CHAT_MSG_SPELL_SELF_BUFF",
        color = {0.7, 0.7, 0.7},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Thrash Blade"] = {
        name = "Thrash Blade",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Thrash Blade",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {0.8, 0.2, 0.2},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Eskhandar's Right Claw"] = {
        name = "Eskhandar's Right Claw",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Eskhandar's Rage",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {0, 1, 0},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Flurry Axe"] = {
        name = "Flurry Axe",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Flurry",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {0.2, 0.8, 1},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Bonereaver's Edge"] = {
        name = "Bonereaver's Edge",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = ".* is afflicted by Bonereaver's Edge",
        event = "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
        color = {0.6, 0.3, 0},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Thunderfury"] = {
        name = "Thunderfury",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = ".* is afflicted by Thunderfury",
        event = "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
        color = {0, 0.5, 1},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Deathbringer"] = {
        name = "Deathbringer",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Deathbringer",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {0.4, 0, 0.4},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Sulfuras"] = {
        name = "Sulfuras",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Sulfuras",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {1, 0.4, 0},
        sound = "LEVELUPSOUND",
        enabled = true,
    },

    -- Enchant Procs
    ["Crusader"] = {
        name = "Crusader",
        category = ProcEmData.CATEGORY.ENCHANT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Crusader",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {1, 0.9, 0.3},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Lifestealing"] = {
        name = "Lifestealing",
        category = ProcEmData.CATEGORY.ENCHANT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Lifestealing",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {0.5, 0, 0},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Fiery Weapon"] = {
        name = "Fiery Weapon",
        category = ProcEmData.CATEGORY.ENCHANT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Fiery Weapon",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {1, 0.3, 0},
        sound = nil,
        enabled = true,
    },

    -- Talent/Ability Procs
    ["Windfury Totem"] = {
        name = "Windfury Totem",
        category = ProcEmData.CATEGORY.ABILITY,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain 1 extra attack through Windfury",
        event = "CHAT_MSG_SPELL_SELF_BUFF",
        color = {0.3, 0.7, 1},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Sword Specialization"] = {
        name = "Sword Specialization",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain 1 extra attack",
        event = "CHAT_MSG_SPELL_SELF_BUFF",
        color = {0.8, 0.8, 0.8},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Mace Specialization"] = {
        name = "Mace Specialization",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = ".* is stunned",
        event = "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
        color = {0.6, 0.4, 0.2},
        sound = "LEVELUPSOUND",
        enabled = false, -- Can be noisy
    },
    ["Flurry"] = {
        name = "Flurry",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Flurry",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {1, 0.5, 0.5},
        sound = nil,
        enabled = false, -- Can be very frequent
    },
    ["Enrage"] = {
        name = "Enrage",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You are Enraged",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {1, 0, 0},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Reckoning"] = {
        name = "Reckoning",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Reckoning",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {1, 0.8, 0.4},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Seal of Command"] = {
        name = "Seal of Command",
        category = ProcEmData.CATEGORY.ABILITY,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Your Seal of Command",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {1, 0.9, 0.5},
        sound = nil,
        enabled = false, -- Very frequent
    },
    ["Clearcasting"] = {
        name = "Clearcasting",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Clearcasting",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {0.5, 0.5, 1},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Impact"] = {
        name = "Impact",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = ".* is stunned by your Impact",
        event = "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
        color = {0.8, 0.4, 1},
        sound = "LEVELUPSOUND",
        enabled = true,
    },
    ["Overpower"] = {
        name = "Overpower",
        category = ProcEmData.CATEGORY.ABILITY,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Your Overpower",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {1, 0.6, 0},
        sound = "LEVELUPSOUND",
        enabled = false, -- Track usage not proc
    },
    ["Revenge"] = {
        name = "Revenge",
        category = ProcEmData.CATEGORY.ABILITY,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Your Revenge",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {0.8, 0, 0},
        sound = nil,
        enabled = false, -- Track usage not proc
    },
}

-- Helper function to get enabled procs
function ProcEmData:GetEnabledProcs()
    local enabled = {}
    for key, proc in pairs(self.Procs) do
        if proc.enabled then
            enabled[key] = proc
        end
    end
    return enabled
end

-- Helper function to get procs by category
function ProcEmData:GetProcsByCategory(category)
    local filtered = {}
    for key, proc in pairs(self.Procs) do
        if proc.category == category then
            filtered[key] = proc
        end
    end
    return filtered
end
