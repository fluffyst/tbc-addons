local E, L, V, P, G = unpack(ElvUI)
local CA = E:NewModule("ChannelAlerts", "AceEvent-3.0")

-- Default Options
P["CA"] = {
	["guild"] = "None",
	["officer"] = "None",
	["party"] = "None",
	["raid"] = "None",
	["channel1"] = "None",
	["channel2"] = "None",
	["channel3"] = "None",
	["channel4"] = "None",
	["channel5"] = "None",
	["channel6"] = "None",
	["channel7"] = "None",
	["channel8"] = "None",
	["channel9"] = "None",
	["channel10"] = "None",
	
	["throttle"] = {
		["guild"] = 5,
		["officer"] = 5,
		["party"] = 5,
		["raid"] = 5,
		["channels"] = 5,
	}
}

local function ColorizeSettingName(settingName)
	return format("|cff1784d1%s|r", settingName)
end

function CA:InsertOptions()
	if not E.Options.args.elvuiPlugins then
		E.Options.args.elvuiPlugins = {
			order = 50,
			type = "group",
			name = "|cff00b30bE|r|cffC4C4C4lvUI_|r|cff00b30bP|r|cffC4C4C4lugins|r",
			args = {
				header = {
					order = 0,
					type = "header",
					name = "|cff00b30bE|r|cffC4C4C4lvUI_|r|cff00b30bP|r|cffC4C4C4lugins|r"
				},
				CAShortcut = {
					type = "execute",
					name = ColorizeSettingName("Channel Alerts"),
					func = function()
						if IsAddOnLoaded("ElvUI_Config") then
							local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
							ACD:SelectGroup("ElvUI", "elvuiPlugins", "CA")
						end
					end
				}
			}
		}
	elseif not E.Options.args.elvuiPlugins.args.CAShortcut then
		E.Options.args.elvuiPlugins.args.CAShortcut = {
			type = "execute",
			name = ColorizeSettingName("Channel Alerts"),
			func = function()
				if IsAddOnLoaded("ElvUI_Config") then
					local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
					ACD:SelectGroup("ElvUI", "elvuiPlugins", "CA")
				end
			end
		}
	end

	E.Options.args.elvuiPlugins.args.CA = {
		type = "group",
		name = ColorizeSettingName("Channel Alerts"),
		disabled = function() return not E.private.chat.enable end,
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Channel Alerts"]
			},
			updateChannels = {
				order = 2,
				type = "execute",
				name = L["Update Channels"],
				desc = L["The config should update automatically and add or remove channels. You can force an update by pressing this button."],
				func = function() CA:UpdateChannelsConfig() end
			},
			spacer = {
				order = 3,
				type = "description",
				name = ""
			},
			alerts = {
				order = 4,
				type = "group",
				name = L["Channel Alerts"],
				guiInline = true,
				args = {
					guild = {
						order = 1,
						type = "select",
						dialogControl = "LSM30_Sound",
						name = CHAT_MSG_GUILD..L[" Alert"],
						desc = L["Set to 'None' to disable alerts for this channel"],
						values = AceGUIWidgetLSMlists.sound,
						get = function(info) return E.db.CA.guild end,
						set = function(info, value) E.db.CA.guild = value end
					},
					officer = {
						order = 2,
						type = "select",
						dialogControl = "LSM30_Sound",
						name = CHAT_MSG_OFFICER..L[" Alert"],
						desc = L["Set to 'None' to disable alerts for this channel"],
						values = AceGUIWidgetLSMlists.sound,
						get = function(info) return E.db.CA.officer end,
						set = function(info, value) E.db.CA.officer = value end
					},
					party = {
						order = 3,
						type = "select",
						dialogControl = "LSM30_Sound",
						name = CHAT_MSG_PARTY..L[" Alert"],
						desc = L["Set to 'None' to disable alerts for this channel"],
						values = AceGUIWidgetLSMlists.sound,
						get = function(info) return E.db.CA.party end,
						set = function(info, value) E.db.CA.party = value end
					},
					raid = {
						order = 4,
						type = "select",
						dialogControl = "LSM30_Sound",
						name = CHAT_MSG_RAID..L[" Alert"],
						desc = L["Set to 'None' to disable alerts for this channel"],
						values = AceGUIWidgetLSMlists.sound,
						get = function(info) return E.db.CA.raid end,
						set = function(info, value) E.db.CA.raid = value end,
					}
				}
			},
			throttle = {
				order = 5,
				type = "group",
				name = L["Sound Throttle"],
				get = function(info) return E.db.CA.throttle[ info[#info] ] end,
				set = function(info, value) E.db.CA.throttle[ info[#info] ] = value end,
				guiInline = true,
				args = {
					guild = {
						order = 1,
						type = "range",
						name = L["Guild Alert Throttle"],
						desc = L["Amount of time in seconds between each alert"],
						min = 1, max = 30, step = 1
					},
					officer = {
						order = 2,
						type = "range",
						name = L["Officer Alert Throttle"],
						desc = L["Amount of time in seconds between each alert"],
						min = 1, max = 30, step = 1
					},
					instance = {
						order = 3,
						type = "range",
						name = L["Instance Alert Throttle"],
						desc = L["Amount of time in seconds between each alert"],
						min = 1, max = 30, step = 1
					},
					party = {
						order = 4,
						type = "range",
						name = L["Party Alert Throttle"],
						desc = L["Amount of time in seconds between each alert"],
						min = 1, max = 30, step = 1
					},
					raid = {
						order = 5,
						type = "range",
						name = L["Raid Alert Throttle"],
						desc = L["Amount of time in seconds between each alert"],
						min = 1, max = 30, step = 1
					},
					channels = {
						order = 6,
						type = "range",
						name = L["Channel Alert Throttle"],
						desc = L["Amount of time in seconds between each alert"],
						min = 1, max = 30, step = 1
					}
				}
			}
		}
	}

	local group = E.Options.args.elvuiPlugins.args.CA.args.alerts.args
	for i = 1, 10 do
		local channelName = CA.Channels[i]
		local hide = false
		if not channelName then hide = true end
		group["channel"..i] = {
			order = i + 5,
			type = "select",
			dialogControl = "LSM30_Sound",
			name = (not hide and channelName..L[" Alert"]) or "",
			desc = L["Set to 'None' to disable alerts for this channel"],
			values = AceGUIWidgetLSMlists.sound,
			hidden = hide,
			get = function(info) return E.db.CA["channel"..i] end,
			set = function(info, value) E.db.CA["channel"..i] = value end
		}
	end

	--Variable I can use to check whether the config exists or not
	CA.ConfigIsBuild = true
end

E:RegisterModule(CA:GetName())