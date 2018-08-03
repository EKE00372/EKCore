# EKCore

Readme License Credit大概要寫得很長了

## Addon list

> Core
* [SetUI]
    * a custom default CVar list and chat frame setting
    * /setui to load
* [BetterTalkingHead]  
  * Scale frame ,keep font size, move anchor  
  * referred [TalkingHeadFrameSettings](https://mods.curse.com/addons/wow/talkingheadframe_settings), [rTalkingHead](https://github.com/zorker/rothui/blob/master/wow7.0/rTalkingHead), [MoveTalkingHead](https://mods.curse.com/addons/wow/movetalkinghead) and [HideTalkingHead](https://mods.curse.com/addons/wow/hidetalkinghead)  
* [CharacterStats]  
  * show 2 decimal places and hidden stats  
  * referrd [NDui](https://github.com/siweia/NDui)  
* [DragEmAll](https://mods.curse.com/addons/wow/drag-em-all) by emelio  
  * referred [RayUI](https://github.com/fgprodigal/RayUI) fan update  
* [eAlign Updated](https://mods.curse.com/addons/wow/ealign-updated) by Lohkin143  
* [OmniCC](https://github.com/tullamods/OmniCC) by Tuller
  * a pure version without config and lib
  * referred from [NeavUI](https://github.com/renstrom/NeavUI)  
* [SetChat]

* [Slashcmd]
  * Credits to [MonoUI](https://www.wowinterface.com/downloads/info18071-MonoUI.html) by Monolit  
  * referred [!OverSimplified](https://www.wowinterface.com/downloads/info17401) by suicidalkatt and [this thread](https://www.wowinterface.com/forums/showthread.php?t=52673)  
* [SnowfallCursor](https://www.wowinterface.com/downloads/info15693-SnowfallCursor.html) by Dayn  
* [tullaRange](https://mods.curse.com/addons/wow/tullarange#t1:description) by Tuller  
* [Tweaks]  
  * Force Default Setting  
  * [UIScale](https://www.wowinterface.com/forums/showthread.php?t=31813) from WOWI commits, [Another thread](https://www.wowinterface.com/forums/showthread.php?t=54089)  
  * [SpeedDel](https://mods.curse.com/addons/wow/speeddel)  
  * [BabyCombatMurloc](https://www.wowinterface.com/downloads/info21135-BabyCombatMurloc.html)
  * [HSomeFix](http://bbs.ngacn.cc/read.php?tid=10057098)
  * [EventBossAutoSelect](https://www.wowinterface.com/downloads/info20440-EventBossAutoSelect.html)
  * [WorldMapPingHider](https://mods.curse.com/addons/wow/world-map-ping-hider)
  * [Fleischpflanzerl](https://github.com/Stanzilla/Fleischpflanzerl/blob/master/Modules/Slashhandler.lua)
  * [EasyLogger](https://mods.curse.com/addons/wow/easylogger)
### Combat
> not yet
### Interface
* [Binds When?](https://mods.curse.com/addons/wow/bindswhen) by Phanx, with modify  
* [BlizzardGuildUIStatus](https://www.wowinterface.com/downloads/fileinfo.php?id=18514) by Vladinator  
* [FastError](https://www.wowinterface.com/downloads/info16645) by AlleyKat, with modify  
* [FriendColor](https://www.wowinterface.com/downloads/info8679) by Awbee  
* [GuildBankList]  
* [GuildIcons](https://www.wowinterface.com/downloads/info20028) by Ailae, with modify  
* [ImprovedLootFrame](https://mods.curse.com/addons/wow/improved-loot-frame), [ImprovedOptionsFrames](https://mods.curse.com/addons/wow/improved-options-frames), [ImprovedStableFrame](https://mods.curse.com/addons/wow/improved-stable-frame) by Cybeloras  
* [MailinputboxResizer](https://www.wowinterface.com/downloads/info22663) by Tonyleila, with modify  
* [MerchantFilterButtons]  
* [ObjectiveTrackerForModemists]  
* [PokeBandage]  
* [TutorialBuster]  
### Map
### Map
* [Foglight]  
* [MapCoords]  
* [ToggleTreasures]  
* [WordMapPlayerDotResizer]  
* [WorldFlightMap]  
* [WorldMapZoom]  
### TradeSkill
* [AlreadyKnown]  
* [AuctionCancel]  
* [OneClickBuyOut]  
* [OneClickEnchantScroll]  
* [TradeTabs]  
* [TrainAll]  
### Misc
* [AchievementSS]  
* [AutoSelectLootMethod]  
* [FakeAchievement]  
* [FollowerClick]  
* [LynExperience]  
* [M_LootGroup]  
* [PostmasterGeneral](https://mods.curse.com/addons/wow/postmastergeneral) by Semlar, with modify  
* [SayGMOTD]  
* [ShiftRight](https://mods.curse.com/addons/wow/shift-right) by vbezhenar   

> [Speedy Load](https://mods.curse.com/addons/wow/speedy-load) by Cybeloras

## To do list

* 法術警報：悶棍/群復/戰復/打斷/嘲諷
  * 悶棍：被悶/被誰悶
  * 戰復：被誰復/播放音效
  * 群復：被誰復/復活人數
  * 打斷：就打斷，lfd裡不啟用
  * 嘲諷：誰嘲諷/非坦職業嘲諷
* RAID CD
  * 嘗試把打斷CD做成一體
## others
````
防暫離

/script T,F=T or 0,F or CreateFrame("frame")if X then print("關")X=nil else print("開")X=function()local t=GetTime()if t-T>1 then StaticPopup1Button1:Click()T=t end end end F:SetScript("OnUpdate",X)
````
