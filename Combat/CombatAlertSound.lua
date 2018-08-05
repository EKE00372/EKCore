-- [[ 團隊確認警示音 ]] --

local ReadyCheckAlert = CreateFrame("Frame")
ReadyCheckAlert:RegisterEvent("READY_CHECK")
ReadyCheckAlert:SetScript("OnEvent", function()
	PlaySound("ReadyCheck", "master")
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


-- [[ 暫離狀態戰鬥警報]] --

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

