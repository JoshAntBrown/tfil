Config = {}

local function NewConfig( name, default, cvar, typeof )
	cvar = "lava_" .. cvar
	CreateConVar( cvar, default, {FCVAR_REPLICATED, FCVAR_ARCHIVE} )

	Config[ "Get"..name ] = function( value )
		local _ = GetConVar( cvar ):GetString()
		if typeof == "BOOL" then
			return tonumber( _ ) == 1
		elseif typeof == "NUM" then
			return tonumber(_) or 0
		end
		return _
	end
	Config[ "Set"..name ] = function( value )
		GetConVar( cvar ):SetString( value )
	end
end

function GM.GetConfig()
	return Config
end

NewConfig( "HaltMode", "0", "haltmode", "BOOL")
NewConfig( "MapEffects", "1", "fog_sky_effects", "BOOL" )
NewConfig( "RadarRange", "1200", "clientside_radar_range", "NUM" )
NewConfig( "PreroundTime", "45", "rounds_preroundtime", "NUM")
NewConfig( "RoundTime", "600", "rounds_roundtime", "NUM")
NewConfig( "PostRoundTime", "25", "rounds_postroundtime", "NUM")
NewConfig( "MapSwitchTime", "6", "rounds_mapswitchtime", "NUM")
NewConfig( "DisableDefaultMapVote", "0", "disable_default_mapvote", "BOOL")
NewConfig( "MinPlayersForStats", "0", "min_players_stats", "NUM")

GM.Config = Config