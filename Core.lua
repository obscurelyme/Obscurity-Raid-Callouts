Obscurity = LibStub("AceAddon-3.0"):NewAddon("Obscurity", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0")

local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")
local COMM_PREFIX = "OBS_COMM"
local options = {
  name = "Obscurity",
  handler = Obscurity,
  type = "group",
  childGroups = "tab",
  args = {
    enableAlerts = {
      type = "toggle",
      name = "Enable",
      desc = "Enable/Disables this addon.",
      get = "IsEnabled",
      set = "ToggleAlerts"
    },
    mainOptions = {
      name = "Main Options",
      type = "group",
      args = {
        moderatorMode = {
          type = "toggle",
          name = "Moderator Mode",
          desc = "Overrides config that prevents you from listening to your own messages.",
          get = "IsModModeEnabled",
          set = "ToggleModMode"
        },
        wildcardTestInput = {
          type = "input",
          name = "Wildcard Message",
          desc = "Test the message to be displayed when you send a wildcard message",
          get = "GetTestWildcardMessage",
          set = "SetTestWildcardMessage"
        },
        wildcardTestBtn = {
          type = "execute",
          name = "Test Wildcard",
          func = "TestWildCardMessageWA",
        },
      }
    },
    profileTab = {
      name = "Profiles",
      type = "group",
      args = {
        desc = {
          type = "description",
          name = "This feature is currently in development, and does not function.",
          fontSize = "medium"
        },
        heading = {
          type = "header",
          name = "Select a profile to use"
        },
        pro = {
          type = "select",
          name = "Profile",
          values = {
            "Default",
            "Profile #1",
            "Profile #2"
          },
          desc = "Select the profile to use.",
          get = "GetCurrentProfile",
          set = "SetCurrentProfile",
          style = "dropdown"
        },
      }
    }
  }
}

function Obscurity:IsModModeEnabled()
  return self.modModeEnabled
end

function Obscurity:ToggleModMode()
  if self.modModeEnabled == true then
    self.modModeEnabled = false
  else
    self.modModeEnabled = true
  end
end

function Obscurity:GetTestWildcardMessage()
  return self.testWildCardMessage
end

function Obscurity:SetTestWildcardMessage(info, value)
  self.testWildCardMessage = value
end

function Obscurity:TestWildCardMessageWA()
  WeakAuras.ScanEvents("OBSCURITY_WILDCARD", self:GetTestWildcardMessage())
end

function Obscurity:ToggleAlerts()
  if self:IsEnabled() then
    self:Disable()
  else
    self:Enable()
  end
end

function Obscurity:GetCurrentProfile()
  return self.currentProfile
end

function Obscurity:SetCurrentProfile(info, value)
  self.currentProfile = value
end

function Obscurity:GetMessage()
  return self.message
end

function Obscurity:SetMessage(info, value)
  self.message = value
end

function Obscurity:OnInitialize()
  -- Called when the addon is loaded
  AC:RegisterOptionsTable("Obscurity_options", options)
  self.optionsFrame = ACD:AddToBlizOptions("Obscurity_options", "Obscurity")
  self:RegisterChatCommand("obs", "SlashCommandProc")
  self:RegisterChatCommand("obscurity", "SlashCommandProc")

  if self.currentProfile == nil then
    self.currentProfile = "Default"
  end

  self.modModeEnabled = false
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
    WeakAuras.ScanEvents("OBS_ENCOUNTER_END")
  elseif msg == "wipe" then
    self:SendComm("OBSCURITY_WIPE")
  elseif msg == "bait" then
    self:SendComm("OBSCURITY_BAIT")
  elseif msg == "stack" then
    self:SendComm("OBSCURITY_STACK")
  elseif msg == "soak" then
    self:SendComm("OBSCURITY_SOAK")
  elseif msg == "spread" then
    self:SendComm("OBSCURITY_SPREAD")
  else
    -- https://github.com/Stanzilla/WoWUIBugs/issues/89
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
  end
end

function Obscurity:SendComm(command, arg1, arg2, arg3)
  local serializedPayload = self:SerializeCommand(command, arg1, arg2, arg3)
  if IsInRaid() == true then
    self:SendCommMessage(COMM_PREFIX, serializedPayload, "RAID", nil, "NORMAL")
    return
  end

  if UnitInParty("player") then
    self:SendCommMessage(COMM_PREFIX, serializedPayload, "PARTY", nil, "NORMAL")
  end

  -- self:SendCommMessage(COMM_PREFIX, serializedPayload, "WHISPER", UnitName("player"), "NORMAL")
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
  if self.modModeEnabled == false then
    if sender == UnitName("player") then
      return
    end
  end

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
    self[command](self, arg1, arg2, arg3)
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

--[[
  Wildcard command that will allow any sort of text to be displayed to the receiver
]]
function Obscurity:WILDCARD(arg1, arg2, arg3)
  WeakAuras.ScanEvents("OBSCURITY_WILDCARD", arg1, arg2, arg3)
end