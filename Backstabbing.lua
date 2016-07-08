function Load() Plus.PrintChat("\124c00FF00ff".. Plus.GetScriptName().."\124cFFFFFFff loaded" );
Event.RegisterTimerCallback( Test,30, true ); end function Test() Target = ObjectManager.GetCurrentTarget() 
if unitCasting then if Plus.IsKeyPressed( VK_2) then X,Y,Z = Target:GetLocation(); r = Target:GetRotation() Player.MoveTo( X-1*math.cos(r),Y-1*math.sin(r), Z); Player.CastSpell( "Backstab" ); end end end
function unitCasting() isCasting = Plus.DoString('spell, _, _, _, _, endTime = UnitCastingInfo("target");return spell') if isCasting ~="nil" then return true else return false end end
function Unload() Plus.PrintChat("\124c00FF00ff".. Plus.GetScriptName().."\124cFFFFFFff unloaded" ); end