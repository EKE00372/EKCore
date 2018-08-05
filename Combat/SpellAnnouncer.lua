-- [[ 法術通報 ]] --

-- daily question on NGA:
-- http://bbs.ngacn.cc/read.php?tid=14607924
-- http://nga.178.com/read.php?tid=14484432
-- http://bbs.ngacn.cc/read.php?tid=14628478

-- credits to:
-- aunty by Sjak 
-- https://wow.curseforge.com/projects/aunty
-- Krys Interrupt! by blizzart 
-- https://www.wowinterface.com/downloads/info21408-Krys_InterruptWoDReady.html
-- SaySapped by bitbyte
-- https://www.wowinterface.com/downloads/info9631-SaySapped.html
-- SayMassRez
-- https://www.wowinterface.com/downloads/info21078-SayMassRez.html

local channel = "SAY"	-- "PARTY", "RAID"
local taunts = {
	[355] = true,    -- Warrior
	--[114198] = true, -- Warrior (Mocking Banner)
	[2649] = true,   -- Hunter (Pet)
	[20736] = true,  -- Hunter (Distracting Shot)
	[123588] = true, -- Hunter (Distracting Shot - glyphed)
	[6795] = true,   -- Druid
	[17735] = true,  -- Warlock (Voidwalker)
	[97827] = true,  -- Warlock (Provocation (Metamorphosis))
	[49560] = true,  -- Death Knight (Death Grip (aura))
	[56222] = true,  -- Death Knight
	[73684] = true,  -- Shaman (Unleash Earth)
	[62124] = true,  -- Paladin
	[116189] = true, -- Monk (Provoke (aura))
	[118585] = true, -- Monk (Leer of the Ox)
	[118635] = true, -- Monk (Black Ox Provoke)
}

local massrez = {
	[212036] = true,
	[212040] = true,
	[212048] = true,
	[212051] = true,
	[212056] = true,
}

local SpellAnnouncer = CreateFrame("Frame")

local function OnEvent(self, event, ...)
	local _, subEvent, _, _, sourceName, _, _, _, destName, _, _, spellID, _, _, EspellID  = CombatLogGetCurrentEventInfo()
	-- 只對自己生效
	--if select(5,...) ~= UnitName("player") then return end
	-- 排隨機不啟用
	--if IsInLFGDungeon() then return end
	-- 在伊利丹排隨機不啟用
	--if IsInLFGDungeon() and (GetLocale() == "enUS") and (GetRealmName() == "Illidan") then return end	
	-- 打斷
	if subEvent == "SPELL_INTERRUPT" then
		--SendChatMessage("Interrupted " .. GetSpellLink(spellID), channel)
		local s = INTERRUPT..HEADER_COLON..sourceName..GetSpellLink(spellID).."->"..destName..GetSpellLink(EspellID)
		print(s)
	-- 驅散
	elseif subEvent == "SPELL_DISPEL" then
		local s = DISPELS..HEADER_COLON..sourceName..GetSpellLink(spellID).."->"..destName..GetSpellLink(EspellID)
		print(s)
	-- 偷取
	elseif subEvent == "SPELL_STOLEN" then
		local s = ACTION_SPELL_STOLEN..HEADER_COLON..sourceName..GetSpellLink(spellID).."->"..destName..GetSpellLink(EspellID)
		print(s)
	--[[-- 反射
	elseif subEvent == "SPELL_MISSED" then
		local s = REFLEC..HEADER_COLON..sourceName..GetSpellLink(spellID).."->"..destName..GetSpellLink(EspellID)	-- ACTION_SPELL_MISSED_REFLECT
		print(s)]]--
	-- 嘲諷
	elseif subEvent == "SPELL_AURA_APPLIED" and taunts[spellID] then
		local role = UnitGroupRolesAssigned(sourceName)
		local s = EMOTE137_CMD1:gsub("/(.*)","%1")..HEADER_COLON..sourceName..GetSpellLink(spellID).."->"..destName
		print(s)
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInRaid() and role ~= "TANK" then
			SendChatMessage(s, "INSTANCE_CHAT")
		elseif IsInGroup() and not IsInRaid() and role ~= "TANK" then
			SendChatMessage(s, "PARTY")
		elseif IsInRaid() and role ~= "TANK" then
			SendChatMessage(s, "RAID")
		end
	-- 嘲諷失敗
	elseif subEvent == "SPELL_MISSED" and taunts[spellID] then
		local s = EMOTE137_CMD1:gsub("/(.*)","%1")..HEADER_COLON..sourceName..GetSpellLink(spellID).."->"..destName.."|cffFF0000 "..FAILED.."|r"
		print(s)
	-- 群復
	elseif subEvent == "SPELL_CAST_START" and massrez[spellID] and (UnitInRaid(sourceName)  or UnitInParty(sourceName)) then
		local s = RESURRECT..HEADER_COLON..sourceName..GetSpellLink(spellID)
		print(s)
	-- 悶棍
	elseif subEvent == "SPELL_AURA_APPLIED" and spellID == 6770 and destName == UnitName("player") then
		local s = LOSS_OF_CONTROL_DISPLAY_SAP..HEADER_COLON..sourceName
		print(s)
	else
		return
	end
end

SpellAnnouncer:SetScript("OnEvent", OnEvent)
SpellAnnouncer:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
SpellAnnouncer:RegisterEvent("ADDON_LOADED")


