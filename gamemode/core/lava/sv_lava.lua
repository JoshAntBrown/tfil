include("sh_lava.lua")

if not Rounds then
	include("tfil/gamemode/core/rounds/sv_rounds.lua")
end

local SetGlobalFloat = SetGlobalFloat
local table = table
local Lava = Lava
local Values = Values
local hook = hook
local FrameTime = FrameTime
local player_manager = player_manager
local CurTime = CurTime
local m_UnderDescentAmount = 16 * 1.5
Rounds.NextSuperDecentTime = nil

hook.Add("Think", "LavaSync", function()
	if not Lava.StartingLevel then
		Lava.StartingLevel = Entity(0):GetModelRenderBounds().z
		Lava.CurrentLevel = Lava.StartingLevel
	end

	if Lava.CurrentLevel ~= GetGlobalFloat("$lavalev", -10000) then
		SetGlobalFloat("$lavalev", Lava.CurrentLevel)
	end
end)

hook.Add("Think", "LavaMainCycle", function()
	if GAMEMODE.Config.GetHaltMode() then return end

	if Rounds.CurrentState == "Preround" then
		hook.Call("Lava.PreroundTick")
	elseif Rounds.CurrentState == "Started" then
		if hook.Call("Lava.RoundStartedTick") then return end
		Rounds.NextSuperDecentTime = Rounds.NextSuperDecentTime or CurTime()

		if Rounds.NextSuperDecentTime < CurTime() then
			local tab = player.GetAlive()
			table.sort(tab, function(a, b) return a:GetPos().z < b:GetPos().z end)

			if tab[1] then
				local t = ((tab[1]:GetPos().z - m_UnderDescentAmount - Lava.GetLevel()) * FrameTime() / 10):max(FrameTime() * 5)
				Lava.ShiftLevel(t)

				if t <= FrameTime() * 10 then
					Rounds.NextSuperDecentTime = CurTime() + 20
					m_UnderDescentAmount = 8
				end
			end
		else
			Lava.ShiftLevel(FrameTime() * 3)
		end
	elseif Rounds.CurrentState == "Ended" then
		hook.Call("Lava.RoundEndedTick")
		Rounds.NextSuperDecentTime = nil
	end
end)

local SoundsList = {"vo/npc/male01/help01.wav", "ambient/voices/m_scream1.wav", "vo/npc/male01/myleg02.wav", "vo/npc/male01/myleg01.wav", "vo/npc/male01/ohno.wav", "vo/npc/male01/moan01.wav", "vo/npc/male01/moan03.wav", "vo/ravenholm/monk_helpme03.wav"}

hook.Add("PlayerTick", "LavaHurt", function(Player)
	if Player.m_Ragdoll and Player.m_Ragdoll:LocalToWorld( Player.m_Ragdoll:OBBMins() ).z <= Lava.CurrentLevel then
		Ragdoll.Disable(Player, nil, true)
	end

	if Player:Alive() and Rounds.CurrentState == "Started" and Player:GetPos().z <= Lava.CurrentLevel and hook.Call("Lava.ShouldTakeLavaDamage", nil, Player) ~= false then
		Player:Ignite(0.1, 0)
		Player.m_NextScreamSoundTime = Player.m_NextScreamSoundTime or CurTime()

		if Player.m_NextScreamSoundTime <= CurTime() then
			Player.m_NextScreamSoundTime = CurTime() + 1

			if hook.Call("Lava.BurningScreamSound", nil, Player, SoundsList) == nil then
				Player:EmitSound((table.Random(SoundsList)))
			end
		end
	end
end)

hook.Add("DoPlayerDeath", "CreateRagdoll", function(Player, Entity)
	Player.m_LastKiller = Entity
end)

hook.Add("PostPlayerDeath", "CreateDeathRagdoll", function(Player)
	Player:Extinguish()
	Player.m_LastShovedBy = nil

	if (IsValid(Player.m_LastKiller) and Player.m_LastKiller:GetClass() == "entityflame") or Player:GetPos().z <= Lava.GetLevel() then
		local rag = Player:GetRagdollEntity()
		if IsValid( rag ) then
			rag:SetModel("models/player/charple.mdl")
			rag:Ignite(500, 0)
		end
	end

	hook.Call("Lava.PostPlayerDeath", nil, Player)
end)