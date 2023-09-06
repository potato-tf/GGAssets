//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// LOCALS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////// DEBUGGING ///////////////////////////////////

local debug = false
local debug_teles = false

/////////////////////////////////// DEBUGGING ///////////////////////////////////
/////////////////////////////////// GLOBAL ENTITIES ///////////////////////////////////

local gamerules_entity;
gamerules_entity = Entities.FindByName(gamerules_entity, "gamerules")

local objective_resource_entity;
objective_resource_entity = Entities.FindByClassname(objective_resource_entity, "tf_objective_resource")

local wave_start_relay_entity;
wave_start_relay_entity = Entities.FindByName(wave_start_relay_entity, "wave_start_relay")

local intel_entity;
intel_entity = Entities.FindByName(intel_entity, "intel")

local bomb_dir_left1_entity
bomb_dir_left1_entity = Entities.FindByName(bomb_dir_left1_entity, "bombpath_left_left")

local bomb_dir_left2_entity
bomb_dir_left2_entity = Entities.FindByName(bomb_dir_left2_entity, "bombpath_left_middle")

local bomb_dir_left3_entity
bomb_dir_left3_entity = Entities.FindByName(bomb_dir_left3_entity, "bombpath_left_right")

local bomb_dir_right1_entity
bomb_dir_right1_entity = Entities.FindByName(bomb_dir_right1_entity, "bombpath_right_left")

/////////////////////////////////// GLOBAL ENTITIES ///////////////////////////////////
/////////////////////////////////// CALLBACKS ///////////////////////////////////

self.ValidateScriptScope()

::CALLBACKS <- {}

ClearGameEventCallbacks()
	
for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++) // run this for when first player connects to the server and the callback hasn't loaded yet
{
	local player = PlayerInstanceFromIndex(i)
	if (player == null) continue
	if (IsPlayerABot(player)) continue
	
	player.ValidateScriptScope()
	local scope = player.GetScriptScope()
	
	if (!("saw_mission_info" in scope)) 
	{
		scope.saw_mission_info <- true
		ClientPrint(player, 4, "For the duration of this mission, certain robots will be spawning from several different locations marked on this map.")
		ClientPrint(player, 3, "\x07FFD700For the duration of this mission, certain robots will be spawning from several different locations marked on this map.")
	}
}

::CALLBACKS.OnGameEvent_post_inventory_application <- function(params)
{
	local spawned_player = GetPlayerFromUserID(params.userid);
	
	if (spawned_player.IsFakeClient()) return
	
	spawned_player.ValidateScriptScope()
	local scope = spawned_player.GetScriptScope()
	
	if (!("saw_mission_info" in scope)) 
	{
		scope.saw_mission_info <- true
		ClientPrint(spawned_player, 4, "For the duration of this mission, certain robots will be spawning from several different locations marked on this map.")
		ClientPrint(spawned_player, 3, "\x07FFD700For the duration of this mission, certain robots will be spawning from several different locations marked on this map.")
	}
}

/////////////////////////////////// CALLBACKS ///////////////////////////////////
/////////////////////////////////// TELEPORTERS ///////////////////////////////////

for (local ent; ent = Entities.FindByName(ent, "tele_*"); ) ent.Kill()

::tele_func_threshold <- null

local teledestination_table =
{
	"1": Vector(-630, -430, 285) // back (1)
	"2": Vector(-1150, -1120, 285) // back (2)
	"3": Vector(-1850, -700, 285) // back (3)
	"4": Vector(450, -450, 235) // back (4)
	"5": Vector(-1500, 1600, 210) // forward 1 (1)
	"6": Vector(-450, 1500, 70) // forward 1 (2)
	"7": Vector(450, 600, 110) // forward 2 (1)
	"8": Vector(-1950, -100, 285) // forward 2 (2)
	
	"9": Vector(-800, -2050, 235) // special 1 (w3d)
}

local prop_vector = Vector(0, 0, 30)

::tele_spot_b1 <- SpawnEntityFromTable("prop_dynamic",
{
	targetname    = "tele_spot_b1"
	origin        = teledestination_table["1"] - prop_vector
	angles        = QAngle(0, 90, 0)
	model         = "models/props_mvm/robot_spawnpoint.mdl"
	DefaultAnim   = "idle"
})

