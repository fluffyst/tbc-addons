local E, L, V, P, G = unpack(ElvUI)
local CT = E:NewModule("CustomTweaks", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
local EP = LibStub("LibElvUIPlugin-1.0")
local addon = "ElvUI_CustomTweaks"

local pairs = pairs
local format = string.format

local function ColorizeSettingName(settingName)
	return format("|cff4bff2c%s|r", settingName)
end

CT.Configs = {}
P["CustomTweaks"] = {}
V["CustomTweaks"] = {}

local Tweaks = {
	["ActionBars"] = {
		{"PushedColor", L["Allows you to choose the color of the actionbar button when it is pushed down."]},
		{"ClickThroughActionBars", L["Allows you to make actionbars clickthrough."]}
	},
	["Bags"] = {
		{"BagButtons", L["Allows you to change bag buttons to use the classic texture style and allows you to add a 'Stack' button."]}
	},
	["Chat"] = {
	 	{"ChatMaxLines", L["Increases the amount of messages saved in a chat window, before they get replaced by new messages."]}
	},
	["Datatexts"] = {
		{"BagsTextFormat", L["Allows you to choose which text format the Bags datatext uses."]}
	},
	["Minimap"] = {
		{"MinimapSizeLimits", L["Lowers the minimum allowed minimap size."]}
	},
	["Misc"] = {
		{"NoBorders", L["Attempts to remove borders on all ElvUI elements. This doesn't work on all statusbars, so some borders will be kept intact."]}
	},
	["Unitframe"] = {
		{"AuraIconSpacing", L["Allows you to set a spacing between individual aura icons for the units you choose."]},
		{"AuraIconText", L["Allows you to position the unitframe aura duration and stack text or hide it."]},
		{"CastbarCustomBackdrop", L["Allows you to use a custom castbar backdrop color."]},
		{"CastbarText", L["Allows you to position and change color and alpha of castbar text."]},
		{"PowerBarTexture", L["Allows you to use a separate texture for unitframe power bars."]},
		{"UnitFrameSpacingLimits", L["Increases the maximum allowed vertical and horizontal spacing for party and raid frames."]},
		{"CastbarFont", L["Allows you to change the text and duration font for the castbar."]}
	}
}

local function buildCategory(category, groupName)
	E.Options.args.elvuiPlugins.args.CustomTweaks.args[category] = {
		order = 100,
		type = "group",
		name = groupName,
		childGroups = "tab",
		args = {
			header = {
				order = 1,
				type = "header",
				name = ColorizeSettingName(groupName)
			},
			tweaks = {
				order = 2,
				type = "group",
				name = "",
				guiInline = true,
				args = {}
			}
		}
	}
end

function CT:ConfigTable()
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
				customTweakShortcut = {
					type = "execute",
					name = ColorizeSettingName(L["Custom Tweaks"]),
					func = function()
						if IsAddOnLoaded("ElvUI_Config") then
							local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
							ACD:SelectGroup("ElvUI", "elvuiPlugins", "CustomTweaks")
						end
					end
				}
			}
		}
	elseif not E.Options.args.elvuiPlugins.args.customTweakShortcut then
		E.Options.args.elvuiPlugins.args.customTweakShortcut = {
			type = "execute",
			name = ColorizeSettingName(L["Custom Tweaks"]),
			func = function()
				if IsAddOnLoaded("ElvUI_Config") then
					local ACD = LibStub("AceConfigDialog-3.0-ElvUI")
					ACD:SelectGroup("ElvUI", "elvuiPlugins", "CustomTweaks")
				end
			end
		}
	end

	E.Options.args.elvuiPlugins.args.CustomTweaks = {
		type = "group",
		name = ColorizeSettingName(L["Custom Tweaks"]),
		childGroups = "tab",
		args = {
			header = {
				order = 0,
				type = "header",
				name = L["Custom Tweaks"]
			}
		}
	}

	for cat, tweaks in pairs(Tweaks) do
		buildCategory(cat, L[cat])
		for _, tweak in pairs(tweaks) do
			local tName = tweak[1]
			local tDesc = tweak[2]
			E.Options.args.elvuiPlugins.args.CustomTweaks.args[cat].args.tweaks.args[tName] = {
				type = "toggle",
				name = ColorizeSettingName(tName),
				desc = tDesc,
				get = function(info) return E.private["CustomTweaks"][tName] end,
				set = function(info, value) E.private["CustomTweaks"][tName] = value E:StaticPopup_Show("PRIVATE_RL") end
			}
		end
	end

	for _, func in pairs(CT.Configs) do func() end
end

function CT:Initialize()
	EP:RegisterPlugin(addon, CT.ConfigTable)
end

local function InitializeCallback()
	CT:Initialize()
end

E:RegisterModule(CT:GetName(), InitializeCallback)