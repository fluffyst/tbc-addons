-- English localization for enUS and enGB.
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "enUS", true)

if not L then return end
L[" Alert"] = true
L["Amount of time in seconds between each alert"] = true
L["Channel Alert Throttle"] = true
L["Channel Alerts"] = true
L["Guild Alert Throttle"] = true
L["Instance Alert Throttle"] = true
L["Officer Alert Throttle"] = true
L["Party Alert Throttle"] = true
L["Raid Alert Throttle"] = true
L["Set to 'None' to disable alerts for this channel"] = true
L["Sound Throttle"] = true
L["The config should update automatically and add or remove channels. You can force an update by pressing this button."] = true
L["Update Channels"] = true

--We don"t need the rest if we"re on enUS or enGB locale, so stop here.
if GetLocale() == "enUS" then return end

--German Localizations
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "deDE")
if L then
	--Add translations here, eg.
	-- L[" Alert"] = " Alert",
end

--Spanish (Spain) Localizations
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "esES")
if L then
	--Add translations here, eg.
	-- L[" Alert"] = " Alert",
end

--Spanish (Mexico) Localizations
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "esMX")
if L then
	--Add translations here, eg.
	-- L[" Alert"] = " Alert",
end

--French Localizations
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "frFR")
if L then
	--Add translations here, eg.
	-- L[" Alert"] = " Alert",
end

--Italian Localizations
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "itIT")
if L then
	--Add translations here, eg.
	-- L[" Alert"] = " Alert",
end

--Korean Localizations
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "koKR")
if L then
	--Add translations here, eg.
	-- L[" Alert"] = " Alert",
end

--Portuguese Localizations
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "ptBR")
if L then
	--Add translations here, eg.
	-- L[" Alert"] = " Alert",
end

--Russian Localizations
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "ruRU")
if L then
	--Add translations here, eg.
	-- L[" Alert"] = " Alert",
end

--Chinese (China, simplified) Localizations
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "zhCN")
if L then
	--Add translations here, eg.
	-- L[" Alert"] = " Alert",
end

--Chinese (Taiwan, traditional) Localizations
local L = LibStub("AceLocale-3.0"):NewLocale("ElvUI", "zhTW")
if L then
	--Add translations here, eg.
	-- L[" Alert"] = " Alert",
end