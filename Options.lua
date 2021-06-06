local AceOE = LibStub("AceAddon-3.0"):NewAddon("Shieldify", "AceEvent-3.0", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local Ace = LibStub("AceAddon-3.0")

local show = false
local textStore
local text

local fonts = {"FRIZQT__", "MORPHEUS_CYR", "ARKai_T", "blei00d", "K_Pagetext"}

function AceOE:OnEnable()
  local class, _, _ = UnitClass('player')
  if class == 'Shaman' then
    if _shieldifyAlert == nil then _shieldifyAlert = "APPLY SHIELD" end
    if sfy_rgba == nil then sfy_rgba = {r,g,b,a} end
    if sfy_rgba[1] == nil then sfy_rgba = {0.862,0.466,0.145,1} end
    if _colorPicker == nil then _colorPicker = "ff6d40" end
    if sfy_alertTextFont == nil then sfy_alertTextFont = "Fonts\\FRIZQT__.TTF" end

    print( '|cFFFFFF00' .. 'Type /sfy, /shieldify for options' .. '|r')
    SlashCmdList["SFY"] = sfy_op
    SLASH_SFY1 = "/sfy"
    SLASH_SFY2 = "/shieldify"
  end
end 

function sfy_op()
  -- Container frame
  local f = AceGUI:Create("Frame")
  f:SetCallback("OnClose",function(widget) AceGUI:Release(widget) end)
  f:SetTitle("Shieldify")
  f:SetLayout("custom_layout")
  f:SetWidth(500)
  f:SetHeight(200)

  -- Input BOX
  local editbox = AceGUI:Create("EditBox")
  editbox:SetParent(f)
  editbox:SetPoint("TOPLEFT")
  editbox:SetLabel("Alert:")
  editbox:SetText(_shieldifyAlert)
  editbox:SetWidth(200)
  editbox:SetParent(f)
  editbox:SetPoint("TOPLEFT", 0,-40)
  editbox:SetCallback("OnTextChanged", function(widget, event, text) _shieldifyAlert = text _displayupdate() _displayupdate(2, _Sfy_SetAlert()) end)
  f:AddChild(editbox)
   
  -- Color Picker
  local ColorPicker = AceGUI:Create("ColorPicker")
  ColorPicker:SetParent(f)
  ColorPicker:SetPoint("CENTER")
  ColorPicker:SetPoint("TOP",0,-20-40)
  ColorPicker:SetWidth(40)
  ColorPicker:SetColor(sfy_rgba[1], sfy_rgba[2], sfy_rgba[3], sfy_rgba[4]) 
  ColorPicker:SetCallback("OnValueConfirmed", function(self, _, r, g, b, a)
    sfy_rgba = {r,g,b,a}
    rgbtohex = RGBPercToHex(r,g,b)
    _colorPicker = rgbtohex
    ColorPicker:SetColor(sfy_rgba[1], sfy_rgba[2], sfy_rgba[3], sfy_rgba[4]) 
    
    if show == true then
      _displayupdate()
      _displayupdate(2, _Sfy_SetAlert())
    end
  end)
  f:AddChild(ColorPicker)

  --[[ SET Button
  local set = AceGUI:Create("Button")
  set:SetParent(f)
  set:SetText("SET")
  set:SetPoint("TOPRIGHT",-8,-20-75)
  set:SetWidth(200)
  set:SetCallback("OnClick", function() 
    
    _shieldifyAlert = textStore

    if show == true then
      _displayupdate()
      _displayupdate(2, '|CFF'.. _colorPicker .. 'SHIELDIFY: Test Alert|r')      
    end

    end)
  f:AddChild(set)
  --]]

  local test = AceGUI:Create("Button")
  test:SetParent(f)
  test:SetPoint("TOPLEFT",0,-10)
  test:SetPoint("TOPRIGHT",0,-20)
  test:SetText("TEST ALERT")
  test:SetCallback("OnClick", function() 
    if show == false then
      _displayupdate(2, '|CFF'.. _colorPicker .. _shieldifyAlert.. '|r')
      show = true
    elseif show == true then
      _displayupdate()
      show = false
    end
  end)
  f:AddChild(test)

  local dropdown = AceGUI:Create('Dropdown')
  dropdown:SetParent(f)
  dropdown:SetPoint("CENTER")
  dropdown:SetValue(fonts[1])
  dropdown:SetPoint("TOPRIGHT", -10,-20 - 38)
  dropdown:SetList(fonts)
  dropdown:SetText(sfy_alertTextFont)
  dropdown:SetCallback('OnValueChanged', function(_, _, font)
    
    if font == 1 then
      sfy_alertTextFont = "Fonts\\FRIZQT__.TTF"
      _sfy_setfont("Fonts\\FRIZQT__.TTF")
    elseif font == 2 then
      sfy_alertTextFont = "Fonts\\MORPHEUS_CYR.ttf"
      _sfy_setfont("Fonts\\MORPHEUS_CYR.ttf")
    elseif font == 3 then  
      sfy_alertTextFont = "Fonts\\ARKai_T.ttf"     
      _sfy_setfont("Fonts\\ARKai_T.ttf") 
    elseif font == 4 then      
      sfy_alertTextFont = "Fonts\\blei00d.ttf"
      _sfy_setfont("Fonts\\blei00d.ttf") 
    elseif font == 5 then   
      sfy_alertTextFont = "Fonts\\K_Pagetext.TTF"
      _sfy_setfont("Fonts\\K_Pagetext.TTF")
    end

  end)
  f:AddChild(dropdown)
end

function _Sfy_SetAlert()
	return('|CFF'.. _colorPicker .. _shieldifyAlert .. '|r')
end

function RGBPercToHex(r, g, b) -- https://wowwiki-archive.fandom.com/wiki/User_defined_functions
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

--editbox = CreateFrame("EditBox");
--editbox:SetMultiLine( true );
--editbox:SetParent(frame); -- parent frame has fixed dimensions
--[B]editbox:SetAllPoints();[/B]
--editbox:SetFontObject(ErrorFont);