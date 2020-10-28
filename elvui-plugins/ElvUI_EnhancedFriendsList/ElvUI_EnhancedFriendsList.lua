local E, L, V, P, G = unpack(ElvUI)
local EFL = E:NewModule("EnhancedFriendsList", "AceHook-3.0")
local S = E:GetModule("Skins")
local EP = LibStub("LibElvUIPlugin-1.0")
local LSM = LibStub("LibSharedMedia-3.0", true)

local unpack, pairs, ipairs, tonumber = unpack, pairs, ipairs, tonumber
local format, sub = string.format, string.sub

local GetFriendInfo = GetFriendInfo
local GetQuestDifficultyColor = GetQuestDifficultyColor
local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS
local LEVEL = LEVEL
local LOCALIZED_CLASS_NAMES_FEMALE = LOCALIZED_CLASS_NAMES_FEMALE
local LOCALIZED_CLASS_NAMES_MALE = LOCALIZED_CLASS_NAMES_MALE
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

FRIENDS_WOW_NAME_COLOR = {r = 0.996, g = 0.882, b = 0.361}
FRIENDS_GRAY_COLOR = {r = 0.486, g = 0.518, b = 0.541}

local StatusIcons = {
	Default = {
		Online = "Interface\\AddOns\\ElvUI_EnhancedFriendsList\\Media\\Textures\\Default\\Online",
		Offline = "Interface\\AddOns\\ElvUI_EnhancedFriendsList\\Media\\Textures\\Default\\Offline",
		DND = "Interface\\AddOns\\ElvUI_EnhancedFriendsList\\Media\\Textures\\Default\\DND",
		AFK = "Interface\\AddOns\\ElvUI_EnhancedFriendsList\\Media\\Textures\\Default\\AFK"
	},
	Square = {
		Online = "Interface\\AddOns\\ElvUI_EnhancedFriendsList\\Media\\Textures\\Square\\Online",
		Offline = "Interface\\AddOns\\ElvUI_EnhancedFriendsList\\Media\\Textures\\Square\\Offline",
		DND = "Interface\\AddOns\\ElvUI_EnhancedFriendsList\\Media\\Textures\\Square\\DND",
		AFK = "Interface\\AddOns\\ElvUI_EnhancedFriendsList\\Media\\Textures\\Square\\AFK"
	},
	D3 = {
		Online = "Interface\\AddOns\\ElvUI_EnhancedFriendsList\\Media\\Textures\\D3\\Online",
		Offline = "Interface\\AddOns\\ElvUI_EnhancedFriendsList\\Media\\Textures\\D3\\Offline",
		DND = "Interface\\AddOns\\ElvUI_EnhancedFriendsList\\Media\\Textures\\D3\\DND",
		AFK = "Interface\\AddOns\\ElvUI_EnhancedFriendsList\\Media\\Textures\\D3\\AFK"
	}
}

local function timeDiff(t2, t1)
	if t2 < t1 then return end

	local d1, d2, carry, diff = date("*t", t1), date("*t", t2), false, {}
	local colMax = {60, 60, 24, date("*t", time{year = d1.year,month = d1.month + 1, day = 0}).day, 12}

	d2.hour = d2.hour - (d2.isdst and 1 or 0) + (d1.isdst and 1 or 0)
	for i, v in ipairs({"sec", "min", "hour", "day", "month", "year"}) do
		diff[v] = d2[v] - d1[v] + (carry and -1 or 0)
		carry = diff[v] < 0
		if carry then diff[v] = diff[v] + colMax[i] end
	end

	return diff
end

local function GetLevelDiffColorHex(level, offline)
	if level ~= 0 then
		local color = GetQuestDifficultyColor(level)
		return offline and format("|cFF%02x%02x%02x", color.r*160, color.g*160, color.b*160) or format("|cFF%02x%02x%02x", color.r*255, color.g*255, color.b*255)
	else
		return offline and E:RGBToHex(0.49, 0.52, 0.54) or "|cFFFFFFFF"
	end
end

local localizedTable = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	localizedTable[v] = k
end

for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	localizedTable[v] = k
end

local function GetClassColorHex(class, offline)
	class = localizedTable[class]

	local color = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
	if color then
		return offline and format("|cff%02x%02x%02x", color.r*160, color.g*160, color.b*160) or format("|cff%02x%02x%02x", color.r*255, color.g*255, color.b*255)
	else
		return offline and E:RGBToHex(0.49, 0.52, 0.54) or "|cFFFFFFFF"
	end
end

