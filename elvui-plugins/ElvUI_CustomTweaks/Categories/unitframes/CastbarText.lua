local E, L, V, P, G = unpack(ElvUI)
local CT = E:GetModule("CustomTweaks")
local isEnabled = E.private["unitframe"].enable and E.private["CustomTweaks"] and E.private["CustomTweaks"]["CastbarText"]and true or false

local _G = _G
local pairs = pairs

P["CustomTweaks"]["CastbarText"] = {
	["Player"] = {
		["duration"] = {
			["point"] = "RIGHT",
			["xOffset"] = -4,
			["yOffset"] = 0,
			["color"] = {r = 0.84, g = 0.75, b = 0.65, a = 1}
		},
		["text"] = {
			["point"] = "LEFT",
			["xOffset"] = 4,
			["yOffset"] = 0,
			["color"] = {r = 0.84, g = 0.75, b = 0.65, a = 1}
		}
	},
	["Pet"] = {
		["duration"] = {
			["point"] = "RIGHT",
			["xOffset"] = -4,
			["yOffset"] = 0,
			["color"] = {r = 0.84, g = 0.75, b = 0.65, a = 1}
		},
		["text"] = {
			["point"] = "LEFT",
			["xOffset"] = 4,
			["yOffset"] = 0,
			["color"] = {r = 0.84, g = 0.75, b = 0.65, a = 1}
		}
	},
	["Target"] = {
		["duration"] = {
			["point"] = "RIGHT",
			["xOffset"] = -4,
			["yOffset"] = 0,
			["color"] = {r = 0.84, g = 0.75, b = 0.65, a = 1}
		},
		["text"] = {
			["point"] = "LEFT",
			["xOffset"] = 4,
			["yOffset"] = 0,
			["color"] = {r = 0.84, g = 0.75, b = 0.65, a = 1}
		}
	},
	["Focus"] = {
		["duration"] = {
			["point"] = "RIGHT",
			["xOffset"] = -4,
			["yOffset"] = 0,
			["color"] = {r = 0.84, g = 0.75, b = 0.65, a = 1}
		},
		["text"] = {
			["point"] = "LEFT",
			["xOffset"] = 4,
			["yOffset"] = 0,
			["color"] = {r = 0.84, g = 0.75, b = 0.65, a = 1}
		}
	}
}

local units = {"Player", "Pet", "Target", "Focus"}
local anchorValues = {
	["TOP"] = "TOP",
	["BOTTOM"] = "BOTTOM",
	["CENTER"] = "CENTER",
	["LEFT"] = "LEFT",
	["RIGHT"] = "RIGHT",
}
local PositionCastbarText
local SetCastbarTextColor

