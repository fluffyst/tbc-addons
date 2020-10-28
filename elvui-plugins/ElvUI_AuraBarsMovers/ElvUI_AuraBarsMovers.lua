local E, L, V, P, G = unpack(ElvUI)
local ABM = E:NewModule("AuraBarMovers", "AceHook-3.0", "AceEvent-3.0")
local UF = E:GetModule("UnitFrames")
local EP = LibStub("LibElvUIPlugin-1.0")

local _G = _G

P["abm"] = {
	["player"] = false,
	["playerw"] = E.db.unitframe.units.player.width,
	["playerSpace"] = 0,
	
	["target"] = false,
	["targetw"] = E.db.unitframe.units.target.width,
	["targetSpace"] = 0,

	["focus"] = false,
	["focusw"] = E.db.unitframe.units.focus.width,
	["focusSpace"] = 0,

	["pet"] = false,
	["petw"] = E.db.unitframe.units.pet.width,
	["petSpace"] = 0
}
function ABM:PlayerABmove()
	local auraBar = _G["ElvUF_Player"].AuraBars
	--Create Holder frame for our AuraBar Mover
	local holder = CreateFrame("Frame", nil, auraBar)
	holder:Point("BOTTOM", _G["ElvUF_Player"], "TOP", 0, 0)
	auraBar:Point("BOTTOM", holder, "TOP", 0, 0)
	auraBar.Holder = holder

	E:CreateMover(auraBar.Holder, "ElvUF_PlayerAuraMover", L["Player Aura Bars"], nil, nil, nil, "ALL,SOLO", nil, "elvuiPlugins,auraBarMovers")
	UF:CreateAndUpdateUF("player")
end

function ABM:TargetABmove()
	local auraBar = _G["ElvUF_Target"].AuraBars
	--Create Holder frame for our AuraBar Mover
	local holder = CreateFrame("Frame", nil, auraBar)
	holder:Point("BOTTOM", _G["ElvUF_Target"], "TOP", 0, 0)
	auraBar:Point("BOTTOM", holder, "TOP", 0, 0)
	auraBar.Holder = holder

	E:CreateMover(auraBar.Holder, "ElvUF_TargetAuraMover", L["Target Aura Bars"], nil, nil, nil, "ALL,SOLO", nil, "elvuiPlugins,auraBarMovers")
	UF:CreateAndUpdateUF("target")
end

function ABM:FocusABmove()
	local auraBar = _G["ElvUF_Focus"].AuraBars
	--Create Holder frame for our AuraBar Mover
	local holder = CreateFrame("Frame", nil, auraBar)
	holder:Point("BOTTOM", _G["ElvUF_Focus"], "TOP", 0, 0)
	auraBar:Point("BOTTOM", holder, "TOP", 0, 0)
	auraBar.Holder = holder

	E:CreateMover(auraBar.Holder, "ElvUF_FocusAuraMover", L["Focus Aura Bars"], nil, nil, nil, "ALL,SOLO", nil, "elvuiPlugins,auraBarMovers")
	UF:CreateAndUpdateUF("focus")
end

function ABM:PetABmove()
	local auraBar = _G["ElvUF_Pet"].AuraBars
	--Create Holder frame for our AuraBar Mover
	local holder = CreateFrame("Frame", nil, auraBar)
	holder:Point("BOTTOM", _G["ElvUF_Pet"], "TOP", 0, 0)
	auraBar:Point("BOTTOM", holder, "TOP", 0, 0)
	auraBar.Holder = holder

	E:CreateMover(auraBar.Holder, "ElvUF_PetAuraMover", L["Pet Aura Bars"], nil, nil, nil, "ALL,SOLO", nil, "elvuiPlugins,auraBarMovers")
	UF:CreateAndUpdateUF("pet")
end