local function HexToRGB(hex)
	if not hex then return nil end

	local rhex, ghex, bhex = sub(hex, 5, 6), sub(hex, 7, 8), sub(hex, 9, 10)
	return {r = tonumber(rhex, 16)/225, g = tonumber(ghex, 16)/225, b = tonumber(bhex, 16)/225}
end

function EFL:Update()
	for i = 1, FRIENDS_TO_DISPLAY do
		local button = _G["FriendsFrameFriendButton"..i]

		self:Configure_Background(button)
		self:Configure_Status(button)
		self:Configure_IconFrame(button)

		button.name:SetFont(LSM:Fetch("font", E.db.enhanceFriendsList.nameFont), E.db.enhanceFriendsList.nameFontSize, E.db.enhanceFriendsList.nameFontOutline)
		button.info:SetFont(LSM:Fetch("font", E.db.enhanceFriendsList.zoneFont), E.db.enhanceFriendsList.zoneFontSize, E.db.enhanceFriendsList.zoneFontOutline)
	end
end

-- Status
function EFL:Update_Status(button)
	if not E.db.enhanceFriendsList.showStatusIcon then return end

	if button.TYPE == "Online" then
		button.status:SetTexture(StatusIcons[E.db.enhanceFriendsList.statusIcons][(button.statusType == CHAT_FLAG_DND and "DND" or button.statusType == CHAT_FLAG_AFK and "AFK" or "Online")])
	else
		button.status:SetTexture(StatusIcons[E.db.enhanceFriendsList.statusIcons].Offline)
	end
end

function EFL:Configure_Status(button)
	if E.db.enhanceFriendsList.showStatusIcon then
		button.status:Show()
	else
		button.status:Hide()
	end
end

function EFL:Construct_Status(button)
	button.status = button:CreateTexture()
	button.status:SetSize(16, 16)
	button.status:SetPoint("LEFT", 4, 7)
end

-- Name
function EFL:Update_Name(button)
	local isOffline = button.TYPE == "Offline" or false

	local enhancedName = (self.db[button.TYPE].enhancedName and GetClassColorHex(button.class, isOffline)..button.nameText.."|r" or button.nameText)
	local enhancedLevel = self.db[button.TYPE].level and button.levelText and format(self.db[button.TYPE].levelText and (self.db[button.TYPE].shortLevel and L["SHORT_LEVEL_TEMPLATE"] or L["LEVEL_TEMPLATE"]) or "%s", self.db[button.TYPE].levelColor and GetLevelDiffColorHex(button.levelText, isOffline)..button.levelText.."|r" or button.levelText).." " or ""
	local enhancedClass = self.db[button.TYPE].classText and button.class or ""
	button.name:SetText(enhancedName..((enhancedLevel ~= "" or enhancedClass ~= "") and (self.db[button.TYPE].enhancedName and " - " or ", ") or "")..enhancedLevel..enhancedClass)

	local nameColor = self.db[button.TYPE].enhancedName and (self.db[button.TYPE].colorizeNameOnly and (isOffline and FRIENDS_GRAY_COLOR or HIGHLIGHT_FONT_COLOR) or HexToRGB(GetClassColorHex(button.class, isOffline))) or (isOffline and FRIENDS_GRAY_COLOR or FRIENDS_WOW_NAME_COLOR)
	button.name:SetTextColor(nameColor.r, nameColor.g, nameColor.b)

	local infoText
	if isOffline then
		if button.lastSeen then
			local td = timeDiff(time(), tonumber(button.lastSeen))
			infoText = (self.db[button.TYPE].zoneText and button.area and button.area..(self.db[button.TYPE].lastSeen and " - " or "") or "")..(self.db[button.TYPE].lastSeen and L["Last seen"].." "..RecentTimeDate(td.year, td.month, td.day, td.hour) or "")
		else
			infoText = self.db[button.TYPE].zoneText and button.area or ""
		end

		button.info:SetTextColor(0.49, 0.52, 0.54)
	else
		infoText = self.db[button.TYPE].zoneText and button.area or ""

		local playerZone = GetRealZoneText()
		if self.db[button.TYPE].enhancedZone then
			if self.db[button.TYPE].sameZone then
				if infoText == playerZone then
					button.info:SetTextColor(self.db[button.TYPE].sameZoneColor.r, self.db[button.TYPE].sameZoneColor.g, self.db[button.TYPE].sameZoneColor.b)
				else
					button.info:SetTextColor(self.db[button.TYPE].enhancedZoneColor.r, self.db[button.TYPE].enhancedZoneColor.g, self.db[button.TYPE].enhancedZoneColor.b)
				end
			else
				button.info:SetTextColor(self.db[button.TYPE].enhancedZoneColor.r, self.db[button.TYPE].enhancedZoneColor.g, self.db[button.TYPE].enhancedZoneColor.b)
			end
		else
			if self.db[button.TYPE].sameZone then
				if infoText == playerZone then
					button.info:SetTextColor(self.db[button.TYPE].sameZoneColor.r, self.db[button.TYPE].sameZoneColor.g, self.db[button.TYPE].sameZoneColor.b)
				else
					button.info:SetTextColor(0.49, 0.52, 0.54)
				end
			else
				button.info:SetTextColor(0.49, 0.52, 0.54)
			end
		end
	end
	button.info:SetText(infoText)

	button.name:ClearAllPoints()
	if button.iconFrame:IsShown() then
		button.name:Point("LEFT", button.iconFrame, "RIGHT", 9, infoText ~= "" and 7 or 0)
	else
		if E.db.enhanceFriendsList.showStatusIcon or E.db.enhanceFriendsList.showNoteIcon then
			button.name:Point("TOPLEFT", 28, infoText ~= "" and -3 or -10)
		else
			button.name:Point("TOPLEFT", 9, infoText ~= "" and -3 or -10)
		end
	end
