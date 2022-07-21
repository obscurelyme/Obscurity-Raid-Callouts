HelloWorld = LibStub("AceAddon-3.0"):NewAddon("WelcomeHome",
  -- Include the following vendor libs
  "AceConsole-3.0",
  "AceEvent-3.0"
)

function WelcomeHome:SlashCommand(msg)
	if msg == "ping" then
		self:Print("pong!")
  elseif msg == "disable" then
    self:Disable()
  elseif msg == "enable" then
    self:Enable()
	else
		self:Print("Hello, There! v0.0.1 is currently: " .. self:IsEnabled() ? "enabled" : "disabled")
	end
end

function HelloWorld:OnInitialize()
  -- Called when the addon is loaded
  self:Print("Hello, World!")
  self:RegisterChatCommand("om", "SlashCommand")
  self:RegisterChatCommand("obscurelyme", "SlashCommand")
end

function HelloWorld:OnEnable()
  -- Called when the addon is enabled
  self:RegisterEvent("ZONE_CHANGED", OnZoneChanged)
end

function HelloWorld:OnDisable()
  -- Called when the addon is disabled
end

function HelloWorld:OnZoneChanged()
  local subzone = GetSubZoneText()
  local zone = GetZoneText()
	self:Print("You have changed zones!", zone, subzone)
	if GetBindLocation() == subzone then
		self:Print("Welcome Home!")
	end
end
