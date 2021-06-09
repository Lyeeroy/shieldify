local AceOE = LibStub("AceAddon-3.0"):NewAddon("Shieldify", "AceEvent-3.0", "AceConsole-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local Ace = LibStub("AceAddon-3.0")

local show = false
local textStore
local text
local line1 = 80

local fonts = {"FRIZQT__", "MORPHEUS_CYR", "ARKai_T", "blei00d", "K_Pagetext"}

function AceOE:OnEnable()
  local class, _, _ = UnitClass('player')
  if class == 'Shaman' then
    if _shieldifyAlert == nil then _shieldifyAlert = "APPLY SHIELD" end
    if sfy_rgba == nil then sfy_rgba = {r,g,b,a} end
    if sfy_rgba[1] == nil then sfy_rgba = {0.862,0.466,0.145,1} end
    if _colorPicker == nil then _colorPicker = "ff6d40" end
    if sfy_alertTextFont == nil then sfy_alertTextFont = "Fonts\\FRIZQT__.TTF" end

    --print( '|cFFFFFF00' .. 'Type /sfy, /shieldify for options' .. '|r')
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
  f:SetWidth(400)
  f:SetHeight(270)

  -- Input BOX
  local editbox = AceGUI:Create("EditBox")
  editbox:SetParent(f)
  editbox:SetPoint("TOPLEFT")
  editbox:SetLabel("Alert:")
  editbox:SetText(_shieldifyAlert)
  editbox:SetWidth(170)
  editbox:SetParent(f)
  editbox:SetPoint("TOPLEFT", 8, -50)
  editbox:SetCallback("OnTextChanged", function(widget, event, text) _shieldifyAlert = text
      if show == true then
        _displayupdate() _displayupdate(2, _Sfy_SetAlert())
      end
     end)

  f:AddChild(editbox)
   
  -- Color Picker
  local ColorPicker = AceGUI:Create("ColorPicker")
  ColorPicker:SetParent(f)
  ColorPicker:SetPoint("TOPLEFT", 185, -70)
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

  local def = AceGUI:Create("Button")
  def:SetParent(f)
  def:SetPoint("TOPRIGHT",-30,-50)
  def:SetText("DEFAULT")
  def:SetWidth(100)
  def:SetCallback("OnClick", function() 
    StaticPopup_Show ("DEF_YES_NO")
  end)

  f:AddChild(def)

  local dropdown = AceGUI:Create('Dropdown')
  dropdown:SetParent(f)
  dropdown:SetValue(fonts[1])
  dropdown:SetPoint("TOPLEFT", 7,-105)
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

    if show == true then
      _displayupdate()
      _displayupdate(2, _Sfy_SetAlert())
    end
  end)

  f:AddChild(dropdown)

  local CheckBox = AceGUI:Create('CheckBox')
  CheckBox:SetParent(f)
  CheckBox:SetPoint("TOPLEFT", 8, -20)
  CheckBox:SetType("checkbox")
  CheckBox:SetLabel('Lock') 
  CheckBox:SetDisabled(disabled)
  CheckBox:SetValue(1)
  CheckBox:SetCallback("OnValueChanged", function(_, _, lock)
    if lock == true then
      sfy_movable(0)
    else
      sfy_movable(1)
      sfy_setsize()
    end
  end)

  f:AddChild(CheckBox)

  local btn = AceGUI:Create("Button")
  btn:SetParent(f)
  btn:SetPoint("TOPRIGHT",-30,-20)
  btn:SetText("SHOW")
  btn:SetWidth(100)
  btn:SetCallback("OnClick", function() 
    if show == false then
      CheckBox:SetDisabled(disabled)
      _displayupdate(2, '|CFF'.. _colorPicker .. _shieldifyAlert.. '|r')
      btn:SetText("HIDE")
      show = true
    elseif show == true then
      CheckBox:SetDisabled()
      _displayupdate()
      btn:SetText("SHOW")
      show = false
    end
  end)

  f:AddChild(btn)

  local Slider = AceGUI:Create('Slider')
   Slider:SetParent(f)
   Slider:SetValue(sfy_TextSize)
   Slider:SetPoint("TOPLEFT", 8,-130)
   Slider:SetCallback("OnValueChanged", function(_, _, value)
    sfy_TextSize = value     
    if show == true then
      _displayupdate()
      _displayupdate(2, _Sfy_SetAlert())
    end
    sfy_setsize()
   end)
   Slider:SetSliderValues(10, 100, 1)

   f:AddChild(Slider)

   StaticPopupDialogs["DEF_YES_NO"] = {
    text = "Do you really want to reset all settings" .. '\n' .. 'and reload UI?',
    button1 = "Yes",
    button2 = "No",
    OnAccept = function()
      _shieldifyAlert = "APPLY SHIELD"
      sfy_rgba = {0.862,0.466,0.145,1}
      _colorPicker = "ff6d40"
      sfy_alertTextFont = "Fonts\\FRIZQT__.TTF"
      sfy_SavePos[1] = "CENTER" sfy_SavePos[4] = 0 sfy_SavePos[5] = 200
      sfy_TextSize = 50
      AceGUI:Release(f)
      ReloadUI()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
  }
end

function _Sfy_SetAlert()
	return('|CFF'.. _colorPicker .. _shieldifyAlert .. '|r')
end

function RGBPercToHex(r, g, b) -- fandom/wiki/User_defined_functions
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

