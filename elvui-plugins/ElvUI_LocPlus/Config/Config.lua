local E, L, V, P, G = unpack(ElvUI)
local LPB = E:GetModule("LocationPlus")

local format = string.format
local OTHER, LEVEL_RANGE, EMBLEM_SYMBOL, FILTERS = OTHER, LEVEL_RANGE, EMBLEM_SYMBOL, FILTERS
local COLOR, CLASS, COLOR_PICKER = COLOR, CLASS, COLOR_PICKER

-- Defaults
P["locplus"] = {
-- Options
	["both"] = true,
	["combat"] = false,
	["timer"] = 0.5,
	["dig"] = true,
	["displayOther"] = "RLEVEL",
	["showicon"] = true,
	["hidecoords"] = false,
	["zonetext"] = true,
-- Tooltip
	["tt"] = true,
	["ttcombathide"] = true,
	["tthint"] = true,
	["ttst"] = true,
	["ttlvl"] = true,
	["ttinst"] = true,
	["ttreczones"] = true,
	["ttrecinst"] = true,
	["ttcoords"] = true,
-- Filters
	["tthideraid"] = false,
	["tthidepvp"] = false,
-- Layout
	["dtshow"] = true,
	["shadow"] = false,
	["trans"] = true,
	["noback"] = true,
	["ht"] = false,
	["lpwidth"] = 200,
	["dtwidth"] = 100,
	["dtheight"] = 21,
	["lpauto"] = true,
	["userColor"] = { r = 1, g = 1, b = 1 },
	["customColor"] = 1,
	["userCoordsColor"] = { r = 1, g = 1, b = 1 },
	["customCoordsColor"] = 3,
	["mouseover"] = false,
	["malpha"] = 1,
-- Fonts
	["lpfont"] = E.db.general.font,
	["lpfontsize"] = 12,
	["lpfontflags"] = "NONE",
-- Init
	["LoginMsg"] = true,
}

local newsign = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:14:14|t"

local LEVEL_ICON = "|TInterface\\AddOns\\ElvUI_LocPlus\\media\\levelup.tga:22:22|t"

local function ColorizeSettingName(settingName)
	return format("|cff1784d1%s|r", settingName)
end