::tele_spot_b2 <- SpawnEntityFromTable("prop_dynamic",
{
	targetname    = "tele_spot_b2"
	origin        = teledestination_table["2"] - prop_vector
	angles        = QAngle(0, 90, 0)
	model         = "models/props_mvm/robot_spawnpoint.mdl"
	DefaultAnim   = "idle"
})

::tele_spot_b3 <- SpawnEntityFromTable("prop_dynamic",
{
	targetname    = "tele_spot_b3"
	origin        = teledestination_table["3"] - prop_vector
	angles        = QAngle(0, 90, 0)
	model         = "models/props_mvm/robot_spawnpoint.mdl"
	DefaultAnim   = "idle"
})

::tele_spot_b4 <- SpawnEntityFromTable("prop_dynamic",
{
	targetname    = "tele_spot_b4"
	origin        = teledestination_table["4"] - prop_vector
	angles        = QAngle(0, 90, 0)
	model         = "models/props_mvm/robot_spawnpoint.mdl"
	DefaultAnim   = "idle"
})

::tele_spot_f1 <- SpawnEntityFromTable("prop_dynamic",
{
	targetname    = "tele_spot_f1"
	origin        = teledestination_table["5"] - prop_vector
	angles        = QAngle(0, 90, 0)
	model         = "models/props_mvm/robot_spawnpoint.mdl"
	DefaultAnim   = "idle"
})

::tele_spot_f2 <- SpawnEntityFromTable("prop_dynamic",
{
	targetname    = "tele_spot_f2"
	origin        = teledestination_table["6"] - prop_vector
	angles        = QAngle(0, 90, 0)
	model         = "models/props_mvm/robot_spawnpoint.mdl"
	DefaultAnim   = "idle"
})

::tele_spot_f3 <- SpawnEntityFromTable("prop_dynamic",
{
	targetname    = "tele_spot_f3"
	origin        = teledestination_table["7"] - prop_vector
	angles        = QAngle(0, 90, 0)
	model         = "models/props_mvm/robot_spawnpoint.mdl"
	DefaultAnim   = "idle"
})

::tele_spot_f4 <- SpawnEntityFromTable("prop_dynamic",
{
	targetname    = "tele_spot_f4"
	origin        = teledestination_table["8"] - prop_vector
	angles        = QAngle(0, 90, 0)
	model         = "models/props_mvm/robot_spawnpoint.mdl"
	DefaultAnim   = "idle"
})

::tele_spot_b1_skyparticle <- SpawnEntityFromTable("info_particle_system",
{
	targetname    	   = "tele_b_skyparticle"
	origin             = teledestination_table["1"] - prop_vector
	angles             = QAngle(0, 90, 0)
	start_active       = 0,
	effect_name        = "teleporter_mvm_bot_persist"
})

::tele_spot_b2_skyparticle <- SpawnEntityFromTable("info_particle_system",
{
	targetname    	   = "tele_b_skyparticle"
	origin             = teledestination_table["2"] - prop_vector
	angles             = QAngle(0, 90, 0)
	start_active       = 0,
	effect_name        = "teleporter_mvm_bot_persist"
})

::tele_spot_b3_skyparticle <- SpawnEntityFromTable("info_particle_system",
{
	targetname    	   = "tele_b_skyparticle"
	origin             = teledestination_table["3"] - prop_vector
	angles             = QAngle(0, 90, 0)
	start_active       = 0,
	effect_name        = "teleporter_mvm_bot_persist"
})

::tele_spot_b4_skyparticle <- SpawnEntityFromTable("info_particle_system",
{
	targetname    	   = "tele_b_skyparticle"
	origin             = teledestination_table["4"] - prop_vector
	angles             = QAngle(0, 90, 0)
	start_active       = 0,
	effect_name        = "teleporter_mvm_bot_persist"
})

::tele_spot_f1_skyparticle <- SpawnEntityFromTable("info_particle_system",
{
	targetname    	   = "tele_f_skyparticle"
	origin             = teledestination_table["5"] - prop_vector
	angles             = QAngle(0, 90, 0)
	start_active       = 0,
	effect_name        = "teleporter_mvm_bot_persist"
})

