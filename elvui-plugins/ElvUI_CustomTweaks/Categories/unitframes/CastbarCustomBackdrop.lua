local E, L, V, P, G = unpack(ElvUI)
local CT = E:GetModule("CustomTweaks")
local isEnabled = E.private["unitframe"].enable and E.private["CustomTweaks"] and E.private["CustomTweaks"]["CastbarCustomBackdrop"]and true or false

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

P["CustomTweaks"]["CastbarCustomBackdrop"] = {
	["backdropColor"] = {r = 0.16, g = 0.16, b = 0.16, a = 1}
}

local units = {"Player", "Target", "Focus", "Pet"}

local function ConfigTable()
	E.Options.args.elvuiPlugins.args.CustomTweaks.args.Unitframe.args.CastbarCustomBackdrop = {
		type = "group",
		name = "CastbarCustomBackdrop",
		get = function(info) return E.db.CustomTweaks.CastbarCustomBackdrop[info[#info]] end,
		set = function(info, value) E.db.CustomTweaks.CastbarCustomBackdrop[info[#info]] = value; end,
		args = {
			backdropColor = {
				order = 1,
				type = "color",
				name = L["Castbar Backdrop Color"],
				disabled = function() return not isEnabled end,
				hasAlpha = true,
				get = function(info)
					local t = E.db.CustomTweaks.CastbarCustomBackdrop.backdropColor
					local d = P.CustomTweaks.CastbarCustomBackdrop.backdropColor
					return t.r, t.g, t.b, t.a, d.r, d.g, d.b, d.a
				end,
				set = function(info, r, g, b, a)
					E.db.CustomTweaks.CastbarCustomBackdrop.backdropColor = {}
					local t = E.db.CustomTweaks.CastbarCustomBackdrop.backdropColor
					t.r, t.g, t.b, t.a = r, g, b, a
				end
			}
		}
	}
end
CT.Configs["CastbarCustomBackdrop"] = ConfigTable
if not isEnabled then return end

local function PostCastChannelStart(self, unit)
	local db = self:GetParent().db
	if not db or not db.castbar then return; end

	local color = E.db.CustomTweaks.CastbarCustomBackdrop.backdropColor
	local r, g, b, a = color.r, color.g, color.b, color.a

	if self.bg and self.bg:IsShown() then
		self.bg:SetTexture(r, g, b)
	else
		if self.backdrop then
			self.backdrop:SetBackdropColor(r, g, b, a)
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	for _, unit in pairs(units) do
		local unitframe = _G["ElvUF_"..unit]
		local castbar = unitframe and unitframe.Castbar
		if castbar then
			hooksecurefunc(castbar, "PostCastStart", PostCastChannelStart)
			hooksecurefunc(castbar, "PostChannelStart", PostCastChannelStart)
		end
	end
end)