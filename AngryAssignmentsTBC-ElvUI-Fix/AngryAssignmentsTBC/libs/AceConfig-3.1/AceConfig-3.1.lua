--[[ $Id: AceConfig-3.1.lua 494 2008-02-03 13:03:56Z nevcairiel $ ]]
--[[
AceConfig-3.1

Very light wrapper library that combines all the AceConfig subcomponents into one more easily used whole.

Also automatically adds "config", "enable" and "disable" commands to options table as appropriate.

]]

local MAJOR, MINOR = "AceConfig-3.1", 2
local lib = LibStub:NewLibrary(MAJOR, MINOR)

if not lib then return end


local cfgreg = LibStub("AceConfigRegistry-3.1")
local cfgcmd = LibStub("AceConfigCmd-3.1")
local cfgdlg = LibStub("AceConfigDialog-3.1")
--TODO: local cfgdrp = LibStub("AceConfigDropdown-3.1")


---------------------------------------------------------------------
-- :RegisterOptionsTable(appName, options, slashcmd, persist)
--
-- - appName - (string) application name
-- - options - table or function ref, see AceConfigRegistry
-- - slashcmd - slash command (string) or table with commands, or nil to NOT create a slash command

function lib:RegisterOptionsTable(appName, options, slashcmd)
	local ok,msg = pcall(cfgreg.RegisterOptionsTable, self, appName, options)
	if not ok then error(msg, 2) end
	
	if slashcmd then
		if type(slashcmd) == "table" then
			for _,cmd in pairs(slashcmd) do
				cfgcmd:CreateChatCommand(cmd, appName)
			end
		else
			cfgcmd:CreateChatCommand(slashcmd, appName)
		end
	end
end
