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
	SetActionBarToggles(true, false, true, false)		-- 自動啟用快捷列(登入生效，重載無效)	
	SetSortBagsRightToLeft(true)						-- 順向整理背包
	SetInsertItemsLeftToRight(true)						-- 反向放置戰利品
	SetAutoDeclineGuildInvites(false)					-- 不要自動拒絕公會邀請
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
	QuestTitleFont:SetFont(STANDARD_TEXT_FONT, 18)				-- 標題
	QuestTitleFont:SetShadowOffset(0, 0)
	QuestFont:SetFont(STANDARD_TEXT_FONT, 18)					-- 描述
	QuestFont:SetShadowOffset(0, 0)
	QuestFontNormalSmall:SetFont(STANDARD_TEXT_FONT, 18)		-- 目標
	QuestFontNormalSmall:SetShadowOffset(0, 0)
	QuestFontHighlight:SetFont(STANDARD_TEXT_FONT, 18)			-- 內容
	QuestFontHighlight:SetShadowOffset(0, 0)
	-- 團隊字體(影響全局字體)
	--SystemFont_Shadow_Small:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")
	--SystemFont_Shadow_Small:SetShadowColor(0, 0, 0, 0)
	--地城手冊技能說名字體放大(副作用未知)
	--GameFontBlack:SetFont(STANDARD_TEXT_FONT, 18)
end 

local DFS = CreateFrame("FRAME", "defaultsetting")
DFS:RegisterEvent("PLAYER_LOGIN")	-- or use PLAYER_ENTERING_WORLD
DFS:RegisterEvent("VARIABLES_LOADED")
local function eventHandler(self, event, ...)
	defaultsetting() 
end 
DFS:SetScript("OnEvent", eventHandler)

-- [[ 節日隨機自動排 ]] --

LFDParentFrame:HookScript("OnShow",function()
	for i = 1, GetNumRandomDungeons() do
		local id, name = GetLFGRandomDungeonInfo(i)
		local isHoliday = select(15, GetLFGDungeonInfo(id))
		if isHoliday and not GetLFGDungeonRewards(id) then
			LFDQueueFrame_SetType(id)
		end
	end
 end)

-- [[ 自動輸入delete ]] --

hooksecurefunc(StaticPopupDialogs["DELETE_GOOD_ITEM"], "OnShow", function(boxEditor)
	boxEditor.editBox:SetText(DELETE_ITEM_CONFIRM_STRING)
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