end

-- IconFrame
function EFL:Update_IconFrame(button)
	if E.db.enhanceFriendsList[button.TYPE].classIcon then
		local classFileName = localizedTable[button.class]
		if classFileName then
			button.iconFrame:Show()

			button.iconFrame.texture:SetTexCoord(unpack(CLASS_ICON_TCOORDS[classFileName]))
			button.iconFrame:SetAlpha(button.TYPE == "Online" and 1 or 0.6)

			if E.db.enhanceFriendsList.Online.classIconStatusColor then
				if button.TYPE == "Online" then
					if button.statusType == "" then
						if E.PixelMode then
							button.iconFrame:SetBackdropBorderColor(0, 0, 0, 1)
						else
							button.iconFrame:SetBackdropBorderColor(0, 0, 0, 0)
						end
					elseif button.statusType == CHAT_FLAG_AFK then
						button.iconFrame:SetBackdropBorderColor(1, 1, 0)
					elseif button.statusType == CHAT_FLAG_DND then
						button.iconFrame:SetBackdropBorderColor(1, 0, 0)
					end
				else
					if E.PixelMode then
						button.iconFrame:SetBackdropBorderColor(0, 0, 0, 1)
					else
						button.iconFrame:SetBackdropBorderColor(0, 0, 0, 0)
					end
				end
			else
				button.iconFrame:SetBackdropBorderColor(unpack(E["media"].bordercolor))
			end
		else
			button.iconFrame:Hide()
		end
	elseif button.iconFrame:IsShown() then
		button.iconFrame:Hide()
	end
end

function EFL:Configure_IconFrame(button)
	button.iconFrame:ClearAllPoints()
	if E.db.enhanceFriendsList.showStatusIcon or E.db.enhanceFriendsList.showNoteIcon then
		button.iconFrame:Point("LEFT", 22, 0)
	else
		button.iconFrame:Point("LEFT", 3, 0)
	end
end

function EFL:Construct_IconFrame(button)
	button.iconFrame = CreateFrame("Frame", "$parentIconFrame", button)
	button.iconFrame:Size(26)
	button.iconFrame:SetTemplate("Default")

	button.iconFrame.texture = button.iconFrame:CreateTexture()
	button.iconFrame.texture:SetAllPoints()
	button.iconFrame.texture:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
	button.iconFrame:Hide()
end

-- NoteIcon
function EFL:Update_NoteIcon(button)
	button.note:ClearAllPoints()

	if E.db.enhanceFriendsList.showStatusIcon then
		button.note:Point("LEFT", 3, -7)
	else
		button.note:Point("LEFT", 3, 5)
	end

	if E.db.enhanceFriendsList.showNoteIcon then
		button.note:Show()
	else
		button.note:Hide()
	end
end

function EFL:Construct_NoteIcon(button)
	button.note:Size(18)

	button.note.tex = button.note:CreateTexture(nil, "OVERLAY")
	button.note.tex:SetTexture([[Interface\AddOns\ElvUI\media\textures\copy]])
	button.note.tex:SetInside()
	button.note.tex:SetAlpha(0.3)

	button.note:HookScript2("OnEnter", function() button.note.tex:SetAlpha(1) end)
	button.note:HookScript2("OnLeave", function() button.note.tex:SetAlpha(0.3) end)
end