function LPB:AddOptions()
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
				locplusShortcut = {
					type = "execute",
					name = ColorizeSettingName(L["Location Plus"]),
					func = function()
						if IsAddOnLoaded("ElvUI_Config") then
							local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
							ACD:SelectGroup("ElvUI", "elvuiPlugins", "locplus")
						end
					end
				}
			}
		}
	elseif not E.Options.args.elvuiPlugins.args.locplusShortcut then
		E.Options.args.elvuiPlugins.args.locplusShortcut = {
			type = "execute",
			name = ColorizeSettingName(L["Location Plus"]),
			func = function()
				if IsAddOnLoaded("ElvUI_Config") then
					local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
					ACD:SelectGroup("ElvUI", "elvuiPlugins", "locplus")
				end
			end
		}
	end

	E.Options.args.elvuiPlugins.args.locplus = {
		type = "group",
		name = ColorizeSettingName(L["Location Plus"]),
		childGroups = "tab",
		args = {
			name = {
				order = 1,
				type = "header",
				name = L["Location Plus"]
			},
			toptop = {
				order = 2,
				type = "group",
				name = L["General"],
				args = {
					header = {
						order = 1,
						type = "header",
						name = L["General"]
					},
					LoginMsg = {
						order = 2,
						type = "toggle",
						name = L["Login Message"],
						desc = L["Enable/Disable the Login Message"],
						width = "full",
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value end
					},
					combat = {
						order = 3,
						type = "toggle",
						name = L["Combat Hide"],
						desc = L["Show/Hide all panels when in combat"],
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value end
					},
					timer = {
						order = 4,
						type = "range",
						name = L["Update Timer"],
						desc = L["Adjust coords updates (in seconds) to avoid cpu load. Bigger number = less cpu load. Requires reloadUI."],
						min = 0.05, max = 1, step = 0.05,
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value E:StaticPopup_Show("PRIVATE_RL") end
					},
					zonetext = {
						order = 5,
						type = "toggle",
						name = L["Hide Blizzard Zone Text"],
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:ToggleBlizZoneText() end
					}
				}
			},
			general = {
				order = 3,
				type = "group",
				name = L["Show"],
				args = {
					header = {
						order = 1,
						type = "header",
						name = L["Show"]
					},
					both = {
						order = 2,
						type = "toggle",
						name = L["Zone and Subzone"],
						desc = L["Displays the main zone and the subzone in the location panel"],
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value end
					},
					hidecoords = {
						order = 3,
						type = "toggle",
						name = L["Hide Coords"]..newsign,
						desc = L["Show/Hide the coord frames"],
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:HideCoords() end
					},
					dig = {
						order = 4,
						type = "toggle",
						name = L["Detailed Coords"],
						desc = L["Adds 2 digits in the coords"],
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:CoordsDigit() end
					},
					displayOther = {
						order = 5,
						type = "select",
						name = OTHER,
						desc = L["Show additional info in the Location Panel."],
							values = {
								["NONE"] = NONE,
								["RLEVEL"] = LEVEL_ICON.." "..LEVEL_RANGE
							},
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value end
					},
					showicon = {
						order = 6,
						type = "toggle",
						name = EMBLEM_SYMBOL,
						disabled = function() return E.db.locplus.displayOther == "NONE" end,
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value end
					},
					mouseover = {
						order = 7,
						type = "toggle",
						name = L["Mouse Over"],
						desc = L["The frame is not shown unless you mouse over the frame."],
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:MouseOver() end
					},
					malpha = {
						order = 8,
						type = "range",
						name = L["Alpha"],
						desc = L["Change the alpha level of the frame."],
						min = 0, max = 1, step = 0.1,
						disabled = function() return not E.db.locplus.mouseover end,
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:MouseOver() end
					}
				}
			},
			gen_tt = {
				order = 4,
				type = "group",
				name = L["Tooltip"],
				get = function(info) return E.db.locplus[ info[#info] ] end,
				set = function(info, value) E.db.locplus[ info[#info] ] = value end,
				args = {
					header = {
						order = 1,
						type = "header",
						name = L["Tooltip"]
					},
					tt_grp = {
						order = 2,
						type = "group",
						name = L["Tooltip"],
						guiInline = true,
						args = {
							tt = {
								order = 1,
								type = "toggle",
								name = L["Show/Hide tooltip"]
							},
							ttcombathide = {
								order = 2,
								type = "toggle",
								name = L["Combat Hide"],
								desc = L["Hide tooltip while in combat."],
								disabled = function() return not E.db.locplus.tt end
							},
							tthint = {
								order = 3,
								type = "toggle",
								name = L["Show Hints"],
								desc = L["Enable/Disable hints on Tooltip."],
								disabled = function() return not E.db.locplus.tt end
							}
						}
					},
					tt_options = {
						order = 3,
						type = "group",
						name = L["Show"],
						guiInline = true,
						args = {
							ttst = {
								order = 1,
								type = "toggle",
								name = L["Status"],
								desc = L["Enable/Disable status on Tooltip."],
								width = "full",
								disabled = function() return not E.db.locplus.tt end,
							},
							ttlvl = {
								order = 2,
								type = "toggle",
								name = LEVEL_RANGE,
								desc = L["Enable/Disable level range on Tooltip."],
								disabled = function() return not E.db.locplus.tt end,
							},
							spacer2 = {
								order = 3,
								type = "description",
								width = "full",
								name = "",
							},
							ttreczones = {
								order = 4,
								type = "toggle",
								name = L["Recommended Zones"],
								desc = L["Enable/Disable recommended zones on Tooltip."],
								width = "full",
								disabled = function() return not E.db.locplus.tt end,
							},
							ttinst = {
								order = 5,
								type = "toggle",
								name = L["Zone Dungeons"],
								desc = L["Enable/Disable dungeons in the zone, on Tooltip."],
								disabled = function() return not E.db.locplus.tt end,
							},
							ttrecinst = {
								order = 6,
								type = "toggle",
								name = L["Recommended Dungeons"],
								desc = L["Enable/Disable recommended dungeons on Tooltip."],
								disabled = function() return not E.db.locplus.tt end,
							},
							ttcoords = {
								order = 7,
								type = "toggle",
								name = L["with Entrance Coords"],
								desc = L["Enable/Disable the coords for area dungeons and recommended dungeon entrances, on Tooltip."],
								disabled = function() return not E.db.locplus.tt or not E.db.locplus.ttrecinst end
							}
						}
					},
					tt_filters = {
						order = 4,
						type = "group",
						name = FILTERS,
						guiInline = true,
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value end,
						args = {
							tthideraid = {
								order = 1,
								type = "toggle",
								name = L["Hide Raid"],
								desc = L["Show/Hide raids on recommended dungeons."],
								disabled = function() return not E.db.locplus.tt end
							},
							tthidepvp = {
								order = 2,
								type = "toggle",
								name = L["Hide PvP"],
								desc = L["Show/Hide PvP zones, Arenas and BGs on recommended dungeons and zones."],
								disabled = function() return not E.db.locplus.tt end
							}
						}
					}
				}
			},
			layout = {
				order = 5,
				type = "group",
				name = L["Layout"],
				args = {
					header = {
						order = 1,
						type = "header",
						name = L["Layout"]
					},
					lp_lo = {
						order = 2,
						type = "group",
						name = L["Layout"],
						guiInline = true,
						args = {
							shadow = {
								order = 1,
								type = "toggle",
								name = L["Shadows"],
								desc = L["Enable/Disable layout with shadows."],
								disabled = function() return not E.db.locplus.noback end,
								get = function(info) return E.db.locplus[ info[#info] ] end,
								set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:ShadowPanels() end
							},
							trans = {
								order = 2,
								type = "toggle",
								name = L["Transparent"],
								desc = L["Enable/Disable transparent layout."],
								disabled = function() return not E.db.locplus.noback end,
								get = function(info) return E.db.locplus[ info[#info] ] end,
								set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:TransparentPanels() end
							},
							noback = {
								order = 3,
								type = "toggle",
								name = L["Backdrop"],
								desc = L["Hides all panels background so you can place them on ElvUI's top or bottom panel."],
								get = function(info) return E.db.locplus[ info[#info] ] end,
								set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:TransparentPanels() LPB:ShadowPanels() end
							}
						}
					},
					locpanel = {
						order = 3,
						type = "group",
						name = L["Location Panel"],
						guiInline = true,
						args = {
							ht = {
								order = 1,
								type = "toggle",
								name = L["Larger Location Panel"],
								desc = L["Adds 6 pixels at the Main Location Panel height."],
								width = "full",
								disabled = function() return not E.db.locplus.noback end,
								get = function(info) return E.db.locplus[ info[#info] ] end,
								set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:DTHeight() end
							},
							lpauto = {
								order = 2,
								type = "toggle",
								name = L["Auto width"],
								desc = L["Auto resized Location Panel."],
								get = function(info) return E.db.locplus[ info[#info] ] end,
								set = function(info, value) E.db.locplus[ info[#info] ] = value E.db.locplus.trunc = false end
							},
							lpwidth = {
								order = 3,
								type = "range",
								name = L["Width"],
								desc = L["Adjust the Location Panel Width."],
								min = 100, max = 300, step = 1,
								disabled = function() return E.db.locplus.lpauto end,
								get = function(info) return E.db.locplus[ info[#info] ] end,
								set = function(info, value) E.db.locplus[ info[#info] ] = value end
							},
							customColor = {
								order = 4,
								type = "select",
								name = COLOR,
								values = {
									[1] = L["Auto Colorize"],
									[2] = CLASS,
									[3] = L["Custom"]
								},
								get = function(info) return E.db.locplus[ info[#info] ] end,
								set = function(info, value) E.db.locplus[ info[#info] ] = value end
							},
							userColor = {
								order = 5,
								type = "color",
								name = COLOR_PICKER,
								disabled = function() return E.db.locplus.customColor == 1 or E.db.locplus.customColor == 2 end,
								get = function(info)
									local t = E.db.locplus[ info[#info] ]
									return t.r, t.g, t.b, t.a
									end,
								set = function(info, r, g, b)
									local t = E.db.locplus[ info[#info] ]
									t.r, t.g, t.b = r, g, b
									LPB:CoordsColor()
								end
							}
						}
					},
					coords = {
						order = 4,
						type = "group",
						name = L["Coordinates"],
						guiInline = true,
						args = {
							customCoordsColor = {
								order = 1,
								type = "select",
								name = COLOR,
								values = {
									[1] = L["Use Custom Location Color"],
									[2] = CLASS,
									[3] = L["Custom"]
								},
								get = function(info) return E.db.locplus[ info[#info] ] end,
								set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:CoordsColor() end
							},
							userCoordsColor = {
								order = 2,
								type = "color",
								name = COLOR_PICKER,
								disabled = function() return E.db.locplus.customCoordsColor == 1 or E.db.locplus.customCoordsColor == 2 end,
								get = function(info)
									local t = E.db.locplus[ info[#info] ]
									return t.r, t.g, t.b, t.a
									end,
								set = function(info, r, g, b)
									local t = E.db.locplus[ info[#info] ]
									t.r, t.g, t.b = r, g, b
									LPB:CoordsColor()
								end
							},
							dig = {
								order = 3,
								type = "toggle",
								name = L["Detailed Coords"],
								desc = L["Adds 2 digits in the coords"],
								get = function(info) return E.db.locplus[ info[#info] ] end,
								set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:CoordsDigit() end
							}
						}
					},
					panels = {
						order = 5,
						type = "group",
						name = L["Size"],
						guiInline = true,
						args = {
							dtwidth = {
								order = 1,
								type = "range",
								name = L["DataTexts Width"],
								desc = L["Adjust the DataTexts Width."],
								min = 70, max = 200, step = 1,
								get = function(info) return E.db.locplus[ info[#info] ] end,
								set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:DTWidth() end
							},
							dtheight = {
								order = 2,
								type = "range",
								name = L["All Panels Height"],
								desc = L["Adjust All Panels Height."],
								min = 10, max = 32, step = 1,
								get = function(info) return E.db.locplus[ info[#info] ] end,
								set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:DTHeight() end
							}
						}
					},
					font = {
						order = 6,
						type = "group",
						name = L["Fonts"],
						guiInline = true,
						get = function(info) return E.db.locplus[ info[#info] ] end,
						set = function(info, value) E.db.locplus[ info[#info] ] = value LPB:ChangeFont() end,
						args = {
							lpfont = {
								order = 1,
								type = "select", dialogControl = "LSM30_Font",
								name = L["Font"],
								desc = L["Choose font for the Location and Coords panels."],
								values = AceGUIWidgetLSMlists.font
							},
							lpfontsize = {
								order = 2,
								type = "range",
								name = FONT_SIZE,
								desc = L["Set the font size."],
								min = 6, max = 22, step = 1
							},
							lpfontflags = {
								order = 3,
								type = "select",
								name = L["Font Outline"],
								values = {
									["NONE"] = NONE,
									["OUTLINE"] = "OUTLINE",
									["MONOCHROMEOUTLINE"] = "MONOCROMEOUTLINE",
									["THICKOUTLINE"] = "THICKOUTLINE"
								}
							}
						}
					}
				}
			}
		}
	}
end