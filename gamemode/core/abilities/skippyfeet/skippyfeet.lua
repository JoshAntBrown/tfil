local Timer = Timer
local Entity = Entity
local Vector = Vector
local FrameDelay = FrameDelay

hook.Add("Lava.ShouldTakeLavaDamage", "SkippyFeet", function(Player)
	if not Player:HasAbility("Skippy Feet") then return end
	Player:SetGroundEntity( Entity( 0 ) )
	FrameDelay( function()
		Player:SetPos(Player:GetPos() + Vector(0, 0, 5))
		Player:SetVelocity(Player:GetAimVector():SetZ(1) * 250)
	end)
end)

hook.Add("GetFallDamage", "AvoidFallDamage", function(Player)
	if Player:HasAbility("Skippy Feet") then return false end
end)

hook.Add("Lava.PostPlayerSpawn", "HalfenHealth", function( Player )
	if Player:HasAbility("Skippy Feet") then
		Player:SetMaxHealth( 30 )
		Player:SetHealth( 30 )
	end
end)

Abilities.Register("Skippy Feet", [[This is probably the most
	functionally useful ability.
	Ever wanted to have a quick way out in a pinch?
	Everytime you hit lava, you fly away!
	You don't take fall damage either; at the cost of 1/2 Starting HP.]], "1f9b6-1f3fd", function( Player )
		Player:SetMaxHealth( 30 )
		Player:SetHealth( 30 )
	end,
	function( Player )
		Player:SetMaxHealth( 100 )
		Player:SetHealth( 100 )
	end)