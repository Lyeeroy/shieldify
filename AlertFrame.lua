local AceOE = LibStub("AceAddon-3.0"):NewAddon("Alert", "AceEvent-3.0", "AceConsole-3.0")
local Ace = LibStub("AceAddon-3.0")

sfy_SavePos = { }
sfy_TextSize = 50

local TexSize = sfy_TextSize * 7

local f1 = CreateFrame("Frame",nil,UIParent)

f1:SetWidth(1) 
f1:SetHeight(1) 
f1:SetAlpha(.70);
f1.text = f1:CreateFontString(nil,"ARTWORK") 
f1:Hide()

f1:SetMovable(false)
f1:EnableMouse(false)
f1:RegisterForDrag("LeftButton")
f1:SetScript("OnDragStart", f1.StartMoving)
f1:SetScript("OnDragStop", f1.StopMovingOrSizing)

f1.text:SetPoint("CENTER")

f1:SetParent(f)
local tex = f1:CreateTexture("ARTWORK")
tex:SetAllPoints()
tex:SetColorTexture(1.0, 0.5, 0, 0.5)
tex:Hide()


function AceOE:OnEnable()
    if sfy_SavePos[1] == nil then sfy_SavePos[1] = "CENTER" sfy_SavePos[4] = 0 sfy_SavePos[5] = 200 end
    f1:SetPoint(sfy_SavePos[1], sfy_SavePos[4], sfy_SavePos[5])
    f1:SetSize(TexSize, sfy_TextSize)
end

function _sfy_setfont(sfy_alertTextFont)
    f1.text:SetFont(sfy_alertTextFont, sfy_TextSize, "OUTLINE")
end

function _displayupdate(show, message)

    if sfy_alertTextFont == nil then
        f1.text:SetFont("Fonts\\FRIZQT__.TTF", sfy_TextSize, "OUTLINE")
    else
        f1.text:SetFont(sfy_alertTextFont, sfy_TextSize, "OUTLINE")
    end

    if show == 1 then
        f1:Show()
        UIFrameFlash(f1, 1, 1, 99, true, 0.3 , 0)
        f1.text:SetText(message)
    elseif show == 2 then
        f1:Show()
        f1.text:SetText(message)
    else
        UIFrameFlashStop(f1)
        f1:Hide()
    end
end

function sfy_movable(status)--true/false, 
    if status == 0 then
        f1:EnableMouse(false)
        f1:SetMovable(false)
        tex:Hide()

        pos1, _, _,pos4,pos5 = f1:GetPoint();
        sfy_SavePos[1]=pos1;
        sfy_SavePos[4]=pos4;
        sfy_SavePos[5]=pos5;

    elseif status == 1 then
        f1:EnableMouse(true)
        f1:SetMovable(true)
        tex:Show()
    end
end

function sfy_setsize()
    TexSize = sfy_TextSize * 7
    f1:SetSize(TexSize, sfy_TextSize)
end