::tele_spot_f2_skyparticle <- SpawnEntityFromTable("info_particle_system",
{
	targetname    	   = "tele_f_skyparticle"
	origin             = teledestination_table["6"] - prop_vector
	angles             = QAngle(0, 90, 0)
	start_active       = 0,
	effect_name        = "teleporter_mvm_bot_persist"
})

::tele_spot_f3_skyparticle <- SpawnEntityFromTable("info_particle_system",
{
	targetname    	   = "tele_f_skyparticle"
	origin             = teledestination_table["7"] - prop_vector
	angles             = QAngle(0, 90, 0)
	start_active       = 0,
	effect_name        = "teleporter_mvm_bot_persist"
})

::tele_spot_f4_skyparticle <- SpawnEntityFromTable("info_particle_system",
{
	targetname    	   = "tele_f_skyparticle"
	origin             = teledestination_table["8"] - prop_vector
	angles             = QAngle(0, 90, 0)
	start_active       = 0,
	effect_name        = "teleporter_mvm_bot_persist"
})

::teleport_status <- "inbetween_waves"

::current_squad_leader <- null
::bomb_placement_adjusted <- false

/////////////////////////////////// TELEPORTERS ///////////////////////////////////

::boss_entity <- null

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// LOCALS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// AUTOEXECUTE ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////// EVERY WAVE ///////////////////////////////////

NetProps.SetPropString(gamerules_entity, "m_iszScriptThinkFunction", "");

EntityOutputs.RemoveOutput(bomb_dir_left1_entity, "OnTrigger", "gamerules", "RunScriptCode", "tele_func_threshold = 100.0")
EntityOutputs.RemoveOutput(bomb_dir_left2_entity, "OnTrigger", "gamerules", "RunScriptCode", "tele_func_threshold = 100.0")
EntityOutputs.RemoveOutput(bomb_dir_left3_entity, "OnTrigger", "gamerules", "RunScriptCode", "tele_func_threshold = 100.0")
EntityOutputs.RemoveOutput(bomb_dir_right1_entity, "OnTrigger", "gamerules", "RunScriptCode", "tele_func_threshold = -300.0")

EntityOutputs.RemoveOutput(wave_start_relay_entity, "OnTrigger", "gamerules", "RunScriptCode", "teleport_status = `inactive`")

EntityOutputs.AddOutput(bomb_dir_left1_entity, "OnTrigger", "gamerules", "RunScriptCode", "tele_func_threshold = 100.0", 0.0, -1)
EntityOutputs.AddOutput(bomb_dir_left2_entity, "OnTrigger", "gamerules", "RunScriptCode", "tele_func_threshold = 100.0", 0.0, -1)
EntityOutputs.AddOutput(bomb_dir_left3_entity, "OnTrigger", "gamerules", "RunScriptCode", "tele_func_threshold = 100.0", 0.0, -1)
EntityOutputs.AddOutput(bomb_dir_right1_entity, "OnTrigger", "gamerules", "RunScriptCode", "tele_func_threshold = -300.0", 0.0, -1)

EntityOutputs.AddOutput(wave_start_relay_entity, "OnTrigger", "gamerules", "RunScriptCode", "teleport_status = `inactive`", 0.0, -1)

for (local think_to_clear; think_to_clear = Entities.FindByName(think_to_clear, "defenderspushedcheck"); )
{
	think_to_clear.Kill()
}

local think_havedefendersbeenpushed = SpawnEntityFromTable("logic_relay", {targetname = "defenderspushedcheck"})
AddThinkToEnt(think_havedefendersbeenpushed, "HaveDefendersBeenPushed_Think")

for (local think_to_clear; think_to_clear = Entities.FindByName(think_to_clear, "bombcarrierspawnspeedup"); )
{
	think_to_clear.Kill()
}

local think_bombcarrierspawnspeedup = SpawnEntityFromTable("logic_relay", {targetname = "bombcarrierspawnspeedup"})
AddThinkToEnt(think_bombcarrierspawnspeedup, "BombCarrierSpawnSpeedUp_Think")