-- Background
function EFL:Update_Background(button)
	if not E.db.enhanceFriendsList.showBackground then return end

	if button.TYPE == "Online" then
		button.backgroundLeft:SetGradientAlpha("Horizontal", 1,0.824,0,0.05, 1,0.824,0,0)
		button.backgroundRight:SetGradientAlpha("Horizontal", 1,0.824,0,0, 1,0.824,0,0.05)
	else
		button.backgroundLeft:SetGradientAlpha("Horizontal", 0.588,0.588,0.588,0.05, 0.588,0.588,0.588,0)
		button.backgroundRight:SetGradientAlpha("Horizontal", 0.588,0.588,0.588,0, 0.588,0.588,0.588,0.05)
	end
end

function EFL:Configure_Background(button)
	if E.db.enhanceFriendsList.showBackground then
		button.backgroundLeft:Show()
		button.backgroundRight:Show()
	else
		button.backgroundLeft:Hide()
		button.backgroundRight:Hide()
	end
end

function EFL:Construct_Background(button)
	local width, height = (button:GetWidth() * 0.5), (button:GetHeight() * 0.92)

	button.backgroundLeft = button:CreateTexture(nil, "BACKGROUND")
	button.backgroundLeft:Size(width, height)
	button.backgroundLeft:SetPoint("LEFT", button, "CENTER")
	button.backgroundLeft:SetTexture(E.media.blankTex)
	button.backgroundLeft:SetGradientAlpha("Horizontal", 1,0.824,0.0,0.05, 1,0.824,0.0,0)

	button.backgroundRight = button:CreateTexture(nil, "BACKGROUND")
	button.backgroundRight:Size(width, height)
	button.backgroundRight:SetPoint("RIGHT", button, "CENTER")
	button.backgroundRight:SetTexture(E.media.blankTex)
	button.backgroundRight:SetGradientAlpha("Horizontal", 1,0.824,0.0,0, 1,0.824,0.0,0.05)
end

-- Highlight
function EFL:Update_Highlight(button)
	if button.TYPE == "Online" then
		if button.statusType == "" then
			button.highlightLeft:SetGradientAlpha("Horizontal", 0.243,0.570,1,0.35, 0.243,0.570,1,0)
			button.highlightRight:SetGradientAlpha("Horizontal", 0.243,0.570,1,0, 0.243,0.570,1,0.35)
		elseif button.statusType == CHAT_FLAG_AFK then
			button.highlightLeft:SetGradientAlpha("Horizontal", 1,1,0,0.35, 1,1,0,0)
			button.highlightRight:SetGradientAlpha("Horizontal", 1,1,0,0, 1,1,0,0.35)
		elseif button.statusType == CHAT_FLAG_DND then
			button.highlightLeft:SetGradientAlpha("Horizontal", 1,0,0,0.35, 1,0,0,0)
			button.highlightRight:SetGradientAlpha("Horizontal", 1,0,0,0, 1,0,0,0.35)
		end
	else
		button.highlightLeft:SetGradientAlpha("Horizontal", 0.486,0.518,0.541,0.35, 0.486,0.518,0.541,0)
		button.highlightRight:SetGradientAlpha("Horizontal", 0.486,0.518,0.541,0, 0.486,0.518,0.541,0.35)
	end
end

function EFL:Construct_Highlight(button)
	button:SetHighlightTexture(nil)
	local width, height = (button:GetWidth() * 0.5), (button:GetHeight() * 0.92)

	button.highlightLeft = button:CreateTexture(nil, "HIGHLIGHT")
	button.highlightLeft:Size(width, height)
	button.highlightLeft:SetPoint("LEFT", button, "CENTER")
	button.highlightLeft:SetTexture(E.media.blankTex)
	button.highlightLeft:SetGradientAlpha("Horizontal", 0.243,0.570,1,0.35, 0.243,0.570,1,0)

	button.highlightRight = button:CreateTexture(nil, "HIGHLIGHT")
	button.highlightRight:Size(width, height)
	button.highlightRight:SetPoint("RIGHT", button, "CENTER")
	button.highlightRight:SetTexture(E.media.blankTex)
	button.highlightRight:SetGradientAlpha("Horizontal", 0.243,0.570,1,0, 0.243,0.570,1,0.35)
end