local function ConfigTable()
	E.Options.args.elvuiPlugins.args.CustomTweaks.args.Unitframe.args.CastbarText = {
		type = "group",
		name = "CastbarText",
		get = function(info) return E.db.CustomTweaks.CastbarText[info[#info]] end,
		set = function(info, value) E.db.CustomTweaks.CastbarText[info[#info]] = value; end,
		childGroups = "tab",
		args = {}
	}

	local function CreateOptionsGroup(order, name, unit)
		local group = {
			order = order,
			type = "group",
			name = name,
			args = {
				duration = {
					order = 1,
					type = "group",
					name = L["Duration"],
					guiInline = true,
					get = function(info) return E.db.CustomTweaks.CastbarText[unit].duration[info[#info]] end,
					set = function(info, value) E.db.CustomTweaks.CastbarText[unit].duration[info[#info]] = value; PositionCastbarText(unit) end,
					disabled = function() return not isEnabled end,
					args = {
						color = {
							order = 1,
							type = "color",
							name = COLOR,
							hasAlpha = true,
							get = function(info)
								local t = E.db.CustomTweaks.CastbarText[unit].duration.color
								local d = P.CustomTweaks.CastbarText[unit].duration.color
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								E.db.CustomTweaks.CastbarText[unit].duration.color = {}
								local t = E.db.CustomTweaks.CastbarText[unit].duration.color
								t.r, t.g, t.b, t.a = r, g, b, a
								SetCastbarTextColor(unit)
							end
						},
						point = {
							order = 2,
							type = "select",
							name = L["Anchor Point"],
							values = anchorValues
						},
						xOffset = {
							order = 3,
							type = "range",
							name = L["X-Offset"],
							min = -50, max = 50, step = 1
						},
						yOffset = {
							order = 4,
							type = "range",
							name = L["Y-Offset"],
							min = -50, max = 50, step = 1
						}
					}
				},
				text = {
					order = 2,
					type = "group",
					name = L["Text"],
					guiInline = true,
					get = function(info) return E.db.CustomTweaks.CastbarText[unit].text[info[#info]] end,
					set = function(info, value) E.db.CustomTweaks.CastbarText[unit].text[info[#info]] = value; PositionCastbarText(unit) end,
					disabled = function() return not isEnabled end,
					args = {
						color = {
							order = 1,
							type = "color",
							name = COLOR,
							hasAlpha = true,
							get = function(info)
								local t = E.db.CustomTweaks.CastbarText[unit].text.color
								local d = P.CustomTweaks.CastbarText[unit].text.color
								return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
							end,
							set = function(info, r, g, b, a)
								E.db.CustomTweaks.CastbarText[unit].text.color = {}
								local t = E.db.CustomTweaks.CastbarText[unit].text.color
								t.r, t.g, t.b, t.a = r, g, b, a
								SetCastbarTextColor(unit)
							end
						},
						point = {
							order = 2,
							type = "select",
							name = L["Anchor Point"],
							values = anchorValues
						},
						xOffset = {
							order = 3,
							type = "range",
							name = L["X-Offset"],
							min = -50, max = 50, step = 1
						},
						yOffset = {
							order = 4,
							type = "range",
							name = L["Y-Offset"],
							min = -50, max = 50, step = 1
						}
					}
				}
			}
		}

		return group
	end

	local options = E.Options.args.elvuiPlugins.args.CustomTweaks.args.Unitframe.args.CastbarText.args
	options.player = CreateOptionsGroup(1, L["Player"], "Player")
	options.pet = CreateOptionsGroup(2, L["Pet"], "Pet")
	options.target = CreateOptionsGroup(3, L["Target"], "Target")
	options.focus = CreateOptionsGroup(4, L["Focus"], "Focus")
end
CT.Configs["CastbarText"] = ConfigTable
if not isEnabled then return; end

function PositionCastbarText(unit)
	local pointText = E.db.CustomTweaks.CastbarText[unit].text.point
	local xOffsetText = E.db.CustomTweaks.CastbarText[unit].text.xOffset
	local yOffsetText = E.db.CustomTweaks.CastbarText[unit].text.yOffset
	local pointDuration = E.db.CustomTweaks.CastbarText[unit].duration.point
	local xOffsetDuration = E.db.CustomTweaks.CastbarText[unit].duration.xOffset
	local yOffsetDuration =	E.db.CustomTweaks.CastbarText[unit].duration.yOffset

	local unitframe = _G["ElvUF_"..unit]
	local castbar = unitframe and unitframe.Castbar

	if castbar then
		castbar.Text:ClearAllPoints()
		castbar.Text:SetPoint(pointText, castbar, pointText, xOffsetText, yOffsetText)
		castbar.Time:ClearAllPoints()
		castbar.Time:SetPoint(pointDuration, castbar, pointDuration, xOffsetDuration, yOffsetDuration)
	end
end

function SetCastbarTextColor(unit)
	local durationColor = E.db.CustomTweaks.CastbarText[unit].duration.color
	local textColor = E.db.CustomTweaks.CastbarText[unit].text.color

	local unitframe = _G["ElvUF_"..unit]
	local castbar = unitframe and unitframe.Castbar

	if castbar then
		castbar.Text:SetTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
		castbar.Time:SetTextColor(durationColor.r, durationColor.g, durationColor.b, durationColor.a)
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	for _, unit in pairs(units) do
		PositionCastbarText(unit)
		SetCastbarTextColor(unit)
	end
end)