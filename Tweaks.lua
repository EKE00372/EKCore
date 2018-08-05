--[[ 小功能微調 ]]--

	-- 	collectgarbage - http://bbs.nga.cn/read.php?tid=4641810
	-- 小按鈕 - https://bbs.nga.cn/read.php?pid=138374968
	-- SpeedDel: https://mods.curse.com/addons/wow/speeddel
	-- WorldMapPingHider: https://mods.curse.com/addons/wow/world-map-ping-hider
	-- EventBossAutoSelect: https://www.wowinterface.com/downloads/info20440-EventBossAutoSelect.html
	-- 字體縮小來自 HSomeFix from 上官曉霧: http://bbs.ngacn.cc/read.php?tid=10057098
	-- BabyCombatMurloc! from Nynaeve: https://www.wowinterface.com/downloads/info21135-BabyCombatMurloc.html
	-- 姓名板字型 http://www.mmo-champion.com/threads/2064978-nameplate-of-target-back-to-normal-size

	
	-- 其他
	-- [Addon/Script]party name to class name https://www.wowinterface.com/forums/showthread.php?t=49176
	-- http://www.mmo-champion.com/threads/2003404-Question-about-the-Legion-center-screen-HP-resource-bar
	-- Remove buff icons above Personal Resource Display - http://www.mmo-champion.com/threads/2089610-Remove-buff-icons-above-Personal-Resource-Display	
	-- Any way to make the new 7.0.3 Personal Resource Display unclickable? - https://www.wowinterface.com/forums/showthread.php?t=54126
	-- http://www.mmo-champion.com/threads/1647254-Auto-change-raid-Frames-on-group-size

-- [[ 全局縮放 ]] --
--[[
local AutoScale = CreateFrame("Frame", nil, UIParent)
AutoScale:RegisterEvent("PLAYER_ENTERING_WORLD")
AutoScale:SetScript("OnEvent", function(self, event)
	SetCVar("useUiScale", "1")
	SetCVar("uiScale", "1")
	local newScale = 768 / string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
	UIParent:SetScale(newScale)	-- 以uiparent取代cvar
	AutoScale:UnregisterAllEvents()
end)
]]--
-- [[ 強制載入 ]] --

local function defaultsetting()

	-- Interface
	BossBanner:UnregisterAllEvents()					-- 不顯示橫幅(擊敗首領/圖隊拾取)
	SetCVar("cameraDistanceMaxZoomFactor", 2.6)			-- 最遠視距，預設1.9
	SetActionBarToggles(1, 1, 1, 1)						-- 自動啟用快捷列(登入生效，重載無效)	
	SetSortBagsRightToLeft(true)						-- 反向整理背包
	SetInsertItemsLeftToRight(true)					-- 反向放置戰利品
	MainMenuMicroButton_SetAlertsEnabled(false)			-- 關閉所有提示(如天賦未點)
	
	-- Collection
	C_MountJournal.SetCollectedFilterSetting(2, false)	-- 座騎
	C_ToyBox.SetUncollectedShown(false)					-- 玩具
	C_PetJournal.SetFilterChecked(2)					-- 寵物
	C_Heirloom.GetUncollectedHeirloomFilter(2)			-- 傳家寶
	--C_TransmogCollection.SetShowMissingSourceInItemTooltips(true)
	
	-- Achievement frame
	AlertFrame:ClearAllPoints()
	AlertFrame:SetPoint("CENTER",UIParent,"CENTER",-400,0)	
	AlertFrame:ClearAllPoints()
	AlertFrame:SetPoint("CENTER",UIParent,"CENTER",-400,50)
	AlertFrame:SetScale(1.00)	
	GroupLootContainer:ClearAllPoints()
	GroupLootContainer:SetPoint("CENTER",UIParent,"CENTER",-200,50)
	GroupLootContainer:SetScale(1.00) 

	-- Font
	-- 任務字體(影響全局字體)
	--QuestTitleFont:SetFont(STANDARD_TEXT_FONT, 18)				-- 標題
	--QuestFont:SetFont(STANDARD_TEXT_FONT, 18)						-- 描述
	--QuestFontNormalSmall:SetFont(STANDARD_TEXT_FONT, 18)			-- 目標
	--QuestFontHighlight:SetFont(STANDARD_TEXT_FONT, 18)			-- 內容
	-- 團隊字體(影響全局字體)
	--SystemFont_Shadow_Small:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")
	--SystemFont_Shadow_Small:SetShadowColor(0, 0, 0, 0)
	--地城手冊技能說名字體放大(副作用未知)
	--GameFontBlack:SetFont(STANDARD_TEXT_FONT, 18)

	-- 訊息過濾
	--ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_JOIN", function(msg) return true end)		-- 進入頻道
	--ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LEAVE", function(msg) return true end)		-- 離開頻道
	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_NOTICE", function(msg) return true end)		-- 頻道通知
	ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", function(msg) return true end)					-- 暫離
	ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", function(msg) return true end)					-- 忙碌
end 

local DFS = CreateFrame("FRAME", "defaultsetting")
DFS:RegisterEvent("PLAYER_LOGIN")	-- or use PLAYER_ENTERING_WORLD
DFS:RegisterEvent("VARIABLES_LOADED")
local function eventHandler(self, event, ...)
	defaultsetting() 
end 
DFS:SetScript("OnEvent", eventHandler)


--[[ Addon Config Scroll Fix ]]--