if (Entities.FindByName(null, "nav_avoid_giant") == null)
{
	local nav_avoid_giant = SpawnEntityFromTable("func_nav_avoid",
	{
		targetname       = "nav_avoid_giant"
		origin           = Vector(-700, -350, 0)
		tags             = "bot_giant"
	})

	nav_avoid_giant.KeyValueFromInt("solid", 2)
	nav_avoid_giant.KeyValueFromString("mins", "-300 -300 -1000")
	nav_avoid_giant.KeyValueFromString("maxs", "300 300 1000")

	local nav_avoid_telebot = SpawnEntityFromTable("func_nav_avoid",
	{
		targetname       = "nav_avoid_telebot"
		origin           = Vector(-500, -1500, 0)
		tags             = "bot_telebot"
	})

	nav_avoid_telebot.KeyValueFromInt("solid", 2)
	nav_avoid_telebot.KeyValueFromString("mins", "-2000 -1500 -1000")
	nav_avoid_telebot.KeyValueFromString("maxs", "2000 400 1000")
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// AUTOEXECUTE ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////// TELEPORTERS ///////////////////////////////////

::Teles_StatusChange <- function(action)
{
	if (action == "begin")
	{
		EntFireByHandle(gamerules_entity, "PlayVO", "mvm/mvm_tele_activate.wav", 0.0, null, null)
		
		for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
		{
			local player = PlayerInstanceFromIndex(i)
			if (player == null) continue
			if (IsPlayerABot(player)) continue
			
			player.ValidateScriptScope()
			local scope = player.GetScriptScope()
			
			if (!("saw_teleport_overlay" in scope)) 
			{
				scope.saw_teleport_overlay <- true
				EntFireByHandle(player, "SetScriptOverlayMaterial", "teleport_warning_overlay", 0.0, null, null);
				EntFireByHandle(player, "SetScriptOverlayMaterial", "", 8.0, null, null);
			}
		}
		
		teleport_status = "active"
	}
	
	if (action == "end")
	{	
		EntFire("tele_b_skyparticle", "Stop")
		EntFire("tele_f_skyparticle", "Stop")
		
		EntFireByHandle(gamerules_entity, "PlayVO", "weapons/teleporter_explode.wav", 0.0, null, null)
		
		teleport_status = "inactive"
	}
}

::TeleportRobot <- function(type = null, manual = false, destination = null, teletext = "   A giant robot\nhas teleported in!")
{	
	if (type != "squad_member" || !manual)
	{
		if (intel_entity.GetOrigin().y >= tele_func_threshold) self.Teleport(true, teledestination_table[RandomInt(1, 4).tostring()], false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		if (intel_entity.GetOrigin().y < tele_func_threshold)  self.Teleport(true, teledestination_table[RandomInt(5, 8).tostring()], false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
	}
	
	if (manual) self.Teleport(true, destination, false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
	
	if (type == "squad_leader")
	{
		current_squad_leader = self
		EntFireByHandle(gamerules_entity, "RunScriptCode", "current_squad_leader = null", 0.5, null, null)
	}
	
	if (type == "squad_member") self.Teleport(true, current_squad_leader.GetOrigin(), false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
	
	if (type == "boss_helper") self.Teleport(true, boss_entity.GetOrigin() + Vector(0, 0, 50), false, QAngle(0, 0, 0), true, Vector(RandomInt(-500, 500), RandomInt(-500, 500), 600))
	
	if (!(self.HasBotAttribute(32768)))
	{
		self.AddCustomAttribute("force distribute currency on death", 1, -1)
		for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
		{
			local player_to_alert = PlayerInstanceFromIndex(i)
			if (player_to_alert == null) continue
			if (IsPlayerABot(player_to_alert)) continue
			EmitSoundOn("GG.BotTeleported", player_to_alert)
		}
	} 
	if (self.HasBotAttribute(32768))
	{
		NetProps.SetPropBool(self, "m_bGlowEnabled", true)
		EntFireByHandle(gamerules_entity, "PlayVO", "mvm/giant_heavy/giant_heavy_entrance.wav", 0.0, null, null)
		
		SendGlobalGameEvent("show_annotation", 
		{
			text = teletext
			worldPosX = self.GetOrigin().x
			worldPosY = self.GetOrigin().y
			worldPosZ = self.GetOrigin().z
			play_sound = "misc/null.wav"
			show_distance = false
			show_effect = true
			lifetime = 5
		})
	}
	
	if (type != "boss_helper")
	{
		for (local entity_to_telefrag; entity_to_telefrag = Entities.FindInSphere(entity_to_telefrag, self.GetOrigin(), 100); )
		{
			if (entity_to_telefrag.GetTeam() == 2)
			{
				entity_to_telefrag.TakeDamage(1000.0, 64, self)
			}
		}
	}
}

/////////////////////////////////// TELEPORTERS ///////////////////////////////////
/////////////////////////////////// MISCELLANEOUS ///////////////////////////////////

::HaveDefendersBeenPushed_Think <- function()
{
	// if (intel_entity.GetOrigin().y > tele_func_threshold) ClientPrint(null,3,"not_pushed")
	// if (intel_entity.GetOrigin().y < tele_func_threshold) ClientPrint(null,3,"pushed")
	
	if (teleport_status == "inbetween_waves")
	{
		for (local telespot; telespot = Entities.FindByName(telespot, "tele_spot_*"); )
		{
			NetProps.SetPropInt(telespot, "m_nSkin", 1)
			NetProps.SetPropFloat(telespot, "m_flPlaybackRate", 0.0)
			telespot.KeyValueFromInt("rendermode", 1)
			EntFireByHandle(telespot, "$SetKey$renderamt", "" + 90, 0.0, null, null)
		}
	}
	
	if (teleport_status != "inbetween_waves") for (local telespot; telespot = Entities.FindByName(telespot, "tele_spot_*"); ) telespot.KeyValueFromInt("rendermode", 0)
	
	if (teleport_status == "inactive")
	{
		for (local telespot; telespot = Entities.FindByName(telespot, "tele_spot_*"); )
		{
			NetProps.SetPropInt(telespot, "m_nSkin", 2)
			NetProps.SetPropFloat(telespot, "m_flPlaybackRate", 0.0)
		}
	}
	
	if (teleport_status == "active")
	{
		if (intel_entity.GetOrigin().y > tele_func_threshold)
		{	
			EntFire("tele_b_skyparticle", "Start")
			EntFire("tele_f_skyparticle", "Stop")
			
			EntFire("nav_avoid_telebot", "Enable")
			
			for (local telespot; telespot = Entities.FindByName(telespot, "tele_spot_b*"); )
			{
				NetProps.SetPropInt(telespot, "m_nSkin", 1)
				NetProps.SetPropFloat(telespot, "m_flPlaybackRate", 1.0)
			}
			for (local telespot; telespot = Entities.FindByName(telespot, "tele_spot_f*"); )
			{
				NetProps.SetPropInt(telespot, "m_nSkin", 2)
				NetProps.SetPropFloat(telespot, "m_flPlaybackRate", 0.0)
			}

			// ClientPrint(null,3,"not pushed");
		}
		
		if (intel_entity.GetOrigin().y < tele_func_threshold)
		{	
			EntFire("tele_b_skyparticle", "Stop")
			EntFire("tele_f_skyparticle", "Start")
			
			EntFire("nav_avoid_telebot", "Disable")
			
			for (local telespot; telespot = Entities.FindByName(telespot, "tele_spot_b*"); )
			{
				NetProps.SetPropInt(telespot, "m_nSkin", 2)
				NetProps.SetPropFloat(telespot, "m_flPlaybackRate", 0.0)
			}
			for (local telespot; telespot = Entities.FindByName(telespot, "tele_spot_f*"); )
			{
				NetProps.SetPropInt(telespot, "m_nSkin", 1)
				NetProps.SetPropFloat(telespot, "m_flPlaybackRate", 1.0)
			}
			
			// ClientPrint(null,3,"pushed");
		}
	}
	
	return
}

::BombCarrierSpawnSpeedUp_Think <- function()
{
	for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
	{
		local player = PlayerInstanceFromIndex(i)
		if (player == null) continue
		if (player.GetTeam() != 3) continue
		if (player.HasItem())
		{
			if (player.InCond(130) && !player.HasBotAttribute(32768)) player.AddCustomAttribute("CARD: move speed bonus", 10, -1)
			else player.RemoveCustomAttribute("CARD: move speed bonus")
			
			if (!bomb_placement_adjusted)
			{
				if (tele_func_threshold == -300.0) player.Teleport(true, Vector(-1056, 3312, 96), false, QAngle(0, 0, 0), false, Vector(0, 0, 0)) // bots will disobey bomb path if they don't spawn from spawnbot_right
				
				bomb_placement_adjusted = true
			}
		}
	}
	
	return
}

// ::SetUpAoEUber <- function()
// {	
	// local uber_beam_1 = SpawnEntityFromTable("dispenser_touch_trigger",
	// {
		// targetname    	   = "dispenser_trigger" + aoe_medic_counter
		// origin             = self.GetOrigin()
		// spawnflags         = 1
	// })
	
	// local uber_beam_2 = SpawnEntityFromTable("mapobj_cart_dispenser",
	// {
		// targetname    	   = "dispenser_mapobj" + aoe_medic_counter
		// origin             = self.GetOrigin()
		// TeamNum            = 3,
		// spawnflags         = 12
		// touch_trigger      = "dispenser_trigger" + aoe_medic_counter
	// })
	
	// uber_beam_2.KeyValueFromInt("solid", 2)
	// uber_beam_2.KeyValueFromString("mins", "-250 -250 -250")
	// uber_beam_2.KeyValueFromString("maxs", "250 250 250")
	
	// EntFire("dispenser_mapobj" + aoe_medic_counter, "SetParent", self)
	// EntFire("dispenser_trigger" + aoe_medic_counter, "SetParent", self)
	
	// AddThinkToEnt(self, "AoEUber_Think")
	
	// aoe_medic_counter = aoe_medic_counter + 1
// }

::AoEUber_Think <- function()
{	
	for (local player_to_shield; player_to_shield = Entities.FindByClassnameWithin(player_to_shield, "player", self.GetOrigin(), 250); )
	{
		if (player_to_shield == null) continue
		if (player_to_shield.GetTeam() == 3 && NetProps.GetPropString(player_to_shield, "m_szNetname").find("Medic") == null) player_to_shield.AddCondEx(52, 0.5, self)
		
		if (NetProps.GetPropInt(self, "m_lifeState") != 0) NetProps.SetPropString(self, "m_iszScriptThinkFunction", "");
	}
	
	return
}

// ::BossState_Think <- function()
// {	
	// if (self.GetHealth() < 35000 && !boss_stage_threshold_reached)
	// {
		// boss_stage_threshold_reached = true
		// self.AddCondEx(71, 5.0, self)
		// self.AddCustomAttribute("dmg taken increased", 0.1, -1)
		
		// for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
		// {
			// local player = PlayerInstanceFromIndex(i)
			// if (player == null) continue;
			// if (IsPlayerABot(player)) continue;
			
			// EntFireByHandle(gamerules_entity, "RunScriptCode", "EmitAmbientSoundOn(`misc/rd_finale_beep01.wav`, 100.0, 0, 100, player)", 0.0, null, null)
			// EntFireByHandle(gamerules_entity, "RunScriptCode", "EmitAmbientSoundOn(`misc/rd_finale_beep01.wav`, 100.0, 0, 125, player)", 1.0, null, null)
			// EntFireByHandle(gamerules_entity, "RunScriptCode", "EmitAmbientSoundOn(`misc/rd_finale_beep01.wav`, 100.0, 0, 150, player)", 2.0, null, null)
			// EntFireByHandle(gamerules_entity, "RunScriptCode", "EmitAmbientSoundOn(`misc/rd_finale_beep01.wav`, 100.0, 0, 175, player)", 3.0, null, null)
			// EntFireByHandle(gamerules_entity, "RunScriptCode", "EmitAmbientSoundOn(`misc/rd_finale_beep01.wav`, 100.0, 0, 200, player)", 4.0, null, null)
			// EntFireByHandle(gamerules_entity, "RunScriptCode", "EmitAmbientSoundOn(`misc/rd_finale_beep01.wav`, 100.0, 0, 225, player)", 5.0, null, null)
		// }
		
        // local phase_change_explosion = SpawnEntityFromTable("tf_point_weapon_mimic",
		// {
			// targetname              = "phase_change_explosion"
			// origin                  = self.GetOrigin()
			// angles                  = QAngle(90, 0, 0)
			// TeamNum                 = 3
			// "$preventshootparent"   = 1
			// "$weaponname"           : "TF_WEAPON_ROCKETLAUNCHER"
		// })
		
		// phase_change_explosion.SetOwner(self)
		
		// EntFire("phase_change_explosion", "$AddWeaponAttribute", "explosion particle|fluidSmokeExpl_ring_mvm")
		// EntFire("phase_change_explosion", "$AddWeaponAttribute", "damage causes airblast|1")
		// EntFire("phase_change_explosion", "$AddWeaponAttribute", "Blast radius increased|4")
		// EntFire("phase_change_explosion", "$AddWeaponAttribute", "self dmg push force decreased|0")
		// EntFire("phase_change_explosion", "$AddWeaponAttribute", "no self blast dmg|2")
		
		// EntFire("phase_change_explosion", "$FireMultiple", 3, 5.0)
		
		// EntFireByHandle(gamerules_entity, "RunScriptCode", "after_boss_phase_transition = true", 7.5, null, null)
	// }
	// if (after_boss_phase_transition)
	// {
        // local phase_change_explosion = SpawnEntityFromTable("tf_point_weapon_mimic",
		// {
			// targetname              = "phase_change_explosion"
			// origin                  = self.GetOrigin()
			// angles                  = QAngle(90, 0, 0)
			// TeamNum                 = 3
			// "$preventshootparent"   = 1
			// "$weaponname"           : "TF_WEAPON_ROCKETLAUNCHER"
		// })
		
		// phase_change_explosion.SetOwner(self)
		
		// EntFire("phase_change_explosion", "$AddWeaponAttribute", "explosion particle|fluidSmokeExpl_ring_mvm")
		// EntFire("phase_change_explosion", "$AddWeaponAttribute", "damage causes airblast|1")
		// EntFire("phase_change_explosion", "$AddWeaponAttribute", "Blast radius increased|4")
		// EntFire("phase_change_explosion", "$AddWeaponAttribute", "self dmg push force decreased|0")
		// EntFire("phase_change_explosion", "$AddWeaponAttribute", "no self blast dmg|2")
		
		// EntFire("phase_change_explosion", "$FireMultiple", 3, 5.0)
		
		// EntFireByHandle(gamerules_entity, "RunScriptCode", "after_boss_phase_transition = true", 7.5, null, null)
	// }
	
	// return
// }

::AcknowledgeBoss <- function()
{	
	for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
	{
		local player = PlayerInstanceFromIndex(i)
		if (player == null) continue
		if (NetProps.GetPropString(player, "m_szNetname") == "Fire Fist") boss_entity = player
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// DEBUGGING ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if (debug)
{
	function OnGameEvent_player_say(params)
	{
		local player = GetPlayerFromUserID(params.userid)

		if (params.text == "1")
		{
			DispatchParticleEffect("teleporter_mvm_bot_persist", player.GetOrigin() + Vector(-300, 0, 0), Vector(0, 90, 0))
		}
		if (params.text == "2")
		{
			for (local clear_particle; clear_particle = Entities.FindByClassname(clear_particle, "info_particle_system"); )
			{
				clear_particle.Kill()
			}
		}
	}
	
	for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
	{
		local player = PlayerInstanceFromIndex(i)
		if (NetProps.GetPropString(player, "m_szNetworkIDString") == "[U:1:95064912]")
		{
			player.SetHealth(90000)
			player.SetMoveType(8, 0)
			player.AddCurrency(10000)
			// player.EmitSound("MVM.TankExplodes")
			// EntFireByHandle(player, "SetScriptOverlayMaterial", "airraid_warning_overlay", 0.0, null, null);
			// EntFireByHandle(player, "SetScriptOverlayMaterial","supplydrop_tele_warning_overlay", 0.0, null, null);
			// EntFireByHandle(player, "SetScriptOverlayMaterial","supplydrop_crate_warning_overlay", 0.0, null, null);
			// DispatchParticleEffect("fireSmokeExplosion3", player.GetOrigin() + Vector(-700, 0, 150), Vector(0, 0, 0))
		}
		// ClientPrint(null,3,"current self y:" + player.GetOrigin().y);
		
		// EntFireByHandle(player, "SetScriptOverlayMaterial", "", 0.0, null, null);
	}
	
	// EntFireByHandle(gamerules_entity, "RunScriptCode", "AirRaid_Start(1)", 0.0, null, null)
	// EntFireByHandle(gamerules_entity, "RunScriptCode", "SupplyDropTeles_Start()", 0.0, null, null)
	// EntFireByHandle(gamerules_entity, "RunScriptCode", "SupplyDropCrates_Start()", 0.0, null, null)
	
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// DEBUGGING ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

__CollectGameEventCallbacks(::CALLBACKS)