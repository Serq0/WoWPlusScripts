    function Load()
        Plus.PrintChat("\124c00FF00ff".. Plus.GetScriptName().."\124cFFFFFFff loaded" );
    	Event.RegisterTimerCallback( Offensive,20, true );
    	Event.RegisterTimerCallback( Interrupt,200, true );
    	Event.RegisterTimerCallback( GetStats, 1, true );
    	Event.RegisterSignalCallback(UNIT_SPELLCAST_SUCCEEDED, FRAMEEVENT_UNIT_SPELLCAST_SUCCEEDED)
    end
    function Interrupt()
    		unit = ObjectManager.GetCurrentTarget()
     
    			if CheckCasting()~=0 then
    				if getDistance(unit)<=5 and SpellAvailable("Mind Freeze") then CastSpellByName("Mind Freeze",unit,5) end
    				if getDistance(unit)>5 then  
    				CastSpellByName("Death Grip",unit,25) 
    				end 
    			end
    end
     
    CanCast=1
    GCD_ResetTimer = 1
    GCD_StartTime = os.clock()
    GCD_Time = 1.0
     
    function GetStats()
    	GCD_Difference = os.clock()-GCD_StartTime
    	if GCD_Difference>GCD_Time then	CanCast=1 GCD_ResetTimer = 1 else CanCast=0 end
    end
     
    function UNIT_SPELLCAST_SUCCEEDED( identifier, spellId,unitID, spell)
        --if unitID=="player" then Plus.PrintChat(unitID.." "..spell.." "..os.clock()); end
        if unitID=="player" then
    		if GCD_ResetTimer == 1 then GCD_StartTime = os.clock() GCD_ResetTimer = 0 end
    	end
    end
     
    function CastSpellByName(spellName,unit,maxDistance)
        if maxDistance==nil then maxDistance=40 end 
        if not unit then unit = ObjectManager.GetActivePlayer() end
        unitGUID = unit:GetGUID();
        unitName = unit:GetName();
         if SpellAvailable(spellName) and CanCast==1 and GCD_ResetTimer==1 then
            if not unitChanneling("player") and not unitCasting("player") and not iHaveLos(unit) and getDistance(unit)<maxDistance  then   
                Plus.DoString( 'CastSpellByName("'..spellName..'","'..unitGUID..'")' )
                Plus.PrintChat(spellName.." ".." "..unitName.." "..os.clock())
            end
    	end
    end
     
    function CheckTrinket()
    	trinketReady = Plus.DoString( "startTime, duration, enable = GetItemCooldown(61034);return duration" );
    	if trinketReady == "0" then return true else return false end
    end
     
    function CheckGloves()
    	glovesReady = Plus.DoString( "startTime, duration, enable = GetItemCooldown(60409);return duration" );
    	if glovesReady == "0" then return true else return false end
    end
     
    function CheckCasting()
    	startTime = Plus.DoString('if (UnitCastingInfo("target") or UnitChannelInfo("target")) then return 1 end' );
    	if startTime=="1" then return os.clock() else return 0 end 
    end
     
     
     
     
    function Offensive()
    	unit = ObjectManager.GetCurrentTarget()
    	player = ObjectManager.GetActivePlayer()
    	if not UnitHaveBuff("Horn of Winter",player) and not Mounted() and Plus.DoString("dead = UnitIsDeadOrGhost('player');return dead")~="1" then CastSpellByName("Horn of Winter",unit,30) end
    	if UNIT_FIELD_HEALTH(player)<50000 then Plus.DoString("RunMacro('ddd')") end
    	if unit and unit:GetName()~="Andrzej" and Plus.DoString("dead = UnitIsDeadOrGhost('target');return dead")~="1" and Plus.DoString("dead = UnitIsDeadOrGhost('player');return dead")~="1" then
    		if GetUnitMana(unit)>0 then CastSpellByName("Strangulate",unit,30) end
    		DarkSimulacrum(unit)
    		if UnitHaveBuff("Freezing Fog",player) then CastSpellByName("Howling Blast",unit,30) end
    		if UnitHaveBuff("Dark Simulacrum",player) then Plus.DoString('ActionButtonDown(5)') end
     
    		if UnitHaveBuff("Unholy Strength",player) then 
    			CastSpellByName("Pillar of Frost")
    			if CheckRuneNotReady() then EmpowerRuneWeapon() end 
    			if CheckTrinket() then Plus.DoString('RunMacroText("/use 13")') end
    			if CheckGloves() then Plus.DoString('RunMacroText("/use 10")') end 
    			if CheckBloodNotReady() then CastSpellByName("Blood Tap") end
    			Plus.DoString('RunMacroText("/use Golemblood Potion")')
    		end			
    			if getDistance(unit)>5 then
    				if not UnitHaveDebuff("Chains of Ice",unit) then CastSpellByName("Chains of Ice",unit,30) end
    				CastSpellByName("Howling Blast",unit,30)
    				if getDistance(unit)>5 and GetRunicPower()>40 then CastSpellByName("Death Coil",unit,30) end
    				DeathAndDecay()
    			end
    			if getDistance(unit)<=5 then 
    				if GetRunicPower()>32 then CastSpellByName("Frost Strike",unit,5) end
    				CastSpellByName("Obliterate",unit,5)
    			end
     
    			if SpellAvailable("Anti-Magic Shell") then Plus.DoString('if GetSpellCooldown("Anti-Magic Shell")==0  and (UnitCastingInfo("target") or UnitChannelInfo("target")) then CastSpellByName("Anti-Magic Shell") StopMacro() end') end
    end
    end
     
    function DarkSimulacrum(unit)
    	mana = GetUnitMana(unit)
    	if mana>0  then 
    		CastSpellByName("Dark Simulacrum",unit,30) 
    	end
    end	
     
    function Mounted()
        if Plus.DoString( 'return IsMounted()')=="1" then return true else return false end
    end
     
    function strBuff()
    	if UNIT_FIELD_HEALTH(unit)>30000 then 
    	if getDistance(unit)<=5 then 
    		if not UnitHaveBuff("Pillar of Frost",player) and SpellAvailable("Pillar of Frost") then
    			CastSpellByName("Pillar of Frost")
    		end
    		if CheckTrinket() then Plus.DoString('RunMacroText("/use 13")') end
    		if CheckGloves() then Plus.DoString('RunMacroText("/use 10")') end
    	end
    	end 
    end
     
    function kmProc()
    	if UnitHaveBuff("Killing Machine",player) then 
    	if CheckRuneNotReady() then EmpowerRuneWeapon() end 
    	if CheckBloodNotReady() then CastSpellByName("Blood Tap") end
    		strBuff()
    	end
    end
     
    function isEnemy()
        local Target = ObjectManager.GetCurrentTarget();
        if Target then 
        local currPlayer = ObjectManager.GetActivePlayer();
        local objectType = Target:GetType();
    	local unitReaction = currPlayer:GetReaction( Target );
        unitName = Target:GetName();
        if ( objectType == 4 or objectType == 3) and unitReaction < 3 or string.find(unitName, "Dummy")  then return true end
        end
    end
     
    function EmpowerRuneWeapon()
    	if getDistance(unit)<5 and CheckRuneNotReady() then CastSpellByName("Empower Rune Weapon") end
    end 
     
    function CheckRuneNotReady()
    	runeStatusFrost = Plus.DoString( "start, duration, runeReady = GetRuneCooldown(6);return start" );
    	runeStatusDeath = Plus.DoString( "start, duration, runeReady = GetRuneCooldown(2);return start" );
    	if runeStatusFrost~="0" and runeStatusDeath~="0" then return true else return false end
    end 
     
    function CheckFirstReady()
    	runeStatusFrost = Plus.DoString( "start, duration, runeReady = GetRuneCooldown(1);return start" );
    	if runeStatusFrost=="0" then return true else return false end
    end 
     
    function CheckFifthtReady()
    	runeStatusFrost = Plus.DoString( "start, duration, runeReady = GetRuneCooldown(5);return start" );
    	if runeStatusFrost=="0" then return true else return false end
    end 
     
    function CheckThirdReady()
    	runeStatusFrost = Plus.DoString( "start, duration, runeReady = GetRuneCooldown(3);return start" );
    	if runeStatusFrost=="0" then return true else return false end
    end 
     
    function CheckFourthReady()
    	runeStatusFrost = Plus.DoString( "start, duration, runeReady = GetRuneCooldown(3);return start" );
    	if runeStatusFrost=="0" then return true else return false end
    end 
     
     
    function CheckSixthReady()
    	runeStatusFrost = Plus.DoString( "start, duration, runeReady = GetRuneCooldown(6);return start" );
    	if runeStatusFrost=="0" then return true else return false end
    end 
     
    function CheckBloodNotReady()
    	runeStatusDeath1 = Plus.DoString( "start, duration, runeReady = GetRuneCooldown(1);return start" );
    	runeStatusDeath2 = Plus.DoString( "start, duration, runeReady = GetRuneCooldown(2);return start" );
    	if runeStatusDeath2~="0" and runeStatusDeath1~="0" then return true else return false end
    end 
     
     
    function GetRunicPower()
        runicPower = Plus.DoString('return UnitPower("player",6)')
        toInt = runicPower + 0
        return toInt
    end
     
    function GetUnitMana(unit)
    	unitGUID = unit:GetGUID();
        runicPower = Plus.DoString('return UnitPower("'..unitGUID..'",0)')
        toInt = runicPower + 0
        return toInt
    end
     
     
    function DeathAndDecay()
    	if SpellAvailable("Death and Decay") and getDistance(unit)<8 then 
    	Target = ObjectManager.GetCurrentTarget();
        X,Y,Z = Target:GetLocation()
        Plus.DoString('RunMacroText("/cast Death and Decay")')
        Player.CastCurrentSpell( X, Y, Z )
    	end
    end
     
     
     
     
     
    function Defend()
    		player = ObjectManager.GetActivePlayer()
            PLAYER_FIELD_MAXHEALTH = UNIT_FIELD_MAXHEALTH(player)
            PLAYER_FIELD_HEALTH = UNIT_FIELD_HEALTH(player)
            PLAYER_HEALTH_PERCENT = 100 * PLAYER_FIELD_HEALTH/PLAYER_FIELD_MAXHEALTH
        if PLAYER_HEALTH_PERCENT<45 then
    		if not UnitHaveBuff("Power Word: Shield",player) and not UnitHaveBuff("Weakened Soul",player) then  CastSpellByName("Power Word: Shield",player) end
    		if not UnitHaveBuff("Prayer of Mending",player) then  CastSpellByName("Prayer of Mending",player) end
            if SpellAvailable("Desperate Prayer") then Plus.DoString('RunMacroText("/stopcasting")') CastSpellByName("Desperate Prayer",player) end
        end
    end
     
    function FindLowestHealth()
        g_distanceList = {};
        g_objectList ={};
        counter = 0
        local entryCount = ObjectManager.GetObjectListEntryCount();
        local player = ObjectManager.GetActivePlayer()
        for i = 1, entryCount, 1 do
            local unit = ObjectManager.GetObjectListEntry( i )
            local objectType = unit:GetType();
            -- if FIELD_HEALTH> and distance<40 and objectType == 4 and unitReaction > 3 and HEALTH_PERCENT<90 then
            if  objectType == 4  then
                local unitReaction = player:GetReaction(unit);
                if unitReaction > 3 then
                    distance =  getDistance(unit)
                        if distance<40 then
                        if UnitHaveToDispell(unit) then CastSpellByName("Dispel Magic",unit) end
                        FIELD_MAXHEALTH = UNIT_FIELD_MAXHEALTH(unit)
                        FIELD_HEALTH = UNIT_FIELD_HEALTH(unit)
                        HEALTH_PERCENT = 100 * FIELD_HEALTH/FIELD_MAXHEALTH
                            if FIELD_HEALTH>1 and HEALTH_PERCENT<90 then 
                            g_distanceList[counter] =  HEALTH_PERCENT
                            g_objectList[counter] = unit
                            counter = counter + 1
                            end
                        end 
                end 
            end
        end
        for counter,HEALTH_PERCENT in spairs(g_distanceList, function(t,a,b) return t[b] < t[a] end) do
            selectedObjectNumber = counter
            end
            --Plus.PrintChat( selectedObjectNumber )
            return g_objectList[selectedObjectNumber]
    end
     
     
    function UnitHaveToDispell(unit)
        unitGUID = unit:GetGUID();
        if Plus.DoString('local f=0; for i=1,40 do  debuff,_,_,count,bufftype,dur = UnitDebuff("'..unitGUID..'", i)  if ((bufftype == "Magic") ) and dur > 1 then f=1  end  end if f==1 then return true end')=="true" then return true end
    end
     
    function spairs(t, order)
        -- collect the keys
        local keys = {}
        for k in pairs(t) do keys[#keys+1] = k end
     
        -- if order function given, sort by it by passing the table and keys a, b,
        -- otherwise just sort the keys 
        if order then
            table.sort(keys, function(a,b) return order(t, a, b) end)
        else
            table.sort(keys)
        end
     
        -- return the iterator function
        local i = 0
        return function()
            i = i + 1
            if keys[i] then
                return keys[i], t[keys[i]]
            end
        end
    end
     
     
    function UnitHaveBuff(spellName,unit) 
        unitGUID = unit:GetGUID();
    	if Plus.DoString('local f= 0  for i=1,40 do local name, count, unitCaster = UnitBuff("'..unitGUID..'",i)  if  name=="'..spellName..'" then f=1 end  end  if f==1 then return true end') == "true" then return true end
    end
     
    function UnitHaveMyDebuff(spellName,unit) 
        unitGUID = unit:GetGUID();
    	if Plus.DoString('local f=0; for i=1,40 do debuff={UnitDebuff("'..unitGUID..'",i)} if debuff[8]=="player" and debuff[1]=="'..spellName..'" then f=1 end end if f==1 then return true end') == "true" then return true end
    end
     
    function UnitHaveDebuff(spellName,unit) 
        unitGUID = unit:GetGUID();
    	if Plus.DoString('local f=0; for i=1,40 do debuff={UnitDebuff("'..unitGUID..'",i)} if debuff[1]=="'..spellName..'" then f=1 end end if f==1 then return true end') == "true" then return true end
    end
     
    function IsMoving()
         if resetTimer==nil then resetTimer =1 end
         if not player then player = ObjectManager.GetActivePlayer() end
         if resetTimer == 1 then
            startTime = os.clock()
            pX, pY = player:GetLocation();
            positionSum = pX+pY
            resetTimer = 0
        end
        difference = os.clock()-startTime
        if difference>0.1 then
            pX, pY, pZ = player:GetLocation();
            positionSum2 = pX+pY
            if positionSum~=positionSum2 then resetTimer=1 return true   end
        end
    end
     
     
    function iHaveLos(unit)
        local Target = unit;
        local currPlayer = ObjectManager.GetActivePlayer();
        local pX, pY, pZ = currPlayer:GetLocation();
        oX,oY,oZ = Target:GetLocation()
        local result = D3D.TraceLine(oX, oY, oZ + 2.35, pX, pY, pZ + 2.35);
        if result~=nil then return true else return false end
    end
     
    function getDistance(unit)
        local player = ObjectManager.GetActivePlayer()
        local oX,oY,oZ = unit:GetLocation()
        local pX, pY, pZ = player:GetLocation();
        local diffX = pX - oX;
        local diffY = pY - oY;
        local distance =  math.sqrt( math.pow( diffX, 2 ) + math.pow( diffY, 2 ) )
        return distance
    end
     
    function unitCasting(unitGUID)
    	isCasting = Plus.DoString('spell, _, _, _, _, endTime = UnitCastingInfo("'..unitGUID..'");return spell')
    	if isCasting ~="nil" then return true else return false end
    end
     
    function unitChanneling(unitGUID)
    	isCasting = Plus.DoString('spell, _, _, _, _, endTime = UnitChannelInfo("'..unitGUID..'");return spell')
    	if isCasting ~="nil" then return true else return false end
    end
     
    function GetSpellCooldown(spellName)
        start,duration=Plus.DoString( 'start, duration, enabled = GetSpellCooldown("'..spellName..'");return start,duration')
    	start = os.clock()
        return start,duration
    end
     
    function IsUsableSpell(spellName)
        usable=Plus.DoString( 'usable, nomana = IsUsableSpell("'..spellName..'");return usable' )
        return usable
    end
     
    function SpellAvailable(spellName)
        local spellStartTime, spellDuration = GetSpellCooldown(spellName)
        local spellUsable = IsUsableSpell(spellName)
        local spellAvailable = false
     
        if spellUsable then
            if spellStartTime ~= nil then
                local spellTimeLeft = spellStartTime + spellDuration - os.clock()
                    if spellTimeLeft <= 0.125 then spellAvailable = true end
            end
        end
        return spellAvailable
    end
     
    function UNIT_FIELD_HEALTH(unit)
        local currentTargetPointer = unit:GetPointer()
        local ObjStorage = currentTargetPointer  + 0xC
        local unitMemoryBlockStart = Memory.Read( ObjStorage, "int" )
        local value = Memory.Read( unitMemoryBlockStart+0x20+0x12*4, "int" )
        return value
    end
     
    function UNIT_FIELD_MAXHEALTH(unit)
        local currentTargetPointer = unit:GetPointer()
        local ObjStorage = currentTargetPointer  + 0xC
        local unitMemoryBlockStart = Memory.Read( ObjStorage, "int" )
        local value = Memory.Read( unitMemoryBlockStart+0x20+0x18*4, "int" )
        return value
    end
     
    function UNIT_FIELD_MAXMANA(unit)
        local currentTargetPointer = unit:GetPointer()
        local ObjStorage = currentTargetPointer  + 0xC
        local unitMemoryBlockStart = Memory.Read( ObjStorage, "int" )
        local value = Memory.Read( unitMemoryBlockStart+0x20+0x19*4, "int" )
        return value
    end
     
    function Unload()
        Plus.PrintChat("\124c00FF00ff".. Plus.GetScriptName().."\124cFFFFFFff unloaded" );
    end