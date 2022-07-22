Obscurity = LibStub("AceAddon-3.0"):NewAddon("Obscurity", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0")
local COMM_PREFIX = "OBS_COMM"

function Obscurity:OnInitialize()
  -- Called when the addon is loaded
  self:RegisterChatCommand("obs", "SlashCommandProc")
  self:RegisterChatCommand("obscurity", "SlashCommandProc")
end

function Obscurity:OnEnable()
  -- Called when the addon is enabled
  self:RegisterEvent("ENCOUNTER_START", "OnEncounterStart")
  self:RegisterEvent("ENCOUNTER_END", "OnEncounterEnd")
  self:RegisterComm(COMM_PREFIX, "OnCommReceived")
end

function Obscurity:OnDisable()
  -- Called when the addon is disabled
end

function Obscurity:SlashCommandProc(msg)
  if msg == "disable" then
    self:Disable()
  elseif msg == "enable" then
    self:Enable()
  elseif msg == "end" then
    self:OnEncounterEnd(nil, "123", "Test Encounter")
    WeakAuras.ScanEvents("OBS_ENCOUNTER_END")
  elseif msg == "wipe" then
    self:SendComm("OBSCURITY_WIPE")
  elseif msg == "dh" then
    self:SendComm("OBSCURITY_COOLDOWN", "OBSCURITY_DIVINE_HYMN")
  elseif msg == "bait" then
    self:SendComm("OBSCURITY_BAIT")
  elseif msg == "stack" then
    self:SendComm("OBSCURITY_STACK")
  elseif msg == "soak" then
    self:SendComm("OBSCURITY_SOAK")
	else
    if (self:IsEnabled()) then
      self:Print("Obscurity v0.0.1 is currently: ENABLED")
    else
      self:Print("Obscurity v0.0.1 is currently: DISABLED")
    end
	end
end

function Obscurity:SendComm(command, arg1, arg2, arg3)
  print("SendComm Params", command, arg1, arg2, arg3)
  local serializedPayload = self:SerializeCommand(command, arg1, arg2, arg3)
  if IsInRaid() == true then
    self:SendCommMessage(COMM_PREFIX, serializedPayload, "RAID", nil, "NORMAL")
  end

  if UnitInParty("player") then
    self:SendCommMessage(COMM_PREFIX, serializedPayload, "PARTY", nil, "NORMAL")
  end
end

function Obscurity:SerializeCommand(command, arg1, arg2, arg3)
  return self:Serialize({
    command = command,
    arg1 = arg1,
    arg2 = arg2,
    arg3 = arg3
  })
end

function Obscurity:OnEncounterStart(eventName, encounterID, encounterName, difficultyID, groupSize, success)
  self:Print("Started encounter " .. encounterName)
end

function Obscurity:OnEncounterEnd(eventName, encounterID, encounterName, difficultyID, groupSize, success)
  self:Print("Ended encounter " .. encounterName)
end

function Obscurity:OnCommReceived(prefix, payload, distro, sender)
  local success, deserialized = self:Deserialize(payload)
  if success == true then
    -- We have information about the command to run, we need to parse it and then tell WeakAuras about it.
    self:ParseCommand(deserialized.command, deserialized.arg1, deserialized.arg2, deserialized.arg3, sender)
  else
    self:Print("Could not deserialize payload from recent comm")
  end
end

function Obscurity:ParseCommand(command, arg1, arg2, arg3, sender)
  -- TODO: check if the sender has authority to give commands (IE: Raid lead or assist)
  -- UnitIsRaidOfficer
  -- GetRaidRosterInfo and then use that to UnitGUID("unit")
  if Obscurity[command] ~= nil then
    self[command](command, arg1, arg2, arg3)
  end
end

function Obscurity:OBSCURITY_WIPE()
  WeakAuras.ScanEvents("OBSCURITY_WIPE")
end

function Obscurity:OBSCURITY_BAIT()
  WeakAuras.ScanEvents("OBSCURITY_BAIT")
end

function Obscurity:OBSCURITY_STACK()
  WeakAuras.ScanEvents("OBSCURITY_STACK")
end

function Obscurity:OBSCURITY_SOAK()
  WeakAuras.ScanEvents("OBSCURITY_SOAK")
end

function Obscurity:OBSCURITY_SPREAD()
  WeakAuras.ScanEvents("OBSCURITY_SPREAD")
end

function Obscurity:OBSCURITY_COOLDOWN(arg1, arg2, arg3)
  if arg1 ~= nil then
    WeakAuras.ScanEvents(arg1, arg2, arg3)
  end
end