-- Tooltip
function EFL:Construct_Tooltip(button)
	button:SetScript("OnEnter", function(self)
		if not E.db.enhanceFriendsList.showTooltipInfo then return end

		GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 33, 30)
		-- name
		if button.TYPE == "Offline" then
			GameTooltip:AddLine(self.nameText, 0.5, 0.5, 0.5)
		else
			GameTooltip:AddLine(self.nameText)
		end
		-- class
		if button.TYPE == "Online" and self.class then
			GameTooltip:AddLine(LEVEL.." "..self.levelText.." "..self.class, 1, 1, 1)
		end
		-- area
		if button.TYPE == "Online" and self.area then
			GameTooltip:AddLine(self.area, 0.5, 0.5, 0.5)
		end
		-- noteText
		if self.noteText then
			GameTooltip:AddLine("|TInterface\\FriendsFrame\\UI-FriendsFrame-Note:16:16:0:0|t"..self.noteText)
		end
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function()
		if E.db.enhanceFriendsList.showTooltipInfo then
			GameTooltip:Hide()
		end
	end)
end

function EFL:GetLocalFriendInfo(name)
	local info = EnhancedFriendsListDB[E.myrealm][name]
	if info then
		return info[1], info[2], info[3], info[4]
	else
		return nil, nil, nil, nil
	end
end

function EFL:FriendsList_Update()
	local nameLocationText, infoText, noteText, noteHiddenText
	local name, level, class, area, connected, status
	local button

	local friendOffset = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame)
	local friendIndex
	for i = 1, FRIENDS_TO_DISPLAY, 1 do
		friendIndex = friendOffset + i
		local name, level, class, area, connected, status, noteText = GetFriendInfo(friendIndex)
		if not name then return end

		button = _G["FriendsFrameFriendButton"..i]
		button.nameText = name
		button.TYPE = connected and "Online" or "Offline"
		button.statusType = status
		button.id = friendIndex

		if connected then
			if not EnhancedFriendsListDB[E.myrealm][name] then
				EnhancedFriendsListDB[E.myrealm][name] = {}
			end

			EnhancedFriendsListDB[E.myrealm][name] = {level, class, area, format("%i", time())}
		else
			local lastSeen, lastArea
			level, class, lastArea, lastSeen = self:GetLocalFriendInfo(name)
			area = lastArea or area
			button.lastSeen = lastSeen
		end

		button.levelText = level
		button.class = class
		button.area = area
		button.noteText = noteText

		self:Update_NoteIcon(button)
		self:Update_Background(button)
		self:Update_Status(button)
		self:Update_IconFrame(button)
		self:Update_Name(button)
		self:Update_Highlight(button)
	end
end

function EFL:FriendListUpdate()
	self.db = E.db.enhanceFriendsList

	if ElvCharacterDB.EnhancedFriendsList_Data then
		for i = 1, GetNumFriends() do
			local name, level, class, area, connected, status = GetFriendInfo(i)
			if ElvCharacterDB.EnhancedFriendsList_Data[name] then
				local data = ElvCharacterDB.EnhancedFriendsList_Data[name]
				if not EnhancedFriendsListDB[E.myrealm][name] then
					EnhancedFriendsListDB[E.myrealm][name] = {}
				end
				EnhancedFriendsListDB[E.myrealm][name] = {data.level, data.class, data.area, data.lastSeen}
			end
		end
		ElvCharacterDB.EnhancedFriendsList_Data = nil
	end

	for i = 1, FRIENDS_TO_DISPLAY do
		local button = _G["FriendsFrameFriendButton"..i]
		button.note = _G["FriendsFrameFriendButton"..i.."ButtonTextNote"]

		button:StripTextures()
		button.note:StripTextures()

		_G["FriendsFrameFriendButton"..i.."ButtonTextLocation"]:Hide()
		_G["FriendsFrameFriendButton"..i.."ButtonTextNoteIcon"]:Hide()
		_G["FriendsFrameFriendButton"..i.."ButtonTextNoteHiddenText"]:Hide()
		_G["FriendsFrameFriendButton"..i.."ButtonTextNoteText"]:Hide()

		self:Construct_Status(button)
		self:Construct_IconFrame(button)
		self:Construct_Background(button)
		self:Construct_Highlight(button)
		self:Construct_Tooltip(button)
		self:Construct_NoteIcon(button)

		button.name = _G["FriendsFrameFriendButton"..i.."ButtonTextName"]
		button.info = _G["FriendsFrameFriendButton"..i.."ButtonTextInfo"]
	end

	self:Update()

	self:SecureHook("FriendsList_Update")
end

function EFL:Initialize()
	EP:RegisterPlugin("ElvUI_EnhancedFriendsList", self.InsertOptions)

	if not EnhancedFriendsListDB then
		EnhancedFriendsListDB = {}
	end

	if not EnhancedFriendsListDB[E.myrealm] then
		EnhancedFriendsListDB[E.myrealm] = {}
	end

	self:FriendListUpdate()
end

local function InitializeCallback()
	EFL:Initialize()
end

E:RegisterModule(EFL:GetName(), InitializeCallback)