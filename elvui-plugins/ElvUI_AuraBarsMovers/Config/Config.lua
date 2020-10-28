local E, L, V, P, G = unpack(ElvUI)
local UF = E:GetModule("UnitFrames")
local ABM = E:GetModule("AuraBarMovers")

local function ColorizeSettingName(settingName)
	return format("|cff1784d1%s|r", settingName)
end

function ABM:GetOptions()
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
				auraBarMoversShortcut = {
					type = "execute",
					name = ColorizeSettingName(L["Aura Bar Movers"]),
					func = function()
						if IsAddOnLoaded("ElvUI_Config") then
							local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
							ACD:SelectGroup("ElvUI", "elvuiPlugins", "auraBarMovers")
						end
					end
				}
			}
		}
	elseif not E.Options.args.elvuiPlugins.args.auraBarMoversShortcut then
		E.Options.args.elvuiPlugins.args.auraBarMoversShortcut = {
			type = "execute",
			name = ColorizeSettingName(L["Aura Bar Movers"]),
			func = function()
				if IsAddOnLoaded("ElvUI_Config") then
					local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
					ACD:SelectGroup("ElvUI", "elvuiPlugins", "auraBarMovers")
				end
			end
		}
	end

	E.Options.args.elvuiPlugins.args.auraBarMovers = {
		type = "group",
		name = ColorizeSettingName(L["Aura Bar Movers"]),
		args = {
			header = {
				order = 1,
				type = "header",
				name = L["Aura Bar Movers"]
			},
			player = {
				order = 2,
				type = "group",
				name = L["Player"],
				guiInline = true,
				args = {
					detach = {
						order = 1,
						type = "toggle",
						name = L["Detach From Frame"],
						get = function(info) return E.db.abm.player end,
						set = function(info, value) E.db.abm.player = value UF:CreateAndUpdateUF("player") ABM:MoverToggle() end
					},
					width = {
						order = 2,
						type = "range",
						name = L["Width"],
						min = 50, max = 500, step = 1,
						get = function(info) return E.db.abm.playerw end,
						set = function(info, value) E.db.abm.playerw = value UF:CreateAndUpdateUF("player") end
					},
					space = {
						order = 3,
						type = "range",
						name = L["Vertical Spacing"],
						min = -10, max = 20, step = 1,
						get = function(info) return E.db.abm.playerSpace end,
						set = function(info, value) E.db.abm.playerSpace = value UF:CreateAndUpdateUF("player") end
					}
				}
			},
			target = {
				order = 3,
				type = "group",
				name = L["Target"],
				guiInline = true,
				args = {
					detach = {
						order = 1,
						type = "toggle",
						name = L["Detach From Frame"],
						get = function(info) return E.db.abm.target end,
						set = function(info, value) E.db.abm.target = value UF:CreateAndUpdateUF("target") ABM:MoverToggle() end
					},
					width = {
						order = 2,
						type = "range",
						name = L["Width"],
						min = 50, max = 500, step = 1,
						get = function(info) return E.db.abm.targetw end,
						set = function(info, value) E.db.abm.targetw = value UF:CreateAndUpdateUF("target") end
					},
					space = {
						order = 3,
						type = "range",
						name = L["Vertical Spacing"],
						min = -10, max = 20, step = 1,
						get = function(info) return E.db.abm.targetSpace end,
						set = function(info, value) E.db.abm.targetSpace = value UF:CreateAndUpdateUF("target") end
					}
				}
			},
			focus = {
				order = 4,
				type = "group",
				name = L["Focus"],
				guiInline = true,
				args = {
					detach = {
						order = 1,
						type = "toggle",
						name = L["Detach From Frame"],
						get = function(info) return E.db.abm.focus end,
						set = function(info, value) E.db.abm.focus = value UF:CreateAndUpdateUF("focus") ABM:MoverToggle() end
					},
					width = {
						order = 2,
						type = "range",
						name = L["Width"],
						min = 50, max = 500, step = 1,
						get = function(info) return E.db.abm.focusw end,
						set = function(info, value) E.db.abm.focusw = value UF:CreateAndUpdateUF("focus") end
					},
					space = {
						order = 3,
						type = "range",
						name = L["Vertical Spacing"],
						min = -10, max = 20, step = 1,
						get = function(info) return E.db.abm.focusSpace end,
						set = function(info, value) E.db.abm.focusSpace = value UF:CreateAndUpdateUF("focus") end
					}
				}
			},
			pet = {
				order = 5,
				type = "group",
				name = L["Pet"],
				guiInline = true,
				args = {
					detach = {
						order = 1,
						type = "toggle",
						name = L["Detach From Frame"],
						get = function(info) return E.db.abm.pet end,
						set = function(info, value) E.db.abm.pet = value UF:CreateAndUpdateUF("pet") ABM:MoverToggle() end
					},
					width = {
						order = 2,
						type = "range",
						name = L["Width"],
						min = 50, max = 500, step = 1,
						get = function(info) return E.db.abm.petw end,
						set = function(info, value) E.db.abm.petw = value UF:CreateAndUpdateUF("pet") end
					},
					space = {
						order = 3,
						type = "range",
						name = L["Vertical Spacing"],
						min = -10, max = 20, step = 1,
						get = function(info) return E.db.abm.petSpace end,
						set = function(info, value) E.db.abm.petSpace = value UF:CreateAndUpdateUF("pet") end
					}
				}
			}
		}
	}
end