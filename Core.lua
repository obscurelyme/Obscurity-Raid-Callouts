Obscurity = LibStub("AceAddon-3.0"):NewAddon("Obscurity", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0")

function Obscurity:OnInitialize()
  -- Called when the addon is loaded
  self:RegisterChatCommand("obs", "SlashCommandProc")
  self:RegisterChatCommand("obscurity", "SlashCommandProc")
end

function Obscurity:OnEnable()
  -- Called when the addon is enabled
  self:RegisterEvent("ENCOUNTER_START", "OnEncounterStart")
  self:RegisterEvent("ENCOUNTER_END", "OnEncounterEnd")
  self:RegisterComm("ObscurityPingTest", "OnCommReceived")
end

function Obscurity:OnDisable()
  -- Called when the addon is disabled
end

function Obscurity:SlashCommandProc(msg)
  if msg == "disable" then
    self:Disable()
  elseif msg == "enable" then
    self:Enable()
  elseif msg == "ex" then
    self:Extra()
  elseif msg == "time" then
    self:Print(self:GetCurrentEncounterTime())
  elseif msg == "start" then
    self:OnEncounterStart(nil, "123", "Test Encounter")
    WeakAuras.ScanEvents("OBS_ENCOUNTER_START")
  elseif msg == "end" then
    self:OnEncounterEnd(nil, "123", "Test Encounter")
    WeakAuras.ScanEvents("OBS_ENCOUNTER_END")
  elseif msg == "wipe" then
    WeakAuras.ScanEvents("OBSCURITY_WIPE")
  elseif msg == "dh" then
    WeakAuras.ScanEvents("OBSCURITY_DIVINE_HYMN")
  elseif msg == "bait" then
    WeakAuras.ScanEvents("OBSCURITY_BAIT")
  elseif msg == "stack" then
    WeakAuras.ScanEvents("OBSCURITY_STACK")
  elseif msg == "soak" then
    WeakAuras.ScanEvents("OBSCURITY_SOAK")
  elseif msg == "gs" then
    WeakAuras.ScanEvents("OBSCURITY_GUARDIAN_SPIRIT", target)
	else
    if (self:IsEnabled()) then
      self:Print("Obscurity v0.0.1 is currently: ENABLED")
    else
      self:Print("Obscurity v0.0.1 is currently: DISABLED")
    end
	end
end

function Obscurity:OnEncounterStart(eventName, encounterID, encounterName, difficultyID, groupSize, success)
  self:Print("Started encounter " .. encounterName)
end

function Obscurity:OnEncounterEnd(eventName, encounterID, encounterName, difficultyID, groupSize, success)
  self:Print("Ended encounter " .. encounterName)
end

function Obscurity:OnCommReceived(params, ...)
  self:Print(params)
end