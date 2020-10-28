local E, L, V, P, G = unpack(ElvUI)
local CA = E:GetModule("ChannelAlerts")
local CH = E:GetModule("Chat")
local LSM = LibStub("LibSharedMedia-3.0")
local EP = LibStub("LibElvUIPlugin-1.0")
local addonName = "ElvUI_ChannelAlerts"

local select = select
local gsub = string.gsub

local GetChannelList = GetChannelList
local PlaySoundFile = PlaySoundFile
local UnitName = UnitName

-- Function which monitors numbered channels 1-10 and plays sound
function CA:MonitorChannels(event, _, author, _, _, _, _, _, channelNumber, ...)
	if author == UnitName("player") then return end -- Don't play sound if the message is from yourself
	if event == "CHAT_MSG_CHANNEL" and E.db.CA["channel"..channelNumber] ~= "None" and not CH.SoundPlayed then
		PlaySoundFile(LSM:Fetch("sound", E.db.CA["channel"..channelNumber]), "Master")
		CH.SoundPlayed = true
		CH.SoundTimer = CH:ScheduleTimer("ThrottleSound", E.db.CA.throttle.channels)
	end
end

-- Function which monitors guild channel and plays sound
function CA:MonitorGuild(event, _, author, ...)
	if author == UnitName("player") then return end -- Don't play sound if the message is from yourself
	if event == "CHAT_MSG_GUILD" and E.db.CA.guild ~= "None" and not CH.SoundPlayed then
		PlaySoundFile(LSM:Fetch("sound", E.db.CA.guild), "Master")
		CH.SoundPlayed = true
		CH.SoundTimer = CH:ScheduleTimer("ThrottleSound", E.db.CA.throttle.guild)
	end
end

-- Function which monitors officer channel and plays sound
function CA:MonitorOfficer(event, _, author, ...)
	if author == UnitName("player") then return end -- Don't play sound if the message is from yourself
	if event == "CHAT_MSG_OFFICER" and E.db.CA.officer ~= "None" and not CH.SoundPlayed then
		PlaySoundFile(LSM:Fetch("sound", E.db.CA.officer), "Master")
		CH.SoundPlayed = true
		CH.SoundTimer = CH:ScheduleTimer("ThrottleSound", E.db.CA.throttle.officer)
	end
end

-- Function which monitors party channel and plays sound
function CA:MonitorParty(event, _, author, ...)
	if author == UnitName("player") then return end -- Don't play sound if the message is from yourself
	if (event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER") and E.db.CA.party ~= "None" and not CH.SoundPlayed then
		PlaySoundFile(LSM:Fetch("sound", E.db.CA.party), "Master")
		CH.SoundPlayed = true
		CH.SoundTimer = CH:ScheduleTimer("ThrottleSound", E.db.CA.throttle.party)
	end
end

-- Function which monitors raid channel and plays sound
function CA:MonitorRaid(event, _, author, ...)
	if author == UnitName("player") then return end -- Don't play sound if the message is from yourself
	if (event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER") and E.db.CA.raid ~= "None" and not CH.SoundPlayed then
		PlaySoundFile(LSM:Fetch("sound", E.db.CA.raid), "Master")
		CH.SoundPlayed = true
		CH.SoundTimer = CH:ScheduleTimer("ThrottleSound", E.db.CA.throttle.raid)
	end
end

--Table we store our 1-10 channels in: [1] = ChannelName
CA.Channels = {}

local function buildChannelList(...)
	for i = 1, select("#", ...), 2 do
		local id, name = select(i, ...)
		CA.Channels[id] = name
	end
end

--Function which updates the CA.Channels table
function CA:UpdateChannelTable(event, msg, _, _, _, _, _, _, chanID, chanName, ...)
	if msg == "YOU_LEFT" and CA.Channels[chanID] then
		CA.Channels[chanID] = nil
		CA:UpdateChannelsConfig()
	elseif msg == "YOU_JOINED" then
		local name = gsub(chanName, " ", "")
		CA.Channels[chanID] = name
		CA:UpdateChannelsConfig()
	end
end

--Do stuff when entering world
function CA:PLAYER_ENTERING_WORLD()
	--Build CA.Channels table
	buildChannelList(GetChannelList())
end

--Function which gets executed when user presses "Update Channels" in config
function CA:UpdateChannelsConfig()
	if not CA.ConfigIsBuild then return end
	local group = E.Options.args.elvuiPlugins.args.CA.args.alerts.args
	for i = 1, 10 do
		local channelName = CA.Channels[i]
		if channelName then
			group["channel"..i].name = channelName..L[" Alert"]
			group["channel"..i].hidden = false
		else
			group["channel"..i].hidden = true
		end
	end
	LibStub("AceConfigRegistry-3.0-ElvUI"):NotifyChange("ElvUI")
end

-- Stuff to do when addon is initialized
function CA:OnInitialize()
	-- Register callback with LibElvUIPlugin
	EP:RegisterPlugin(addonName, CA.InsertOptions)

	--ElvUI Chat is not enabled, stop right here!
	if E.private.chat.enable ~= true then return end

	-- Register monitoring functions
	self:RegisterEvent("CHAT_MSG_CHANNEL", "MonitorChannels")
	self:RegisterEvent("CHAT_MSG_GUILD", "MonitorGuild")
	self:RegisterEvent("CHAT_MSG_OFFICER", "MonitorOfficer")
	self:RegisterEvent("CHAT_MSG_PARTY", "MonitorParty")
	self:RegisterEvent("CHAT_MSG_PARTY_LEADER", "MonitorParty")
	self:RegisterEvent("CHAT_MSG_RAID", "MonitorRaid")
	self:RegisterEvent("CHAT_MSG_RAID_LEADER", "MonitorRaid")

	-- Update CA.Channels table on channel joined/left
	self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE", "UpdateChannelTable")

	--Initial setup
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end