local function func(self, val)
    ScrollFrameTemplate_OnMouseWheel(InterfaceOptionsFrameAddOnsList, val)
end

for i = 1, #InterfaceOptionsFrameAddOns.buttons do
    local f = _G["InterfaceOptionsFrameAddOnsButton"..i]
    f:EnableMouseWheel()
    f:SetScript("OnMouseWheel", func)
end

-- [[ Bypass the buggy cancel cinematic confirmation dialog ]] --

hooksecurefunc(CinematicFrame.closeDialog, "Show", function()
    CinematicFrame.closeDialog:Hide()
    CinematicFrame_CancelCinematic()
end)

-- [[ Stop putting spells into my bars, thank you ]] --
IconIntroTracker:UnregisterEvent("SPELL_PUSHED_TO_ACTIONBAR")

-- [[ 節日隨機自動排 ]] --

LFDParentFrame:HookScript("OnShow",function()
	for i=1, GetNumRandomDungeons() do
		local id, name = GetLFGRandomDungeonInfo(i)
		local isHoliday = select(15, GetLFGDungeonInfo(id))
		if isHoliday and not GetLFGDungeonRewards(id) then
			LFDQueueFrame_SetType(id)
		end
	end
 end)

-- [[ 聊天行數提高至512 ]] --

for i = 1, 50 do
	if _G["ChatFrame"..i] and _G["ChatFrame"..i]:GetMaxLines() ~= 512 then
		_G["ChatFrame"..i]:SetMaxLines(512)
	end
end
hooksecurefunc("FCF_OpenTemporaryWindow", function()
	local chatframe = FCF_GetCurrentChatFrame():GetName() or nil
	if chatframe then
		if (_G[cf]:GetMaxLines() ~= 512) then
			_G[cf]:SetMaxLines(512)
		end
	end
end)

-- [[ 自動輸入delete ]] --

hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"],"OnShow",function(boxEditor)
	boxEditor.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
end)

-- [[ 隱藏當每次打開大地圖時角色標記周圍的提示特效 ]] --

hooksecurefunc(WorldMapUnitPositionFrame, "StartPlayerPing", function(self, arg1, arg2)
	self:StopPlayerPing()
end)

-- [[ 讓公會和搜索列表的等級數字不會被吃掉 ]] --

local fixf=CreateFrame("frame")
fixf:RegisterEvent("VARIABLES_LOADED")
fixf:RegisterEvent("ADDON_LOADED")

-- /who的等級字體
local fontscale_who = 12
for i=1, WHOS_TO_DISPLAY do
	_G["WhoFrameButton"..i.."Level"]:SetFont(_G["WhoFrameButton"..i.."Level"]:GetFont(),fontscale_who);
end

-- 公會的等級字體
local fontscale_guild = 13
function fixf:ADDON_LOADED__GuildRoster(...)
	if ... == "Blizzard_GuildUI" then
		hooksecurefunc("GuildRosterButton_SetStringText",function(buttonString, text)
			buttonString:SetFont(buttonString:GetFont(),tonumber(text) and fontscale_guild or 15);
		end)
	end
end

fixf:SetScript("OnEvent",function(self,event,...)
	for fname,func in pairs(fixf) do
		if type(fname)=="string" and fname:find(event.."__") then
			func(self, ...)
		end
	end
end)

-- [[ 團隊確認警示音 ]] --

local ReadyCheckAlert = CreateFrame("Frame")
ReadyCheckAlert:RegisterEvent("READY_CHECK")
ReadyCheckAlert:SetScript("OnEvent", function()
	PlaySound(8960, "master")
end)

-- [[ 低血量警報 ]] --

local last = 0
local LowHP = CreateFrame("Frame")
LowHP:RegisterUnitEvent("UNIT_HEALTH", "player")
LowHP:SetScript("OnEvent", function() 
	-- 死了不算
	if UnitIsDeadOrGhost("player") then return end
	-- 報警閾值
    local lowHealth = (UnitHealth("player") / UnitHealthMax("player") < 0.3)
	-- 時間間隔
	local now = GetTime()
    if now - last < 2 then return end
	-- 警報聲
	if lowHealth then
		--PlaySound(8959, "Master") 
		PlaySoundFile("Interface\\Addons\\EKcore\\Combat\\HealthWarning.ogg", "Master")
		last = now
	elseif not lowHealth then 
		return 
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
	--限定暫離
	if not IsChatAFK() then return end
	--警報聲
	if event == "PLAYER_REGEN_DISABLED" then	--進入戰鬥
		PlaySoundFile("Sound\\Creature\\BabyMurloc\\BabyMurlocA.ogg", "Master")
	elseif event == "PLAYER_REGEN_ENABLED" then	--離開戰鬥
		StopMusic()
	end
end)

-- [[ raid和m+自動戰鬥紀錄 ]] --

local AutoLog = CreateFrame("Frame")
AutoLog:SetScript("OnEvent", function ()
	local _, instanceType = IsInInstance()
	local difficulty = select(3, GetInstanceInfo())
	if instanceType == "raid" or difficulty == 8 then
		if not LoggingCombat() then
			LoggingCombat(true)
			print("|cff00FF00"..COMBATLOGENABLED.."|r")
		end
	else
		if LoggingCombat() then
			LoggingCombat(false)
			print("|cffFF0000"..COMBATLOGDISABLED.."|r")
		end
	end
end)
AutoLog:RegisterEvent("PLAYER_ENTERING_WORLD")
