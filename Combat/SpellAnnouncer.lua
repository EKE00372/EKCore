-- [[ 法術通報 ]] --


local channel = "SAY"	-- "PARTY", "RAID"
local taunts = {
  [355] = true,    -- Warrior
--  [114198] = true, -- Warrior (Mocking Banner)
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

local SpellAnnouncer = CreateFrame("Frame")

local function OnEvent(self, event, ...)
	local _, subEvent, _, _, sourceName, _, _, _, destName, _, _, spellID, _, _, EspellID  = CombatLogGetCurrentEventInfo()
	--if select(5,...) ~= UnitName("player") then return end
	-- 排隨機不啟用
	--if IsInLFGDungeon() then return end
	-- 在伊利丹排隨機不啟用
	--if IsInLFGDungeon() and (GetLocale() == "enUS") and (GetRealmName() == "Illidan") then return end	
	if subEvent == "SPELL_INTERRUPT" then	-- 打斷
		--SendChatMessage("Interrupted " .. GetSpellLink(spellID), channel)
		local s = INTERRUPT..HEADER_COLON..sourceName..GetSpellLink(spellID).."->"..destName..GetSpellLink(EspellID)
		print(s)
	elseif subEvent == "SPELL_DISPEL" then	-- 驅散
		local s = DISPELS..HEADER_COLON..sourceName..GetSpellLink(spellID).."->"..destName..GetSpellLink(EspellID)
		print(s)
	elseif subEvent == "SPELL_STOLEN" then	-- 偷取
		local s = ACTION_SPELL_STOLEN..HEADER_COLON..sourceName..GetSpellLink(spellID).."->"..destName..GetSpellLink(EspellID)
		print(s)
	--[[elseif subEvent == "SPELL_MISSED" then	-- 反射
		local s = REFLEC..HEADER_COLON..sourceName..GetSpellLink(spellID).."->"..destName..GetSpellLink(EspellID)	-- ACTION_SPELL_MISSED_REFLECT
		print(s)]]--
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
	elseif subEvent == "SPELL_MISSED" and taunts[spellID] then
		local s = EMOTE137_CMD1:gsub("/(.*)","%1")..HEADER_COLON..sourceName..GetSpellLink(spellID).."->"..destName.."|cffFF0000 "..FAILED.."|r"
		print(s)
	else
		return
	end
end

SpellAnnouncer:SetScript("OnEvent", OnEvent)
SpellAnnouncer:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
SpellAnnouncer:RegisterEvent("ADDON_LOADED")


