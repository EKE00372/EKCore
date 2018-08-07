-- BabyCombatMurloc! from Nynaeve: https://www.wowinterface.com/downloads/info21135-BabyCombatMurloc.html

-- [[ 團隊確認警示音 ]] --

local ReadyCheckAlert = CreateFrame("Frame")
ReadyCheckAlert:RegisterEvent("READY_CHECK")
ReadyCheckAlert:SetScript("OnEvent", function()
	PlaySound(8960, "master")	-- ReadyCheck
end)

-- [[ 低血量警報 ]] --

local last = 0
local LowHP = CreateFrame("Frame")
LowHP:RegisterUnitEvent("UNIT_HEALTH", "player")
LowHP:SetScript("OnEvent", function() 
	-- 死了不算
	if UnitIsDeadOrGhost("player") then return end
	-- 報警閾值
    local lowHealth = UnitHealth("player") / UnitHealthMax("player") < 0.3
	-- 限制時間間隔
	local now = GetTime()
    if now - last < 2 then return end
	-- 警報聲
	if lowHealth then
		--PlaySoundFile("Sound\\Interface\\RaidWarning.ogg", "Master") 
		PlaySoundFile("Interface\\Addons\\EKcore\\Media\\HealthWarning.ogg", "Master")
		last = now 
	end
end)

-- [[ 暫離狀態戰鬥警報 ]] --

local AfkAggro = CreateFrame("Frame")
AfkAggro:RegisterEvent("PLAYER_REGEN_DISABLED")
AfkAggro:RegisterEvent("PLAYER_REGEN_ENABLED")
AfkAggro:SetScript("OnEvent", function(self, event, ...)
	--副本裡不算
	local _, instanceType = IsInInstance()
	if instanceType == "raid" then return end
	if not IsChatAFK() then return end
	--警報聲
	if event == "PLAYER_REGEN_DISABLED" then	--進入戰鬥
		PlaySoundFile("Sound\\Creature\\BabyMurloc\\BabyMurlocA.ogg", "Master")
	elseif event == "PLAYER_REGEN_ENABLED" then	--離開戰鬥
		StopMusic()
	end
end)

-- [[ 戰復警示音 ]] --

local battlerez = {
	[95750]  = true,
	[20484]  = true,
	[113269] = true,
	[61999]  = true,
	[126393] = true,
}
local BattleResAlert = CreateFrame("Frame")
local function OnEvent(self, event, ...)
	local _, subEvent, _, _, sourceName, _, _, _, destName, _, _, spellID  = CombatLogGetCurrentEventInfo()
	if subEvent == "SPELL_CAST_SUCCESS" and destName == UnitName("player") and battlerez[spellID] then
		--DEFAULT_CHAT_FRAME:AddMessage("已被"..sourceName.."戰復")
		PlaySound(12889, "Master")	-- AlarmClockWarning3
	end
end
BattleResAlert:SetScript("OnEvent", OnEvent)
BattleResAlert:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")