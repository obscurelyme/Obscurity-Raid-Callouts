local encounterIds = {
    -- Raid: Sepulcher of the First Ones | InstanceID: 2481 | patch: 9.2.0
    2512,   -- Vigilant Guardian
    2529,   -- Halondrus the Reclaimer
    2537,   -- The Jailer
    2539,   -- Lihuvim
    2540,   -- Dausegne
    2542,   -- Skolex
    2543,   -- Lords of Dread
    2544,   -- Prototype Pantheon
    2546,   -- Anduin Wrynn
    2549,   -- Rygelon
    2553	-- Artificer Xy'mox
}

--[[
    In order to prevent abuse, users may opt in to in-encounter only alerts. So they don't randomly
    get pinged for things just because they are in a party/raid group.
]]
function Obscurity:IsValidEncounter(encounterId)
    local found = false

    for _, v in ipairs(encounterIds) do
        if v == encounterId then
            found = true
            break
        end
    end

    return found
end