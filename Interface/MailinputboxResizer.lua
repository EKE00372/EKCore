-----------------------------------------------------------------------------------------
--Config

	--EditBox width				--default: 224
	local editbox_width = 220
	
	--Money display position	--default: {"RIGHT","SendMailFrame","RIGHT",-74,-94,}
	local moneyframe_pos = {"BOTTOM", "SendMailSendMoneyButtonText", "TOPRIGHT", 0, 0,}

--Condig END
-----------------------------------------------------------------------------------------


local c = SendMailCostMoneyFrame
c:ClearAllPoints()
c:SetPoint(unpack(moneyframe_pos))

local f = "SendMailNameEditBox" 
_G[f]:SetSize(editbox_width or 224,20)

local r=_G[f.."Right"]
r:ClearAllPoints()
r:SetPoint("TOPRIGHT",0,0)

local m=_G[f.."Middle"]
m:SetSize(0,20)
m:ClearAllPoints()
m:SetPoint("LEFT",f.."Left","LEFT",8,0)
m:SetPoint("RIGHT",r,"RIGHT",-8,0)