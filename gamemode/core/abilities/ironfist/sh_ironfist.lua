

hook.Add("Lava.PlayerPushPlayer", "Iron Fist", function( Attacker, Victim )
	if Attacker:HasAbility("Iron Fist") then
		Victim:SetVelocity(Attacker:GetForward():SetZ(-0.2) * 1500)
		return true
	end
end)

hook.Add("Lava.PostPlayerSpawn", "Iron Fist", function( Player )
	if Player:HasAbility("Iron Fist") then
		Player:SetRunSpeed( Player:GetRunSpeed() * 0.8 )
		Player:SetWalkSpeed( Player:GetWalkSpeed() * 0.8 )
	end
end)

Abilities.Register("Iron Fist", [[Because of vigorous use of both your hands, your punches cause players to go flying towards wherever you happen to be aiming, much stronger than the right-handed normies. Unfortunately, you move slower than everyone.]], "1f91c-1f3fc" )