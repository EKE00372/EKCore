-- Classic Quest Log
local function SetCQL()
	if not IsAddOnLoaded("ClassicQuestLog") then return end
	if(ClassicQuestLogSettings) then table.wipe(ClassicQuestLogSettings) end
	ClassicQuestLogSettings = {
	["ShowTooltips"] = true,
	["UndockWindow"] = false,
	["Height"] = 496,
	["SolidBackground"] = true,
	["ShowLevels"] = true,
	}
end

-- Litebag
local function SetLiteBag()
	if not IsAddOnLoaded("LiteBag") then return end
	if(LiteBag_OptionsDB) then table.wipe(LiteBag_OptionsDB) end
	LiteBag_OptionsDB = {
		["Frame:LiteBagInventoryPanel"] = {
			["columns"] = 10,
		},
		["Frame:LiteBagBankPanel"] = {
			["columns"] = 14,
		},
		["NoConfirmSort"] = true,
	}
end

-- skada
--[[
local function ForceSkadaOptions()
	if not IsAddOnLoaded("Skada") then return end
	if(SkadaDB) then table.wipe(SkadaDB) end
	SkadaDB = {
	}
end]]--

local SetAddon = CreateFrame("Frame")
SetAddon:RegisterEvent("PLAYER_LOGIN")
--SetAddon:RegisterEvent("PLAYER_ENTERING_WORLD")
SetAddon:SetScript("OnEvent", function()
	SetLiteBag()
	SetCQL()
end)
