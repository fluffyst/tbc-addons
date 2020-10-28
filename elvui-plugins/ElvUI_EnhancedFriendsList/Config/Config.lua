local E, L, V, P, G = unpack(ElvUI)
local EFL = E:GetModule("EnhancedFriendsList")

local format = string.format

local function ColorizeSettingName(settingName)
	return format("|cff1784d1%s|r", settingName)
end

function EFL:InsertOptions()
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
				enhanceFriendsListShortcut = {
					type = "execute",
					name = ColorizeSettingName(L["Enhanced Friends List"]),
					func = function()
						if IsAddOnLoaded("ElvUI_Config") then
							local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
							ACD:SelectGroup("ElvUI", "elvuiPlugins", "enhanceFriendsList", "general")
						end
					end
				}
			}
		}
	elseif not E.Options.args.elvuiPlugins.args.enhanceFriendsListShortcut then
		E.Options.args.elvuiPlugins.args.enhanceFriendsListShortcut = {
			type = "execute",
			name = ColorizeSettingName(L["Enhanced Friends List"]),
			func = function()
				if IsAddOnLoaded("ElvUI_Config") then
					local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
					ACD:SelectGroup("ElvUI", "elvuiPlugins", "enhanceFriendsList", "general")
				end
			end
		}
	end

	E.Options.args.elvuiPlugins.args.enhanceFriendsList = {
		type = "group",
		childGroups = "tab",
		name = ColorizeSettingName(L["Enhanced Friends List"]),
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Enhanced Friends List"]
			},
			general = {
				order = 2,
				type = "group",
				name = L["General"],
				get = function(info) return E.db.enhanceFriendsList[ info[#info] ] end,
				set = function(info, value) E.db.enhanceFriendsList[ info[#info] ] = value; EFL:Update(); FriendsList_Update(); end,
				args = {
					header = {
						order = 0,
						type = "header",
						name = L["General"],
					},
					showBackground = {
						order = 1,
						type = "toggle",
						name = L["Show Background"]
					},
					showStatusIcon = {
						order = 2,
						type = "toggle",
						name = L["Show Status Icon"]
					},
					showNoteIcon = {
						order = 3,
						type = "toggle",
						name = L["Show Note Icon"]
					},
					showTooltipInfo = {
						order = 4,
						type = "toggle",
						name = L["Show Tooltip Info"]
					},
					statusIcons = {
						order = 5,
						type = "select",
						name = L["Status Icons Textures"],
						values = {
							["Default"] = L["Default"],
							["Square"] = "Square",
							["D3"] = "Diablo 3"
						}
					},
					nameFont = {
						order = 6,
						type = "group",
						name = L["Name Font"],
						guiInline = true,
						get = function(info) return E.db.enhanceFriendsList[ info[#info] ] end,
						set = function(info, value) E.db.enhanceFriendsList[ info[#info] ] = value; EFL:Update(); FriendsList_Update() end,
						args = {
							nameFont = {
								order = 1,
								type = "select", dialogControl = "LSM30_Font",
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font
							},
							nameFontSize = {
								order = 2,
								type = "range",
								name = L["Font Size"],
								min = 6, max = 22, step = 1
							},
							nameFontOutline = {
								order = 3,
								type = "select",
								name = L["Font Outline"],
								desc = L["Set the font outline."],
								values = {
									["NONE"] = L["None"],
									["OUTLINE"] = "OUTLINE",
									["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE"
								}
							}
						}
					},
					zoneFont = {
						order = 7,
						type = "group",
						name = L["Zone Font"],
						guiInline = true,
						get = function(info) return E.db.enhanceFriendsList[ info[#info] ] end,
						set = function(info, value) E.db.enhanceFriendsList[ info[#info] ] = value; EFL:Update(); FriendsList_Update() end,
						args = {
							zoneFont = {
								order = 1,
								type = "select", dialogControl = "LSM30_Font",
								name = L["Font"],
								values = AceGUIWidgetLSMlists.font
							},
							zoneFontSize = {
								order = 2,
								type = "range",
								name = L["Font Size"],
								min = 6, max = 22, step = 1
							},
							zoneFontOutline = {
								order = 3,
								type = "select",
								name = L["Font Outline"],
								desc = L["Set the font outline."],
								values = {
									["NONE"] = L["None"],
									["OUTLINE"] = "OUTLINE",
									["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE"
								}
							}
						}
					}
				}
			},
			Online = {
				order = 3,
				type = "group",
				name = L["Online Friends"],
				get = function(info) return E.db.enhanceFriendsList.Online[ info[#info] ] end,
				set = function(info, value) E.db.enhanceFriendsList.Online[ info[#info] ] = value; EFL:Update(); FriendsList_Update() end,
				args = {
					header = {
						order = 0,
						type = "header",
						name = L["Online Friends"],
					},
					name = {
						order = 1,
						type = "group",
						name = L["Name"],
						guiInline = true,
						args = {
							enhancedName = {
								order = 1,
								type = "toggle",
								name = L["Enhanced Name"]
							},
							colorizeNameOnly = {
								order = 2,
								type = "toggle",
								name = L["Colorize Name Only"],
								disabled = function() return not E.db.enhanceFriendsList.Online.enhancedName end
							}
						}
					},
					level = {
						order = 2,
						type = "group",
						name = L["Level"],
						guiInline = true,
						args = {
							level = {
								order = 1,
								type = "toggle",
								name = L["Show"]
							},
							levelColor = {
								order = 2,
								type = "toggle",
								name = L["Level Range Color"],
								disabled = function() return not E.db.enhanceFriendsList.Online.level end
							},
							levelText = {
								order = 3,
								type = "toggle",
								name = L["Level Text"],
								disabled = function() return not E.db.enhanceFriendsList.Online.level end
							},
							shortLevel = {
								order = 4,
								type = "toggle",
								name = L["Short Level"],
								disabled = function() return not E.db.enhanceFriendsList.Online.level or not E.db.enhanceFriendsList.Online.levelText end
							}
						}
					},
					class = {
						order = 3,
						type = "group",
						name = L["Class"],
						guiInline = true,
						args = {
							classText = {
								order = 1,
								type = "toggle",
								name = L["Class Text"]
							},
							classIcon = {
								order = 2,
								type = "toggle",
								name = L["Class Icon"]
							},
							classIconStatusColor = {
								order = 3,
								type = "toggle",
								name = L["Class Icon Status Color"],
								disabled = function() return not E.db.enhanceFriendsList.Online.classIcon end
							}
						}
					},
					zone = {
						order = 4,
						type = "group",
						name = L["Zone"],
						guiInline = true,
						args = {
							zoneText = {
								order = 1,
								type = "toggle",
								name = L["Zone Text"]
							},
							spacer = {
								order = 2,
								type = "description",
								name = ""
							},
							enhancedZone = {
								order = 3,
								type = "toggle",
								name = L["Enhanced Zone"],
								disabled = function() return not E.db.enhanceFriendsList.Online.zoneText end
							},
							enhancedZoneColor = {
								order = 4,
								type = "color",
								name = L["Enhanced Zone Color"],
								get = function(info)
									local t = E.db.enhanceFriendsList.Online.enhancedZoneColor
									local d = P.enhanceFriendsList.Online.enhancedZoneColor
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b
								end,
								set = function(info, r, g, b)
									local t = E.db.enhanceFriendsList.Online.enhancedZoneColor
									t.r, t.g, t.b = r, g, b
									FriendsList_Update()
								end,
								disabled = function() return not E.db.enhanceFriendsList.Online.zoneText or not E.db.enhanceFriendsList.Online.enhancedZone end
							},
							spacer2 = {
								order = 5,
								type = "description",
								name = "",
							},
							sameZone = {
								order = 6,
								type = "toggle",
								name = L["Same Zone"],
								desc = L["Friends that are in the same area as you, have their zone info colorized green."],
								disabled = function() return not E.db.enhanceFriendsList.Online.zoneText end
							},
							sameZoneColor = {
								order = 7,
								type = "color",
								name = L["Same Zone Color"],
								get = function(info)
									local t = E.db.enhanceFriendsList.Online.sameZoneColor
									local d = P.enhanceFriendsList.Online.sameZoneColor
									return t.r, t.g, t.b, t.a, d.r, d.g, d.b
								end,
								set = function(info, r, g, b)
									local t = E.db.enhanceFriendsList.Online.sameZoneColor
									t.r, t.g, t.b = r, g, b
									FriendsList_Update()
								end,
								disabled = function() return not E.db.enhanceFriendsList.Online.zoneText or not E.db.enhanceFriendsList.Online.sameZone end
							}
						}
					}
				}
			},
			Offline = {
				order = 4,
				type = "group",
				name = L["Offline Friends"],
				get = function(info) return E.db.enhanceFriendsList.Offline[ info[#info] ] end,
				set = function(info, value) E.db.enhanceFriendsList.Offline[ info[#info] ] = value; EFL:Update(); FriendsList_Update() end,
				args = {
					header = {
						order = 0,
						type = "header",
						name = L["Offline Friends"],
					},
					name = {
						order = 1,
						type = "group",
						name = L["Name"],
						guiInline = true,
						args = {
							enhancedName = {
								order = 1,
								type = "toggle",
								name = L["Enhanced Name"]
							},
							colorizeNameOnly = {
								order = 2,
								type = "toggle",
								name = L["Colorize Name Only"],
								disabled = function() return not E.db.enhanceFriendsList.Offline.enhancedName end
							}
						}
					},
					level = {
						order = 2,
						type = "group",
						name = L["Level"],
						guiInline = true,
						args = {
							level = {
								order = 1,
								type = "toggle",
								name = L["Show"]
							},
							levelColor = {
								order = 2,
								type = "toggle",
								name = L["Level Range Color"],
								disabled = function() return not E.db.enhanceFriendsList.Offline.level end
							},
							levelText = {
								order = 3,
								type = "toggle",
								name = L["Level Text"],
								desc = L["Hides the 'Level' or 'L' text."],
								disabled = function() return not E.db.enhanceFriendsList.Offline.level end
							},
							shortLevel = {
								order = 4,
								type = "toggle",
								name = L["Short Level"],
								disabled = function() return not E.db.enhanceFriendsList.Offline.level or not E.db.enhanceFriendsList.Offline.levelText end
							}
						}
					},
					class = {
						order = 3,
						type = "group",
						name = L["Class"],
						guiInline = true,
						args = {
							classText = {
								order = 1,
								type = "toggle",
								name = L["Class Text"]
							},
							classIcon = {
								order = 2,
								type = "toggle",
								name = L["Class Icon"]
							}
						}
					},
					zone = {
						order = 4,
						type = "group",
						name = L["Zone"],
						guiInline = true,
						args = {
							zoneText = {
								order = 1,
								type = "toggle",
								name = L["Zone Text"]
							},
							lastSeen = {
								order = 2,
								type = "toggle",
								name = L["Last Seen"]
							}
						}
					}
				}
			}
		}
	}
end