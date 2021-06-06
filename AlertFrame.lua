local f1 = CreateFrame("Frame",nil,UIParent)

f1:SetWidth(1) 
f1:SetHeight(1) 
f1:SetAlpha(.70);
f1:SetPoint("TOP")
f1.text = f1:CreateFontString(nil,"ARTWORK") 
f1.text:SetPoint("TOP",0, -320)
f1:Hide()

function _sfy_setfont(sfy_alertTextFont)
    f1.text:SetFont(sfy_alertTextFont, 50, "OUTLINE")
end

function _displayupdate(show, message)

    if sfy_alertTextFont == nil then
        f1.text:SetFont("Fonts\\FRIZQT__.TTF", 50, "OUTLINE")
    else
        f1.text:SetFont(sfy_alertTextFont, 50, "OUTLINE")
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