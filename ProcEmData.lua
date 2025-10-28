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
        pattern = ".* is afflicted by Spell Vulnerability",
        event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
        targetOnly = true,
        color = {0.5, 0, 0.8},
        enabled = false,
    },
    ["Hand of Justice"] = {
        name = "Hand of Justice",
        category = ProcEmData.CATEGORY.TRINKET,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain 1 extra attack",
        event = "CHAT_MSG_SPELL_SELF_BUFF",
        color = {1, 0.8, 0},
        enabled = false,
    },
    ["Ironfoe"] = {
        name = "Ironfoe",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain 2 extra attacks",
        event = "CHAT_MSG_SPELL_SELF_BUFF",
        color = {0.7, 0.7, 0.7},
        enabled = false,
    },
    ["Thrash Blade"] = {
        name = "Thrash Blade",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Thrash Blade",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {0.8, 0.2, 0.2},
        enabled = false,
    },
    ["Eskhandar's Right Claw"] = {
        name = "Eskhandar's Right Claw",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Eskhandar's Rage",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {0, 1, 0},
        enabled = false,
    },
    ["Flurry Axe"] = {
        name = "Flurry Axe",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Flurry",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {0.2, 0.8, 1},
        enabled = false,
    },
    ["Bonereaver's Edge"] = {
        name = "Bonereaver's Edge",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = ".* is afflicted by Bonereaver's Edge",
        event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
        targetOnly = true,
        color = {0.6, 0.3, 0},
        enabled = false,
    },
    ["Thunderfury"] = {
        name = "Thunderfury",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = ".* is afflicted by Thunderfury",
        event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
        targetOnly = true,
        color = {0, 0.5, 1},
        enabled = false,
    },
    ["Deathbringer"] = {
        name = "Deathbringer",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Deathbringer",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {0.4, 0, 0.4},
        enabled = false,
    },
    ["Sulfuras"] = {
        name = "Sulfuras",
        category = ProcEmData.CATEGORY.WEAPON,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Sulfuras",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {1, 0.4, 0},
        enabled = false,
    },

    -- Enchant Procs
    ["Crusader"] = {
        name = "Crusader",
        category = ProcEmData.CATEGORY.ENCHANT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Crusader",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {1, 0.9, 0.3},
        enabled = false,
    },
    ["Lifestealing"] = {
        name = "Lifestealing",
        category = ProcEmData.CATEGORY.ENCHANT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Lifestealing",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {0.5, 0, 0},
        enabled = false,
    },
    ["Fiery Weapon"] = {
        name = "Fiery Weapon",
        category = ProcEmData.CATEGORY.ENCHANT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Fiery Weapon",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {1, 0.3, 0},
        enabled = false,
    },
    ["Windfury Weapon"] = {
        name = "Windfury Weapon",
        category = ProcEmData.CATEGORY.ENCHANT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Windfury Weapon",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {0.2, 0.6, 1},
        enabled = false,
    },

    -- Talent/Ability Procs
    ["Windfury Totem"] = {
        name = "Windfury Totem",
        category = ProcEmData.CATEGORY.ABILITY,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain 1 extra attack through Windfury",
        event = "CHAT_MSG_SPELL_SELF_BUFF",
        color = {0.3, 0.7, 1},
        enabled = false,
    },
    ["Sword Specialization"] = {
        name = "Sword Specialization",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain 1 extra attack",
        event = "CHAT_MSG_SPELL_SELF_BUFF",
        color = {0.8, 0.8, 0.8},
        enabled = false,
    },
    ["Mace Specialization"] = {
        name = "Mace Specialization",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = ".* is stunned",
        event = "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
        color = {0.6, 0.4, 0.2},
        enabled = false, -- Can be noisy
    },
    ["Flurry"] = {
        name = "Flurry",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Flurry",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {1, 0.5, 0.5},
        enabled = false, -- Can be very frequent
    },
    ["Enrage"] = {
        name = "Enrage",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You are Enraged",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {1, 0, 0},
        enabled = false,
    },
    ["Reckoning"] = {
        name = "Reckoning",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Reckoning",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {1, 0.8, 0.4},
        enabled = false,
    },
    ["Seal of Command"] = {
        name = "Seal of Command",
        category = ProcEmData.CATEGORY.ABILITY,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Your Seal of Command",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {1, 0.9, 0.5},
        enabled = false, -- Very frequent
    },
    ["Clearcasting"] = {
        name = "Clearcasting",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "You gain Clearcasting",
        event = "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS",
        color = {0.5, 0.5, 1},
        enabled = false,
    },
    ["Impact"] = {
        name = "Impact",
        category = ProcEmData.CATEGORY.TALENT,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = ".* is stunned by your Impact",
        event = "CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE",
        color = {0.8, 0.4, 1},
        enabled = false,
    },
    ["Overpower"] = {
        name = "Overpower",
        category = ProcEmData.CATEGORY.ABILITY,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Your Overpower",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {1, 0.6, 0},
        enabled = false, -- Track usage not proc
    },
    ["Revenge"] = {
        name = "Revenge",
        category = ProcEmData.CATEGORY.ABILITY,
        detection = ProcEmData.DETECTION.COMBAT_LOG,
        pattern = "Your Revenge",
        event = "CHAT_MSG_SPELL_SELF_DAMAGE",
        color = {0.8, 0, 0},
        enabled = false, -- Track usage not proc
    },
}