function ABM:Configure_AuraBars(frame)
	local unit = frame.unit
	local db = frame.db
	if not db.aurabar.enable then return end
	if E.db.abm[unit] == nil then return end
	local POWERBAR_OFFSET = db.power.offset
	local auraBars = frame.AuraBars

	if frame and auraBars and auraBars.spacing then
		auraBars.spacing = (E.PixelMode and -1 or 1) + E.db.abm[unit.."Space"]
	end

	local anchorPoint, anchorTo = "BOTTOM", "TOP"
	if db.aurabar.anchorPoint == "BELOW" then
		anchorPoint, anchorTo = "TOP", "BOTTOM"
	end

	--Set size of mover
	auraBars.Holder:Width(E.db.abm[unit.."w"])
	auraBars.Holder:Height(20)
	auraBars.Holder:GetScript("OnSizeChanged")(auraBars.Holder)

	auraBars:ClearAllPoints()

	if not E.db.abm[unit] then
		local attachTo
		if db.aurabar.attachTo == "BUFFS" then
			attachTo = frame.Buffs
		elseif db.aurabar.attachTo == "DEBUFFS" then
			attachTo = frame.Debuffs
		end

		local yOffset = 0
		if E.PixelMode then
			if db.aurabar.anchorPoint == "BELOW" then
				yOffset = 1
			else
				yOffset = -1
			end
		end

		local BarWidth = E.db.abm[unit.."w"] - db.width
		local xCoord = attachTo == frame and POWERBAR_OFFSET * (anchorTo == "BOTTOM" and 0 or -1) or 0
		xCoord = xCoord + BarWidth

		auraBars:SetPoint(anchorPoint.."LEFT", attachTo, anchorTo.."LEFT", (attachTo == frame and anchorTo == "BOTTOM") and POWERBAR_OFFSET or 0, E.PixelMode and anchorPoint ==  -1 or yOffset)
		auraBars:SetPoint(anchorPoint.."RIGHT", attachTo, anchorTo.."RIGHT", xCoord, E.PixelMode and -1 or yOffset)
	else
		auraBars:SetPoint(anchorPoint.."LEFT", auraBars.Holder, anchorTo.."LEFT")
		auraBars:SetPoint(anchorPoint.."RIGHT", auraBars.Holder, anchorTo.."RIGHT", -POWERBAR_OFFSET, 0)
	end
	auraBars:SetAnchors()

	frame:UpdateAllElements("AurabarsMovers_UpdateAllElements")
end

function ABM:ChangeTarget()
	UF:CreateAndUpdateUF("target")
	self:UnregisterEvent("PLAYER_TARGET_CHANGED")
end

function ABM:MoverToggle()
	if E.db.abm.player then
		E:EnableMover("ElvUF_PlayerAuraMover")
	else
		E:DisableMover("ElvUF_PlayerAuraMover")
	end
	if E.db.abm.target then
		E:EnableMover("ElvUF_TargetAuraMover")
	else
		E:DisableMover("ElvUF_TargetAuraMover")
	end
	if E.db.abm.focus then
		E:EnableMover("ElvUF_FocusAuraMover")
	else
		E:DisableMover("ElvUF_FocusAuraMover")
	end
	if E.db.abm.pet then
		E:EnableMover("ElvUF_PetAuraMover")
	else
		E:DisableMover("ElvUF_PetAuraMover")
	end
end

function ABM:Initialize()
	EP:RegisterPlugin("ElvUI_AuraBarsMovers", ABM.GetOptions)

	ABM:PlayerABmove()
	ABM:TargetABmove()
	ABM:FocusABmove()
	ABM:PetABmove()

	hooksecurefunc(UF, "Configure_AuraBars", ABM.Configure_AuraBars)

	self:RegisterEvent("PLAYER_TARGET_CHANGED", "ChangeTarget")
	ABM:MoverToggle()
end

local function InitializeCallback()
	ABM:Initialize()
end

E:RegisterModule(ABM:GetName(), InitializeCallback)