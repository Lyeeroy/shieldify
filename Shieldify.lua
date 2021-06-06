local combatF = CreateFrame("Frame")
local Aura = CreateFrame("Frame")
local class = CreateFrame("Frame")

local antispam = false

local SpellID = {
	ES = 192106,
	LS = 79949,
	WS = 204288
}

local SpellName = {
	ES = "Earth Shield",
	LS = "Lightning Shield",
	WS = "Water Shield"
}

class:RegisterEvent("ADDON_LOADED")

class:SetScript("OnEvent", function(self, event, arg1, ...) -- check if shaman class is played
	if (event == 'ADDON_LOADED') and arg1 == 'Shieldify' then
		local class, _, _ = UnitClass('player')
			if class == 'Shaman' then
				combatF:RegisterEvent("PLAYER_REGEN_DISABLED")
				combatF:RegisterEvent("PLAYER_REGEN_ENABLED")
				combatF:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
				--print("|cffff7d40Shieldify: Addon loaded|r")
			end
	end
end)

combatF:SetScript("OnEvent", function(self, event, arg1, arg2, arg3, ...)
	if (event == "PLAYER_REGEN_DISABLED") then -- COMBAT
		Aura:RegisterUnitEvent("UNIT_AURA", "player")

		if _shieldInBuffs() then
			_displayupdate()
			antispam = true
		elseif not _shieldInBuffs() then
			_displayupdate(1, _Sfy_SetAlert())
			antispam = false
		end
	end

    if (event == "PLAYER_REGEN_ENABLED") then -- EXIT COMBAT
		_displayupdate()
		Aura:UnregisterEvent("UNIT_AURA")
    end		
end)

Aura:SetScript("OnEvent", function(self, event, ...)
	if (event == "UNIT_AURA") then
		if not _shieldInBuffs() and antispam == false then
			_displayupdate(1, _Sfy_SetAlert())
			antispam = true
		elseif _shieldInBuffs() and antispam == true then
			antispam = false
			_displayupdate()
		end
	end
end)

function _shieldInBuffs()
	local buffs, i = { }, 1
	local buff = UnitBuff("player", i)
	while buff do
		buffs[#buffs + 1] = buff
		i = i + 1
		buff = UnitBuff("player", i)
	end
	
	for i=1,#buffs do
      if (buffs[i] == SpellName['LS']) or (buffs[i] == SpellName['WS']) or (buffs[i] == SpellName['ES']) then 
			_displayupdate()
        return true
      end
   end
end