-- Additional target debuffs (handled via periodic creature damage; gated to current target)
-- Disabled by default to reduce noise; enable as needed from UI.
ProcEmData.Procs["Shadow Weaving"] = {
    name = "Shadow Weaving",
    category = ProcEmData.CATEGORY.ABILITY,
    detection = ProcEmData.DETECTION.COMBAT_LOG,
    pattern = ".* is afflicted by Shadow Weaving",
    event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
    targetOnly = true,
    color = {0.4, 0, 0.6},
    enabled = false,
}

ProcEmData.Procs["Curse of Shadows"] = {
    name = "Curse of Shadows",
    category = ProcEmData.CATEGORY.ABILITY,
    detection = ProcEmData.DETECTION.COMBAT_LOG,
    pattern = ".* is afflicted by Curse of Shadows",
    event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
    targetOnly = true,
    color = {0.6, 0, 0.6},
    enabled = false,
}

ProcEmData.Procs["Curse of Elements"] = {
    name = "Curse of Elements",
    category = ProcEmData.CATEGORY.ABILITY,
    detection = ProcEmData.DETECTION.COMBAT_LOG,
    pattern = ".* is afflicted by Curse of Elements",
    event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
    targetOnly = true,
    color = {0.2, 0.7, 0.9},
    enabled = false,
}

ProcEmData.Procs["Curse of Weakness"] = {
    name = "Curse of Weakness",
    category = ProcEmData.CATEGORY.ABILITY,
    detection = ProcEmData.DETECTION.COMBAT_LOG,
    pattern = ".* is afflicted by Curse of Weakness",
    event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
    targetOnly = true,
    color = {0.5, 0.5, 0.5},
    enabled = false,
}

ProcEmData.Procs["Sunder Armor"] = {
    name = "Sunder Armor",
    category = ProcEmData.CATEGORY.ABILITY,
    detection = ProcEmData.DETECTION.COMBAT_LOG,
    pattern = ".* is afflicted by Sunder Armor",
    event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
    targetOnly = true,
    color = {0.7, 0.4, 0.2},
    enabled = false,
}

ProcEmData.Procs["Expose Armor"] = {
    name = "Expose Armor",
    category = ProcEmData.CATEGORY.ABILITY,
    detection = ProcEmData.DETECTION.COMBAT_LOG,
    pattern = ".* is afflicted by Expose Armor",
    event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
    targetOnly = true,
    color = {0.8, 0.7, 0.2},
    enabled = false,
}

ProcEmData.Procs["Faerie Fire"] = {
    name = "Faerie Fire",
    category = ProcEmData.CATEGORY.ABILITY,
    detection = ProcEmData.DETECTION.COMBAT_LOG,
    pattern = ".* is afflicted by Faerie Fire",
    event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
    targetOnly = true,
    color = {0.1, 1, 0.5},
    enabled = false,
}

ProcEmData.Procs["Winter's Chill"] = {
    name = "Winter's Chill",
    category = ProcEmData.CATEGORY.ABILITY,
    detection = ProcEmData.DETECTION.COMBAT_LOG,
    pattern = ".* is afflicted by Winter's Chill",
    event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
    targetOnly = true,
    color = {0.6, 0.8, 1},
    enabled = false,
}

ProcEmData.Procs["Ignite"] = {
    name = "Ignite",
    category = ProcEmData.CATEGORY.ABILITY,
    detection = ProcEmData.DETECTION.COMBAT_LOG,
    pattern = ".* is afflicted by Ignite",
    event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
    targetOnly = true,
    color = {1, 0.3, 0},
    enabled = false,
}

ProcEmData.Procs["Insect Swarm"] = {
    name = "Insect Swarm",
    category = ProcEmData.CATEGORY.ABILITY,
    detection = ProcEmData.DETECTION.COMBAT_LOG,
    pattern = ".* is afflicted by Insect Swarm",
    event = "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE",
    targetOnly = true,
    color = {0.9, 0.8, 0.1},
    enabled = false,
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
