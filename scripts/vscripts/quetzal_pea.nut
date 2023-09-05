ClearGameEventCallbacks()

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// LOCALS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////// DEBUGGING ///////////////////////////////////

local debug = false
local debug_airraid = false
local debug_supplydrop_teles = false
local debug_supplydrop_crates = false
local debug_zeppelin = false

/////////////////////////////////// DEBUGGING ///////////////////////////////////
/////////////////////////////////// GLOBAL ENTITIES ///////////////////////////////////

local gamerules_entity;
gamerules_entity = Entities.FindByName(gamerules_entity, "gamerules")

local objective_resource_entity;
objective_resource_entity = Entities.FindByClassname(objective_resource_entity, "tf_objective_resource")

local wave_start_relay_entity;
wave_start_relay_entity = Entities.FindByName(wave_start_relay_entity, "wave_start_relay")

local intel_entity;
intel_entity = Entities.FindByName(intel_entity, "Classic_Mode_Intel")

/////////////////////////////////// GLOBAL ENTITIES ///////////////////////////////////
/////////////////////////////////// AIR RAID ///////////////////////////////////

local airraid_dmg_multiplier = 0
local plane_count = 0
local planes_done_flying = 0

/////////////////////////////////// AIR RAID ///////////////////////////////////
/////////////////////////////////// SUPPLY DROP (TELEPORTERS) ///////////////////////////////////

local helis_done_flying = 0

local tele_spot_1 = null
local tele_spot_2 = null
local tele_spot_3 = null
local tele_spot_4 = null
local tele_spot_5 = null
local tele_spot_6 = null
local tele_spot_7 = null

local teledestination_table =
{
	"1": Vector(-500, 200, -250) // a1
	"2": Vector(1100, 0, -400) // a1
	"3": Vector(500, 200, -250) // a1
	"4": Vector(-100, -1400, -150) // a2
	"5": Vector(500, -700, -150) // a2
	"6": Vector(1000, -2000, -400) // a3
	"7": Vector(-600, -1700, -380) // a3
}

local teleport_status = "disabled"

/////////////////////////////////// SUPPLY DROP (TELEPORTERS) ///////////////////////////////////
/////////////////////////////////// SUPPLY DROP (GIANT CRATES) ///////////////////////////////////

local cratehelis_done_flying = 0

local has_crate1_dropped = false
local has_crate2_dropped = false
local has_crate3_dropped = false

/////////////////////////////////// SUPPLY DROP (GIANT CRATES) ///////////////////////////////////
/////////////////////////////////// ZEPPELIN BOSS ///////////////////////////////////

local zeppelin = null

local zeppelin_path_train = null

local zeppelin_bomb_deploy_point = null

/////////////////////////////////// ZEPPELIN BOSS ///////////////////////////////////
/////////////////////////////////// ZEPPELIN TANKS ///////////////////////////////////

local cur_zeppelin_tank = null

local zeppelin_cage_tankprop1 = null
local zeppelin_cage_tankprop2 = null
local zeppelin_cage_tankprop3 = null

local zeppelin_engines_status = "alive, alive, alive"

local zeppelin_cage_tankprop1_teledest = null
local zeppelin_cage_tankprop2_teledest = null
local zeppelin_cage_tankprop3_teledest = null

local zeps_materializing_progress = 1
local zeppelin_crash_frame = 100

::zeppelin_tank_fall_accel_rate <- 0

/////////////////////////////////// ZEPPELIN BOSS ///////////////////////////////////
/////////////////////////////////// HELIUM CRATES ///////////////////////////////////

local helium_crate_number = 1

/////////////////////////////////// HELIUM CRATES ///////////////////////////////////
/////////////////////////////////// SOUND TABLES ///////////////////////////////////

local explosion_sound_table =
{
	"1": "=40|ambient/explosions/explode_1.wav",
	"2": "=40|ambient/explosions/explode_2.wav",
	"3": "=40|ambient/explosions/explode_3.wav",
	"4": "=40|ambient/explosions/explode_4.wav",
	"5": "=40|ambient/explosions/explode_5.wav",
	"6": "=40|ambient/explosions/explode_7.wav",
	"7": "=40|ambient/explosions/explode_8.wav",
	"8": "=40|ambient/explosions/explode_9.wav",
}

/////////////////////////////////// SOUND TABLES ///////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// LOCALS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// AUTOEXECUTE ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////// EVERY WAVE ///////////////////////////////////

NetProps.SetPropString(gamerules_entity, "m_iszScriptThinkFunction", "");

SetSkyboxTexture("sky_mayan")

EntityOutputs.RemoveOutput(wave_start_relay_entity, "OnTrigger", "gamerules", "RunScriptCode", "SetUpInWaveHUD()")
EntityOutputs.AddOutput(wave_start_relay_entity, "OnTrigger", "gamerules", "RunScriptCode", "SetUpInWaveHUD()", 0.0, -1)

for (local think_to_clear; think_to_clear = Entities.FindByName(think_to_clear, "defenderspushedcheck"); )
{
	think_to_clear.Kill()
}

for (local think_to_clear; think_to_clear = Entities.FindByName(think_to_clear, "teleskylight"); )
{
	think_to_clear.Kill()
}

/////////////////////////////////// EVERY WAVE ///////////////////////////////////
/////////////////////////////////// WAVE 2 ///////////////////////////////////

if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 2)
{	
	EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassCounts$9", "1")
	EntFire("tf_objective_resource", "$SetProp$m_iszMannVsMachineWaveClassNames$9", "plane_lite_blu")
	EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$9", "4")
}

/////////////////////////////////// WAVE 2 ///////////////////////////////////
/////////////////////////////////// WAVE 3 ///////////////////////////////////

if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 3)
{
	EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassCounts$10", "1")
	EntFire("tf_objective_resource", "$SetProp$m_iszMannVsMachineWaveClassNames$10", "teleporter")
	EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$10", "4")
	
	EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassCounts$11", "1")
	EntFire("tf_objective_resource", "$SetProp$m_iszMannVsMachineWaveClassNames$11", "helicopter_blue_nys_nomiplod")
	EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$11", "4")
}

/////////////////////////////////// WAVE 3 ///////////////////////////////////
/////////////////////////////////// WAVE 4 ///////////////////////////////////

if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 4)
{
	EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassCounts$9", "1")
	EntFire("tf_objective_resource", "$SetProp$m_iszMannVsMachineWaveClassNames$9", "teleporter")
	EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$9", "4")
	
	EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassCounts$10", "1")
	EntFire("tf_objective_resource", "$SetProp$m_iszMannVsMachineWaveClassNames$10", "plane_lite_blu")
	EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$10", "4")
}

/////////////////////////////////// WAVE 4 ///////////////////////////////////
/////////////////////////////////// WAVE 5 ///////////////////////////////////

if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 5)
{	
	EntFire("player", "$PlaySoundToSelf", "ambient/thunder3.wav", 5.0)
	EntFire("player", "$PlaySoundToSelf", "ambient/thunder4.wav", 10.0)
	EntFireByHandle(gamerules_entity, "RunScriptCode", "ScreenFade(null, 175, 175, 175, 255, 0.25, 0.25, 2)", 10.0, null, null)
	EntFireByHandle(gamerules_entity, "RunScriptCode", "ScreenFade(null, 175, 175, 175, 255, 0.25, 0.25, 1)", 10.25, null, null)
	EntFireByHandle(gamerules_entity, "RunScriptCode", "SetSkyboxTexture(`sky_alpinestorm_01`)", 10.5, null, null)
	EntFireByHandle(gamerules_entity, "RunScriptCode", "SetUpRain()", 10.5, null, null)
}

/////////////////////////////////// WAVE 5 ///////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// AUTOEXECUTE ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////// AIR RAID ///////////////////////////////////

::AirRaid_Start <- function(dmg)
{
	airraid_dmg_multiplier = dmg
	
	if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 2)
	{	
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$9", "4")
	}
	if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 4)
	{	
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$10", "4")
	}
	
	EntFire("player", "$PlaySoundToSelf", "mvm/ambient_mp3/mvm_siren.mp3", 3.0)
	
	AddThinkToEnt(gamerules_entity, "AirRaid_SpawnPlaneTemplate_Think")
	
	for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
	{
		local player = PlayerInstanceFromIndex(i)
		
		if (player == null) continue;
		if (IsPlayerABot(player)) continue;
		
		AddThinkToEnt(player, "AirRaid_PlayerInteraction_Think")
		
		EntFireByHandle(player, "SetScriptOverlayMaterial","airraid_warning_overlay", 0.0, null, null);
		EntFireByHandle(player, "SetScriptOverlayMaterial","", 8.0, null, null);
	}
}

::AirRaid_SpawnPlaneTemplate_Think <- function()
{
	local x = RandomInt(-800,850)
	local z = RandomInt(800,1050)
	
	if (plane_count < 30)
	{
		local plane_template_ent1 = SpawnEntityFromTable("path_track", 
		{
			origin 		            = Vector(x, 5250, z),
			targetname              = "plane_killpoint_" + plane_count,
			speed                   = 1000.0,
			"OnPass#2"              : "!activator,KillHierarchy,,0,-1"
		})

		local plane_template_ent2 = SpawnEntityFromTable("path_track", 
		{
			origin 		            = Vector(x, -7500, z),
			targetname              = "plane_spawnpoint_" + plane_count,
			target                  = "plane_killpoint_" + plane_count,
			speed                   = 1000.0,
		})

		local plane_template_ent3 = SpawnEntityFromTable("func_tracktrain", 
		{
			targetname              = "plane_pathtrain_" + plane_count,
			target                  = "plane_spawnpoint_" + plane_count,
			startspeed              = 1000.0,
			speed                   = 1000.0,
			origin                  = Vector(x, -7500, z),
		})

		local plane_template_ent4 = SpawnEntityFromTable("prop_dynamic",
		{
			targetname              = "plane_model_" + plane_count
			origin                  = Vector(x, -7500, z)
			model                   = "models/props_frontline/warhawk.mdl"
			skin                    = 1,
		    DefaultAnim             = "Slow_Spin"
		    playbackrate            = 2
		})
	
        local plane_template_ent5 = SpawnEntityFromTable("tf_point_weapon_mimic",
		{
			targetname           = "plane_gun_" + plane_count,
			parentname           = "plane_model_" + plane_count
			origin               = plane_template_ent4.GetOrigin(),
			angles               = plane_template_ent4.GetAbsAngles(),
			speedmin             = 525,
			speedmax             = 525,
			spreadangle          = 25,
			"$firetime"          : 0.5,
			"$weaponname"        : "The Loose Cannon"
		})
		
		local plane_template_ent6 = SpawnEntityFromTable("info_particle_system",
		{
			targetname         = "plane_smoke_" + plane_count,
			origin             = plane_template_ent4.GetOrigin() + Vector(0, 0, 25),
			angles             = plane_template_ent4.GetAbsAngles(),
			start_active       = 1,
			effect_name        = "rockettrail"
		})
		
		local plane_template_ent7 = SpawnEntityFromTable("ambient_generic", 
		{
			targetname   = "plane_sound_" + plane_count
			health       = 10
			spawnflags   = 0
			radius       = 15000
			pitchstart   = 100
			pitch        = 100
			message      = "planesound.wav"
			SourceEntityName = "plane_model_" + plane_count
		})
		
		
		EntFire("plane_model_" + plane_count, "SetParent", "plane_pathtrain_" + plane_count);
		EntFire("plane_gun_" + plane_count, "SetParent", "plane_model_" + plane_count);
		EntFire("plane_gun_" + plane_count, "$SetOwner", "plane_model_" + plane_count);
		EntFire("plane_smoke_" + plane_count, "SetParent", "plane_model_" + plane_count);
		EntFire("plane_gun_" + plane_count, "$AddWeaponAttribute", "grenade launcher mortar mode|0");
		EntFire("plane_gun_" + plane_count, "$AddWeaponAttribute", "Blast radius increased|2.5");
		EntFire("plane_gun_" + plane_count, "$AddWeaponAttribute", "damage bonus|" + airraid_dmg_multiplier);
		EntFire("plane_gun_" + plane_count, "$StartFiring", 4);
		
		EntityOutputs.AddOutput(plane_template_ent1, "OnPass", "gamerules", "RunScriptCode", "AirRaid_StatusChecker()", 0.0, -1)
		EntityOutputs.AddOutput(plane_template_ent1, "OnPass", "plane_sound_" + plane_count, "StopSound", null, 0.0, -1)
		
		plane_count = plane_count + 1
	}
	else
	{
		return 3600;
	}
	
    return RandomFloat(1.0, 2.0)
}

::AirRaid_StatusChecker <- function()
{
	planes_done_flying = planes_done_flying + 1
	
	if (planes_done_flying == 30)
	{
		EntFire("plane_killpoint_*", "Kill")
		EntFire("plane_spawnpoint_*", "Kill")
		EntFire("plane_pathtrain_*", "Kill")
		
		if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 2)
		{	
			EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$9", "0")
		}
		if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 4)
		{	
			EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$10", "0")
		}
	}
}

::AirRaid_PlayerInteraction_Think <- function()
{
	if (debug_airraid) ClientPrint(null,3,"alive\n")
	local self_origin = self.GetOrigin()
	if (Entities.FindByNameWithin(null, "plane_model_*", self_origin, 100.0) != null)
	{
		self.TakeDamage(1000.0, 64, null)
	}
	if (Entities.FindByNameWithin(null, "plane_model_*", self_origin, 1500.0) != null)
	{
		ScreenShake(self_origin, 16.0, 10.0, 0.1, 100.0, 0, true)
	}
	if (planes_done_flying == 30)
	{
		NetProps.SetPropString(self, "m_iszScriptThinkFunction", "");
	}
	return
}

/////////////////////////////////// AIR RAID ///////////////////////////////////
/////////////////////////////////// SUPPLY DROP (TELEPORTERS) ///////////////////////////////////

::SupplyDropTeles_Start <- function()
{
	if (debug_supplydrop_teles) ClientPrint(null,3,"supply drop tele initiated\n")
	
	if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 3)
	{	
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$10", "4")
	}
	if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 4)
	{	
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$9", "4")
	}
	
	EntFire("player", "$PlaySoundToSelf", "supplydrop_morse.wav", 0.0)
	
	EntFireByHandle(gamerules_entity, "RunScriptCode","SupplyDropTeles_SpawnHeliTemplate(1, -500, 200)", RandomFloat(1.0,5.0), null, null);
	EntFireByHandle(gamerules_entity, "RunScriptCode","SupplyDropTeles_SpawnHeliTemplate(2, -100, -1400)", RandomFloat(1.0,5.0), null, null);
	EntFireByHandle(gamerules_entity, "RunScriptCode","SupplyDropTeles_SpawnHeliTemplate(3, 500, -700)", RandomFloat(1.0,5.0), null, null);
	EntFireByHandle(gamerules_entity, "RunScriptCode","SupplyDropTeles_SpawnHeliTemplate(4, 500, 200)", RandomFloat(1.0,5.0), null, null);
	EntFireByHandle(gamerules_entity, "RunScriptCode","SupplyDropTeles_SpawnHeliTemplate(5, 1000, -2000)", RandomFloat(1.0,5.0), null, null);
	EntFireByHandle(gamerules_entity, "RunScriptCode","SupplyDropTeles_SpawnHeliTemplate(6, 1100, 0)", RandomFloat(1.0,5.0), null, null);
	EntFireByHandle(gamerules_entity, "RunScriptCode","SupplyDropTeles_SpawnHeliTemplate(7, -600, -1700)", RandomFloat(1.0,5.0), null, null);
	
	for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
	{
		local player = PlayerInstanceFromIndex(i)
		if (player == null) continue;
		if (IsPlayerABot(player)) continue;
		AddThinkToEnt(player, "SupplyDropTeles_PlayerInteraction_Think")
		EntFireByHandle(player, "SetScriptOverlayMaterial","supplydrop_tele_warning_overlay", 0.0, null, null);
		EntFireByHandle(player, "SetScriptOverlayMaterial","", 8.0, null, null);
	}
	
	teleport_status = "inactive"
}

::SupplyDropTeles_SpawnHeliTemplate <- function(num, x, y)
{
	local z = RandomInt(800,1050)
	
	local teleheli_ent1 = SpawnEntityFromTable("path_track", 
	{
		origin 		            = Vector(x, 5250, z), // kill point
		targetname              = "heli_killpoint_" + num,
		speed                   = 1000.0,
		"OnPass#2"              : "!activator,KillHierarchy,,0,-1"
	})

	local teleheli_ent2 = SpawnEntityFromTable("path_track", 
	{
		origin 		            = Vector(x, y, z), // drop point
		targetname              = "heli_droppoint_" + num,
		target                  = "heli_killpoint_" + num,
		speed                   = 1000.0,
	})

	local teleheli_ent3 = SpawnEntityFromTable("path_track", 
	{
		origin 		            = Vector(x, -7500, z), // spawn point
		targetname              = "heli_spawnpoint_" + num,
		target                  = "heli_droppoint_" + num,
		speed                   = 1000.0,
	})

	local teleheli_ent4 = SpawnEntityFromTable("func_tracktrain", 
	{
		targetname              = "heli_pathtrain_" + num,
		target                  = "heli_spawnpoint_" + num,
		startspeed              = 1000.0,
		speed                   = 1000.0,
		origin                  = Vector(x, -7500, z),
	})

	local teleheli_ent5 = SpawnEntityFromTable("prop_dynamic",
	{
		targetname              = "heli_model_" + num
		origin                  = Vector(x, -7500, z)
		model                   = "models/props_frontline/helicopter.mdl"
		DefaultAnim             = "Fly_idle"
		playbackrate            = 1
		skin                    = 1
	})
	
	local teleheli_ent6 = SpawnEntityFromTable("ambient_generic", 
	{
		targetname   = "heli_sound_" + num
		health       = 10
		spawnflags   = 0
		radius       = 12500
		pitchstart   = 100
		pitch        = 100
		message      = "helisound.wav"
		SourceEntityName = "heli_model_" + num
	})
	
	EntFire("heli_model_" + num, "SetParent", "heli_pathtrain_" + num)
	EntFire("heli_sound_" + num, "PlaySound")
	
	EntityOutputs.AddOutput(teleheli_ent1, "OnPass", "heli_sound_" + num, "StopSound", null, 0.0, -1)
	EntityOutputs.AddOutput(teleheli_ent1, "OnPass", "gamerules", "RunScriptCode", "SupplyDropTeles_ActivateTeleporters()", 0.0, -1)
	EntityOutputs.AddOutput(teleheli_ent2, "OnPass", "gamerules", "RunScriptCode", "SupplyDropTeles_DropTeleporterCrate(" + num + "," + x + "," + y + "," + z + ")", 0.0, -1)
}

::SupplyDropTeles_DropTeleporterCrate <- function(num, x, y, z)
{
	local telecrate = SpawnEntityFromTable("prop_physics_multiplayer",
	{
		origin                  = Vector(x, y, z)
		targetname              = "telecrate_" + num,
		model                   = "models/props_hydro/barrel_crate_half.mdl"
		massscale               = 50
		spawnflags              = 0
	})
	
	AddThinkToEnt(telecrate, "CrateCrushPlayers")
	EntFire("telecrate_" + num, "Kill", null, 2)
	
	if (num == 1)
	{
		tele_spot_1 = SpawnEntityFromTable("prop_dynamic",
		{
			targetname    = "telespot_" + num,
			origin        = Vector(-500, 200, -280)
			angles        = QAngle(0, 90, 0)
			StartDisabled = 1
			model         = "models/props_mvm/robot_spawnpoint.mdl"
			skin          = 1
			DefaultAnim   = "idle"
		})
		
		EntFireByHandle(gamerules_entity, "RunScriptCode", "DispatchParticleEffect(`fireSmoke_Collumn_mvmAcres`, Vector(-500, 200, -280), Vector(0, 90, 0))", 2.0, null, null)
	}
	
	if (num == 2)
	{
		tele_spot_2 = SpawnEntityFromTable("prop_dynamic",
		{
			targetname    = "telespot_" + num,
			origin        = Vector(-100, -1400, -182)
			angles        = QAngle(0, 90, 0)
			StartDisabled = 1
			model         = "models/props_mvm/robot_spawnpoint.mdl"
			skin          = 1
			DefaultAnim   = "idle"
		})
		
		EntFireByHandle(gamerules_entity, "RunScriptCode", "DispatchParticleEffect(`fireSmoke_Collumn_mvmAcres`, Vector(-100, -1400, -180), Vector(0, 90, 0))", 2.0, null, null)
	}
	
	if (num == 3)
	{
		tele_spot_3 = SpawnEntityFromTable("prop_dynamic",
		{
			targetname    = "telespot_" + num,
			origin        = Vector(500, -700, -184)
			angles        = QAngle(0, 90, 0)
			StartDisabled = 1
			model         = "models/props_mvm/robot_spawnpoint.mdl"
			skin          = 1
			DefaultAnim   = "idle"
		})
		
		EntFireByHandle(gamerules_entity, "RunScriptCode", "DispatchParticleEffect(`fireSmoke_Collumn_mvmAcres`, Vector(500, -700, -190), Vector(0, 90, 0))", 2.0, null, null)
	}
	
	if (num == 4)
	{
		tele_spot_4 = SpawnEntityFromTable("prop_dynamic",
		{
			targetname    = "telespot_" + num,
			origin        = Vector(500, 200, -284)
			angles        = QAngle(0, 90, 0)
			StartDisabled = 1
			model         = "models/props_mvm/robot_spawnpoint.mdl"
			skin          = 1
			DefaultAnim   = "idle"
		})
		
		EntFireByHandle(gamerules_entity, "RunScriptCode", "DispatchParticleEffect(`fireSmoke_Collumn_mvmAcres`, Vector(500, 200, -280), Vector(0, 90, 0))", 2.0, null, null)
	}
	
	if (num == 5)
	{
		tele_spot_5 = SpawnEntityFromTable("prop_dynamic",
		{
			targetname    = "telespot_" + num,
			origin        = Vector(1000, -2000, -407)
			angles        = QAngle(0, 90, 0)
			StartDisabled = 1
			model         = "models/props_mvm/robot_spawnpoint.mdl"
			skin          = 1
			DefaultAnim   = "idle"
		})
		
		EntFireByHandle(gamerules_entity, "RunScriptCode", "DispatchParticleEffect(`fireSmoke_Collumn_mvmAcres`, Vector(1000, -2000, -410), Vector(0, 90, 0))", 2.0, null, null)
	}
	
	if (num == 6)
	{
		tele_spot_6 = SpawnEntityFromTable("prop_dynamic",
		{
			targetname    = "telespot_" + num,
			origin        = Vector(1100, 0, -413)
			angles        = QAngle(0, -90, 0)
			StartDisabled = 1
			model         = "models/props_mvm/robot_spawnpoint.mdl"
			skin          = 1
			DefaultAnim   = "idle"
		})
		
		EntFireByHandle(gamerules_entity, "RunScriptCode", "DispatchParticleEffect(`fireSmoke_Collumn_mvmAcres`, Vector(1100, 0, -420), Vector(0, 90, 0))", 2.0, null, null)
	}
	
	if (num == 7)
	{
		tele_spot_7 = SpawnEntityFromTable("prop_dynamic",
		{
			targetname    = "telespot_" + num,
			origin        = Vector(-600, -1700, -381)
			angles        = QAngle(0, -90, 0)
			StartDisabled = 1
			model         = "models/props_mvm/robot_spawnpoint.mdl"
			skin          = 1
			DefaultAnim   = "idle"
		})
		
		EntFireByHandle(gamerules_entity, "RunScriptCode", "DispatchParticleEffect(`fireSmoke_Collumn_mvmAcres`, Vector(-600, -1700, -380), Vector(0, 90, 0))", 2.0, null, null)
	}
	
	local crate_dropsounds =
	{
		"1": "physics/wood/wood_box_break" + RandomInt(1,2) + ".wav",
		"2": "physics/wood/wood_crate_break" + RandomInt(1,5) + ".wav"
	}
	
	EntFire("telespot_" + num, "$PlaySound", crate_dropsounds[RandomInt(1,2).tostring()], 2)
	EntFire("telespot_" + num, "Enable", null, 3)
}

::SupplyDropTeles_ActivateTeleporters <- function()
{
	helis_done_flying = helis_done_flying + 1
	
	local teleport_spawn_enabler = Entities.FindByName(null, "enable_teles")
	
	if (helis_done_flying == 7)
	{
		EntFire("heli_killpoint_*", "Kill")
		EntFire("heli_droppoint_*", "Kill")
		EntFire("heli_spawnpoint_*", "Kill")
		EntFire("heli_pathtrain_*", "Kill")
		
		if (teleport_spawn_enabler != null)
		{
			EntFireByHandle(teleport_spawn_enabler, "Kill", null, 3.0, null, null)
			EntFire("player", "$PlaySoundToSelf", "mvm/mvm_tele_activate.wav", 0.0)
		}
		
		teleport_status = "active"
	}
}

::SupplyDropTeles_Pause <- function(action)
{
	if (action == "pause")
	{
		teleport_status = "inactive"
		EntFire("player", "$PlaySoundToSelf", "weapons/sapper_removed.wav", 0.0)
	}
	if (action == "resume")
	{
		teleport_status = "active"
		EntFire("player", "$PlaySoundToSelf", "teleporter_spin3_fade.wav", 0.0)
	}
}

::SupplyDropTeles_End <- function()
{
	for (local telespot; telespot = Entities.FindByName(telespot, "telespot_*"); )
	{
		DispatchParticleEffect("fluidSmokeExpl_ring_mvm", telespot.GetOrigin(), Vector(0, 0, 0))
		EntFireByHandle(telespot, "Kill", "", 0.0, null, null)
	}
	
	EntFire("player", "$PlaySoundToSelf", "weapons/teleporter_explode.wav", 0.0)
	
	if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 3)
	{	
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$10", "0")
	}
	if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 4)
	{	
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$9", "0")
	}
	
	teleport_status = "disabled"
}

::SupplyDropTeles_TeleportRobot <- function()
{	
	if (!(self.HasBotAttribute(32768))) EntFire("player", "$PlaySoundToSelf", "=35|mvm/mvm_tele_deliver.wav", 0.0)
	if (self.HasBotAttribute(32768))
	{
		NetProps.SetPropBool(self, "m_bGlowEnabled", true)
		EntFire("player", "$PlaySoundToSelf", "mvm/giant_heavy/giant_heavy_entrance.wav", 0.0)
	}
	
	if (intel_entity.GetOrigin().y <= -2500.0) 											self.Teleport(true, teledestination_table[RandomInt(1, 5).tostring()], false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
	if (intel_entity.GetOrigin().y > -2500.0 && intel_entity.GetOrigin().y <= -1200.0)  self.Teleport(true, teledestination_table[RandomInt(1, 3).tostring()], false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
	if (intel_entity.GetOrigin().y > -1200.0) 											self.Teleport(true, teledestination_table[RandomInt(6, 7).tostring()], false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
	
	for (local entity_to_telefrag; entity_to_telefrag = Entities.FindInSphere(entity_to_telefrag, self.GetOrigin(), 100); )
	{
		if (entity_to_telefrag.GetTeam() == 2)
		{
			entity_to_telefrag.TakeDamage(1000.0, 64, self)
		}
	}
}

::SupplyDropTeles_PlayerInteraction_Think <- function()
{
	if (debug_supplydrop_teles) ClientPrint(null,3,"alive\n")
	local self_origin = self.GetOrigin()
	if (Entities.FindByNameWithin(null, "heli_model_*", self_origin, 100.0) != null)
	{
		self.TakeDamage(1000.0, 64, null)
	}
	if (helis_done_flying == 7)
	{
		NetProps.SetPropString(self, "m_iszScriptThinkFunction", "");
	}
	return
}

/////////////////////////////////// SUPPLY DROP (TELEPORTERS) ///////////////////////////////////
/////////////////////////////////// SUPPLY DROP (GIANT CRATES) ///////////////////////////////////

::SupplyDropCrates_Start <- function()
{
	if (debug_supplydrop_crates) ClientPrint(null,3,"supply drop crate initiated\n")
	
	EntFire("player", "$PlaySoundToSelf", "supplydrop_morse.wav", 0.0)
	
	if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 3)
	{	
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$11", "4")
	}
	
	EntFireByHandle(gamerules_entity, "RunScriptCode","SupplyDropCrates_SpawnHeliTemplate(1, -3500)", RandomFloat(1.0,2.0), null, null);
	EntFireByHandle(gamerules_entity, "RunScriptCode","SupplyDropCrates_SpawnHeliTemplate(2, -2000)", RandomFloat(3.0,4.0), null, null);
	EntFireByHandle(gamerules_entity, "RunScriptCode","SupplyDropCrates_SpawnHeliTemplate(3, -1000)", RandomFloat(5.0,6.0), null, null);
	
	for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
	{
		local player = PlayerInstanceFromIndex(i)
		if (player == null) continue;
		if (IsPlayerABot(player)) continue;
		AddThinkToEnt(player, "SupplyDropCrates_PlayerInteraction_Think")
		EntFireByHandle(player, "SetScriptOverlayMaterial","supplydrop_crate_warning_overlay", 0.0, null, null);
		EntFireByHandle(player, "SetScriptOverlayMaterial","", 8.0, null, null);
	}
}

::SupplyDropCrates_SpawnHeliTemplate <- function(num, y)
{
	if (debug_supplydrop_crates) ClientPrint(null,3,"tele heli spawned\n")
	
	local z = RandomInt(800,1050)
	
	local crateheli_ent1 = SpawnEntityFromTable("path_track", 
	{
		origin 		            = Vector(0, 5250, z), // kill point
		targetname              = "crateheli_killpoint_" + num,
		speed                   = 1000.0,
		"OnPass#2"              : "!activator,KillHierarchy,,0,-1"
	})

	local crateheli_ent2 = SpawnEntityFromTable("path_track", 
	{
		origin 		            = Vector(0, y, z), // drop point
		targetname              = "crateheli_droppoint_" + num,
		target                  = "crateheli_killpoint_" + num,
		speed                   = 1000.0,
	})

	local crateheli_ent3 = SpawnEntityFromTable("path_track", 
	{
		origin 		            = Vector(0, -7500, z), // spawn point
		targetname              = "crateheli_spawnpoint_" + num,
		target                  = "crateheli_droppoint_" + num,
		speed                   = 1000.0,
	})

	local crateheli_ent4 = SpawnEntityFromTable("func_tracktrain", 
	{
		targetname              = "crateheli_pathtrain_" + num,
		target                  = "crateheli_spawnpoint_" + num,
		startspeed              = 1000.0,
		speed                   = 1000.0,
		origin                  = Vector(0, -7500, z),
	})

	local crateheli_ent5 = SpawnEntityFromTable("prop_dynamic",
	{
		targetname              = "crateheli_model_" + num
		origin                  = Vector(0, -7500, z)
		model                   = "models/props_frontline/helicopter.mdl"
		DefaultAnim             = "Fly_idle"
		playbackrate            = 1
		skin                    = 1
	})
	
	local crateheli_ent6 = SpawnEntityFromTable("ambient_generic", 
	{
		targetname   = "crateheli_sound_" + num
		health       = 10
		spawnflags   = 0
		radius       = 9999
		pitchstart   = 100
		pitch        = 100
		message      = "helisound.wav"
		SourceEntityName = "crateheli_model_" + num
	})
	
	EntFire("crateheli_model_" + num, "SetParent", "crateheli_pathtrain_" + num)
	EntFire("crateheli_sound_" + num, "PlaySound")
	
	EntityOutputs.AddOutput(crateheli_ent1, "OnPass", "crateheli_sound_" + num, "StopSound", null, 0.0, -1)
	EntityOutputs.AddOutput(crateheli_ent1, "OnPass", "gamerules", "RunScriptCode", "SupplyDropCrates_StatusChecker()", 0.0, -1)
	EntityOutputs.AddOutput(crateheli_ent2, "OnPass", "gamerules", "RunScriptCode", "SupplyDropCrates_DropGiantCrate(" + num + "," + y + "," + z + ")", 0.0, -1)

}

::SupplyDropCrates_StatusChecker <- function()
{
	cratehelis_done_flying = cratehelis_done_flying + 1
	
	if (cratehelis_done_flying == 3)
	{
		EntFire("crateheli_killpoint_*", "Kill")
		EntFire("crateheli_droppoint_*", "Kill")
		EntFire("crateheli_spawnpoint_*", "Kill")
		EntFire("crateheli_pathtrain_*", "Kill")
	}
}

::SupplyDropCrates_DropGiantCrate <- function(num, y, z)
{
	if (debug_supplydrop_crates) ClientPrint(null,3,"coords are " + num + y + z)
	
	has_crate1_dropped = true
	has_crate2_dropped = true
	has_crate3_dropped = true
	
	local telecrate = SpawnEntityFromTable("prop_physics_multiplayer",
	{
		origin                  = Vector(0, y, z)
		targetname              = "giantcrate_" + num,
		model                   = "models/props_hydro/barrel_crate.mdl"
		massscale               = 50
		spawnflags              = 4
	})
	
	AddThinkToEnt(telecrate, "CrateCrushPlayers")
	
	local giantcrate_dropsounds =
	{
		"1": "physics/wood/wood_box_break" + RandomInt(1,2) + ".wav",
		"2": "physics/wood/wood_crate_break" + RandomInt(1,5) + ".wav"
	}
	
	EntFire("giantcrate_" + num, "$PlaySound", giantcrate_dropsounds[RandomInt(1,2).tostring()], 2.0)
	EntFire("giantcrate_" + num, "Kill", null, 2.0)
	EntFireByHandle(gamerules_entity, "RunScriptCode", "SupplyDropCrates_ActivateTeleporting(" + num + ")", 2.0, null, null)
	
	if (num == 1)
	{
		EntFireByHandle(gamerules_entity, "RunScriptCode", "DispatchParticleEffect(`fireSmoke_Collumn_mvmAcres`, Vector(0, -3500, -350), Vector(0, 90, 0))", 2.0, null, null)
	}
	if (num == 2)
	{	
		EntFireByHandle(gamerules_entity, "RunScriptCode", "DispatchParticleEffect(`fireSmoke_Collumn_mvmAcres`, Vector(0, -2000, -350), Vector(0, 90, 0))", 2.0, null, null)
	}
	if (num == 3)
	{
		EntFireByHandle(gamerules_entity, "RunScriptCode", "DispatchParticleEffect(`fireSmoke_Collumn_mvmAcres`, Vector(0, -1000, -100), Vector(0, 90, 0))", 2.0, null, null)
	}
}

::SupplyDropCrates_ActivateTeleporting <- function(num)
{	
	if (num == 1)
	{
		local crate1_spawn_enabler = Entities.FindByName(null, "enable_crate1_spawn")

		EntFireByHandle(crate1_spawn_enabler, "Kill", null, 0.0, null, null)
	}
	if (num == 2)
	{
		local crate2_spawn_enabler = Entities.FindByName(null, "enable_crate2_spawn")

		EntFireByHandle(crate2_spawn_enabler, "Kill", null, 0.0, null, null)
	}
	if (num == 3)
	{
		local crate3_spawn_enabler = Entities.FindByName(null, "enable_crate3_spawn")

		EntFireByHandle(crate3_spawn_enabler, "Kill", null, 0.0, null, null)
	}
}

::SupplyDropCrates_TeleportRobotToCrate <- function(num)
{
	NetProps.SetPropBool(self, "m_bGlowEnabled", true)
	EntFireByHandle(self, "RunScriptCode", "self.AddBotAttribute(8)", 0.0, null, null)
	EntFireByHandle(self, "RunScriptCode", "self.RemoveBotAttribute(8)", 2.5, null, null)
	
	if (num == 1 && has_crate1_dropped == true)
	{
		self.Teleport(true, Vector(0, -3500, -350), false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		
		has_crate1_dropped = false
	}
	if (num == 2 && has_crate2_dropped == true)
	{
		self.Teleport(true, Vector(0, -2000, -350), false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		
		has_crate2_dropped = false
	}
	if (num == 3 && has_crate3_dropped == true)
	{
		self.Teleport(true, Vector(0, -1000, -100), false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		
		has_crate3_dropped = false
	}
}

::SupplyDropCrates_PlayerInteraction_Think <- function()
{
	if (debug_supplydrop_crates) ClientPrint(null,3,"alive\n")
	local self_origin = self.GetOrigin()
	if (Entities.FindByNameWithin(null, "crateheli_model_*", self_origin, 100.0) != null)
	{
		self.TakeDamage(1000.0, 64, null)
	}
	if (cratehelis_done_flying == 3)
	{
		NetProps.SetPropString(self, "m_iszScriptThinkFunction", "");
	}
	return
}

/////////////////////////////////// SUPPLY DROP (GIANT CRATES) ///////////////////////////////////
/////////////////////////////////// ZEPPELIN BOSS ///////////////////////////////////

::Zeppelin_Start <- function()
{	
	if (debug_zeppelin) ClientPrint(null,3,"zeppelin spawned")
	
	local heliumcraterotate_ent = SpawnEntityFromTable("logic_relay",
	{
		targetname = "heliumcraterotate_ent"
	})
	
	AddThinkToEnt(heliumcraterotate_ent, "RotateHeliumCrates_Think")
	
	AddThinkToEnt(gamerules_entity, "Zeppelin_SpawnHeliumCrates_Think")
	
	zeppelin_bomb_deploy_point = SpawnEntityFromTable("path_track", 
	{
		origin 		 = Vector(0, 1400, 1300),
		targetname   = "zeppelin_train_drop_point",
		speed        = 40.0
	})
	
	local zeppelin_path_2 = SpawnEntityFromTable("path_track", 
	{
		origin 		 = Vector(0, -6000, 1300),
		targetname   = "zeppelin_train_spawn_point",
		target       = "zeppelin_train_drop_point",
		speed        = 40.0
	})
	
	zeppelin_path_train = SpawnEntityFromTable("func_tracktrain", 
	{
		targetname   = "zeppelin_pathtrain"
		target       = "zeppelin_train_spawn_point",
		startspeed   = 40.0,
		speed        = 40.0,
		origin       = Vector(0, -6000, 1300)
	})
	
	zeppelin = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_model"
		origin       = Vector(0, -6000, 1300)
		model        = "models/props_frontline/zeppelin_skybox.mdl",
		DefaultAnim  = "idle",
		playbackrate = 1,
		modelscale   = 10,
		skin         = 1,
		rendermode   = 1,
		renderamt    = 0.0
	})
	
	local zeppelin_sound_source = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_sound_source"
		model        = "models/props_hydro/barrel_crate_half.mdl"
		modelscale   = 0.001
		origin       = Vector(-1000, -6000, 1100)
	})
	
	local zeppelin_sound = SpawnEntityFromTable("ambient_generic", 
	{
		targetname   = "zeppelin_sound"
		health       = 10
		spawnflags   = 0
		radius       = 12500
		pitchstart   = 100
		pitch        = 100
		message      = "zeppelinsound.wav"
		SourceEntityName = "zeppelin_cage_model_sound_source"
	})
	
	local zeppelin_rotor_smoke_s2 = SpawnEntityFromTable("info_particle_system",
	{
		targetname         = "zeppelin_cage_model_rotor_smoke_s2"
		origin             = Vector(-1000, -6000, 1250)
		angles             = QAngle(0, 180, 0)
		start_active       = 0,
		effect_name        = "rockettrail_vents_doomsday"
	})
	
	local zeppelin_rotor_smoke_s3 = SpawnEntityFromTable("info_particle_system",
	{
		targetname         = "zeppelin_cage_model_rotor_smoke_s3"
		origin             = Vector(-1100, -6000, 1200)
		angles             = QAngle(0, 180, 0)
		start_active       = 0,
		effect_name        = "lava_fireball"
	})
	
	EntityOutputs.AddOutput(zeppelin_bomb_deploy_point, "OnPass", "player", "$PlaySoundToSelf", "vo/mvm_bomb_alerts0" + RandomInt(6,7) + ".mp3", 1.0, -1)
	EntityOutputs.AddOutput(zeppelin_bomb_deploy_point, "OnPass", "player", "$PlaySoundToSelf", "mvm/mvm_tank_deploy.wav", 0.0, -1)
	EntityOutputs.AddOutput(zeppelin_bomb_deploy_point, "OnPass", "gamerules", "RunScriptCode", "Zeppelin_BombDeployCheck()", 5.5, -1)
	AddThinkToEnt(zeppelin, "Zeppelin_Materialize_Think")
	
	////////////////// (CAGE FLOOR)
	
	local zeppelin_cage_s1 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s1_floor"
		origin       = Vector(768, -6128, 900)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, 90),
        solid        = 6
	})
	
	local zeppelin_cage_s1 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s1_floor"
		origin       = Vector(768, -5872, 900)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, -90),
        solid        = 6
	})
	
	local zeppelin_cage_s2 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s2_floor"
		origin       = Vector(256, -6128, 900)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, 90),
        solid        = 6
	})
	
	local zeppelin_cage_s2 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s2_floor"
		origin       = Vector(256, -5872, 900)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, -90),
        solid        = 6
	})
	
	local zeppelin_cage_s3 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s3_floor"
		origin       = Vector(-256, -6128, 900)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, 90),
        solid        = 6
	})
	
	local zeppelin_cage_s3 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s3_floor"
		origin       = Vector(-256, -5872, 900)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, -90),
        solid        = 6
	})
	
	////////////////// (LEFT CAGE WALL)
	
	// zeppelin_cage_s1 = spawnentityfromtable("prop_dynamic", 
	// {
		// targetname   = "zeppelin_cage_model_s1"
		// origin       = vector(768, -6278, 1050)
		// model        = "models/props_gameplay/security_fence512.mdl"
        // angles       = qangle(0, 0, 180),
        // solid        = 6
	// })
	
	// zeppelin_cage_s1 = spawnentityfromtable("prop_dynamic", 
	// {
		// targetname   = "zeppelin_cage_model_s1"
		// origin       = vector(768, -6278, 1306)
		// model        = "models/props_gameplay/security_fence512.mdl"
        // angles       = qangle(0, 0, 180),
        // solid        = 6
	// })
	
	local zeppelin_cage_s1 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s1"
		origin       = Vector(256, -6278, 1050)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s1 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s1"
		origin       = Vector(256, -6278, 1306)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s2 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s2"
		origin       = Vector(-256, -6278, 1050)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s2 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s2"
		origin       = Vector(-256, -6278, 1306)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, 180),
        solid        = 6
	})
	
	////////////////// (RIGHT CAGE WALL)
	
	// zeppelin_cage_s1 = SpawnEntityFromTable("prop_dynamic", 
	// {
		// targetname   = "zeppelin_cage_model_s1"
		// origin       = Vector(768, -5728, 1050)
		// model        = "models/props_gameplay/security_fence512.mdl"
        // angles       = QAngle(0, 0, 180),
        // solid        = 6
	// })
	
	// zeppelin_cage_s1 = SpawnEntityFromTable("prop_dynamic", 
	// {
		// targetname   = "zeppelin_cage_model_s1"
		// origin       = Vector(768, -5728, 1306)
		// model        = "models/props_gameplay/security_fence512.mdl"
        // angles       = QAngle(0, 0, 180),
        // solid        = 6
	// })
	
	local zeppelin_cage_s1 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s1"
		origin       = Vector(256, -5728, 1050)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s1 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s1"
		origin       = Vector(256, -5728, 1306)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s2 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s2"
		origin       = Vector(-256, -5728, 1050)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s2 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s2"
		origin       = Vector(-256, -5728, 1306)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 0, 180),
        solid        = 6
	})
	
	////////////////// (FRONT, MIDDLE, AND BACK CAGE WALLS)
	
	local zeppelin_cage_s1 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s1"
		origin       = Vector(798, -5778, 1050)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 90, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s1 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s1"
		origin       = Vector(798, -5778, 1306)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 90, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s2 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s2"
		origin       = Vector(286, -5778, 1050)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 90, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s2 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s2"
		origin       = Vector(286, -5778, 1306)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 90, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s3 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s3"
		origin       = Vector(-226, -5778, 1050)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 90, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s3 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s3"
		origin       = Vector(-226, -5778, 1306)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 90, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s3 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s3"
		origin       = Vector(-738, -5778, 1050)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 90, 180),
        solid        = 6
	})
	
	local zeppelin_cage_s3 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s3"
		origin       = Vector(-738, -5778, 1306)
		model        = "models/props_gameplay/security_fence512.mdl"
        angles       = QAngle(0, 90, 180),
        solid        = 6
	})
	
	////////////////// (CAGE TANK PROPS)
	
	zeppelin_cage_tankprop1 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s1_tankprop"
		origin       = Vector(536, -6008, 910)
		model        = "models/bots/boss_bot/boss_tank.mdl"
        angles       = QAngle(0, 0, 0)
	})
	
	zeppelin_cage_tankprop2 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s2_tankprop"
		origin       = Vector(24, -6008, 910)
		model        = "models/bots/boss_bot/boss_tank.mdl"
        angles       = QAngle(0, 0, 0)
	})
	
	zeppelin_cage_tankprop3 = SpawnEntityFromTable("prop_dynamic", 
	{
		targetname   = "zeppelin_cage_model_s3_tankprop"
		origin       = Vector(-488, -6008, 910)
		model        = "models/bots/boss_bot/boss_tank.mdl"
        angles       = QAngle(0, 0, 0)
		skin         = 1
	})
	
	zeppelin_cage_tankprop1_teledest = SpawnEntityFromTable("info_target", 
	{
		targetname   = "zeppelin_cage_model_s1_teledest"
		origin       = Vector(536, -6008, 910)
	})
	
	zeppelin_cage_tankprop2_teledest = SpawnEntityFromTable("info_target", 
	{
		targetname   = "zeppelin_cage_model_s2_teledest"
		origin       = Vector(24, -6008, 910)
	})
	
	zeppelin_cage_tankprop3_teledest = SpawnEntityFromTable("info_target", 
	{
		targetname   = "zeppelin_cage_model_s3_teledest"
		origin       = Vector(-488, -6008, 910)
	})
	
	EntFire("zeppelin_model", "SetParent", "zeppelin_pathtrain")
	EntFire("zeppelin_cage_model*", "SetParent", "zeppelin_model")
}

::Zeppelin_Materialize_Think <- function()
{
	EntFireByHandle(self, "$SetKey$renderamt", "" + zeps_materializing_progress, 0.0, null, null)
	
	zeps_materializing_progress = zeps_materializing_progress + 1
	
	if (debug_zeppelin) ClientPrint(null,3,"" + zeps_materializing_progress)
	
	if (zeps_materializing_progress == 255)
	{
		self.KeyValueFromInt("rendermode", 0)
		NetProps.SetPropString(self, "m_iszScriptThinkFunction", "");
	}
    return -1
}

::Zeppelin_ParentTank <- function(num)
{
	EntFire("zeppelin_engine_" + num + "_destructible", "SetParent", "zeppelin_model")
	
	cur_zeppelin_tank = Entities.FindByName(cur_zeppelin_tank, "zeppelin_engine_" + num + "_destructible")
	
	if (num == 1)
	{
		cur_zeppelin_tank.Teleport(true, zeppelin_cage_tankprop1_teledest.GetOrigin(), false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		zeppelin_cage_tankprop1.Kill()
	}
	if (num == 2)
	{
		cur_zeppelin_tank.Teleport(true, zeppelin_cage_tankprop2_teledest.GetOrigin(), false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		zeppelin_cage_tankprop2.Kill()
	}
	if (num == 3)
	{
		cur_zeppelin_tank.Teleport(true, zeppelin_cage_tankprop3_teledest.GetOrigin(), false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		zeppelin_cage_tankprop3.Kill()
	}
	
	EntFire("zeppelin_engine_" + num + "_destructible", "$SetLocalAngles", "0 0 0")
}

::Zeppelin_DestroyCageStage <- function(num)
{
	if (debug_zeppelin) ClientPrint(null,3,"function ran")
	
	EntFire("zeppelin_cage_model_s" + num + "*", "Kill")
	
	if (num == 1)
	{
		zeppelin_engines_status = "dead, alive, alive"
		
		zeppelin_bomb_deploy_point.KeyValueFromVector("origin", zeppelin_bomb_deploy_point.GetOrigin() + Vector(0, 512, 0))
		
		AddThinkToEnt(zeppelin, "Zeppelin_DescendStage1_Think")
		
		EntFire("zeppelin_model", "SetPlaybackRate", 0.8)
		EntFire("zeppelin_pathtrain", "SetSpeedReal", 30)
		EntFire("zeppelin_cage_model_rotor_smoke_s2", "Start")
		EntFire("zeppelin_sound", "Pitch", 75)
	}
	if (num == 2)
	{
		zeppelin_engines_status = "dead, dead, alive"
		
		zeppelin_bomb_deploy_point.KeyValueFromVector("origin", zeppelin_bomb_deploy_point.GetOrigin() + Vector(0, 512, 0))
		
		AddThinkToEnt(zeppelin, "Zeppelin_DescendStage2_Think")
		
		EntFire("zeppelin_model", "SetPlaybackRate", 0.6)
		EntFire("zeppelin_pathtrain", "SetSpeedReal", 20)
		EntFire("zeppelin_cage_model_rotor_smoke_s2", "Stop")
		EntFire("zeppelin_cage_model_rotor_smoke_s3", "Start")
		EntFire("zeppelin_sound", "Pitch", 50)
	}
	if (num == 3)
	{
		zeppelin_engines_status = "dead, dead, dead"
		
		AddThinkToEnt(zeppelin, "Zeppelin_CrashingSequence_Think")
		
		EntityOutputs.RemoveOutput(zeppelin_bomb_deploy_point, "OnPass", "player", "$PlaySoundToSelf", "vo/mvm_bomb_alerts06.mp3")
		EntityOutputs.RemoveOutput(zeppelin_bomb_deploy_point, "OnPass", "player", "$PlaySoundToSelf", "vo/mvm_bomb_alerts07.mp3")
		EntityOutputs.RemoveOutput(zeppelin_bomb_deploy_point, "OnPass", "player", "$PlaySoundToSelf", "mvm/mvm_tank_deploy.wav")
		
		for (local player_to_flash; player_to_flash = Entities.FindByClassnameWithin(player_to_flash, "player", zeppelin.GetOrigin(), 3000); )
		{
			if (player_to_flash == null) continue;
			if (IsPlayerABot(player_to_flash)) continue;
			
			ScreenFade(player_to_flash, 255, 140, 0, 50, 27.0, 0.0, 2)
		}
		
		for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
		{
			local player_to_sound_alarm = PlayerInstanceFromIndex(i)
			
			if (player_to_sound_alarm == null) continue
			if (IsPlayerABot(player_to_sound_alarm)) continue
			
			EntFireByHandle(player_to_sound_alarm, "RunScriptCode", "EmitSoundOn(`Zeppelin.CrashAlarm_P100`, self)", 0.0, null, null)
			EntFireByHandle(player_to_sound_alarm, "RunScriptCode", "EmitSoundOn(`Zeppelin.CrashAlarm_P105`, self)", 2.75, null, null)
			EntFireByHandle(player_to_sound_alarm, "RunScriptCode", "EmitSoundOn(`Zeppelin.CrashAlarm_P110`, self)", 5.5, null, null)
			EntFireByHandle(player_to_sound_alarm, "RunScriptCode", "EmitSoundOn(`Zeppelin.CrashAlarm_P115`, self)", 8.25, null, null)
			EntFireByHandle(player_to_sound_alarm, "RunScriptCode", "EmitSoundOn(`Zeppelin.CrashAlarm_P120`, self)", 11.0, null, null)
			EntFireByHandle(player_to_sound_alarm, "RunScriptCode", "EmitSoundOn(`Zeppelin.CrashAlarm_P125`, self)", 13.75, null, null)
			EntFireByHandle(player_to_sound_alarm, "RunScriptCode", "EmitSoundOn(`Zeppelin.CrashAlarm_P130`, self)", 16.5, null, null)
			EntFireByHandle(player_to_sound_alarm, "RunScriptCode", "EmitSoundOn(`Zeppelin.CrashAlarm_P135`, self)", 19.25, null, null)
			EntFireByHandle(player_to_sound_alarm, "RunScriptCode", "EmitSoundOn(`Zeppelin.CrashAlarm_P140`, self)", 22.0, null, null)
		}
		
		for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
		{
			local bot_to_pacify = PlayerInstanceFromIndex(i)
			
			if (bot_to_pacify == null) continue;
			if (!IsPlayerABot(bot_to_pacify)) continue;
			
			bot_to_pacify.AddCustomAttribute("cannot pick up intelligence", 1.0, -1.0)
			bot_to_pacify.DropFlag(true)
			bot_to_pacify.AddBotAttribute(8)
		}
		
		EntFire("player", "$RemoveCond", 107)
		EntFire("player", "$RemovePlayerAttribute", "voice pitch scale")
		EntFire("helium_crate*", "Kill")
		EntFire("crate_glow*", "Kill")
		EntFire("give_effects_trigger_*", "Kill")
	}
}

::Zeppelin_DescendStage1_Think <- function()
{
	if (self.GetOrigin().z > 1250)
	{
		self.KeyValueFromVector("origin", self.GetOrigin() + Vector (0, 0, -0.1))
	}
	if (self.GetOrigin().z < 1250)
	{
		NetProps.SetPropString(self, "m_iszScriptThinkFunction", "");
	}
	return -1
}

::Zeppelin_DescendStage2_Think <- function()
{
	if (self.GetOrigin().z > 1200)
	{
		self.KeyValueFromVector("origin", self.GetOrigin() + Vector (0, 0, -0.1))
	}
	if (self.GetOrigin().z < 1200)
	{
		NetProps.SetPropString(self, "m_iszScriptThinkFunction", "");
	}
	return -1
}

::Zeppelin_CrashingSequence_Think <- function()
{
	local x = RandomInt(-500, 500)
	local y = RandomInt(-1500, 1500)
	
	if (debug_zeppelin) ClientPrint(null,3,"" + self.GetOrigin());
	
	zeppelin_crash_frame = zeppelin_crash_frame + 1
	
	if (self.GetOrigin().z >= 0.0)
	{
		zeppelin.KeyValueFromVector("origin", self.GetOrigin() + Vector (0, 0, -0.8))
		zeppelin.SetAbsAngles(self.GetAngles() + QAngle(0.01, 0, 0))
	}
	if (zeppelin_crash_frame.tostring().slice(1, 3) == "00" || zeppelin_crash_frame.tostring().slice(1, 3) == "25" || zeppelin_crash_frame.tostring().slice(1, 3) == "50" || zeppelin_crash_frame.tostring().slice(1, 3) == "75")
	{
		DispatchParticleEffect("fluidSmokeExpl_ring_mvm", self.GetOrigin() + Vector(x, y, x), Vector(0, 0, 0))
		EntFire("player", "$PlaySoundToSelf", explosion_sound_table[RandomInt(1,8).tostring()], 0.0)
	}
	if (zeppelin_crash_frame >= 950)
	{
		zeppelin_crash_frame = 100
	}
	if (self.GetOrigin().z < 100.0)
	{
		for (local player_to_flash; player_to_flash = Entities.FindByClassname(player_to_flash, "player"); )
		{
			if (player_to_flash == null) continue;
			if (IsPlayerABot(player_to_flash)) continue;
			
			EntFireByHandle(player_to_flash, "RunScriptCode", "ScreenFade(self, 255, 140, 0, 255, 1.0, 0.0, 2)", 0.0, null, null)
			EntFireByHandle(player_to_flash, "RunScriptCode", "ScreenFade(self, 255, 140, 0, 255, 5.0, 0.0, 1)", 1.0, null, null)
		}
		
		EntFire("zeppelin_sound", "StopSound", null, 0.0)
	}
	if (self.GetOrigin().z < 0.0)
	{	
		EntFire("zeppelin_sound", "StopSound", null, 0.0)
		EntFire("player", "$PlaySoundToSelf", "=80|ambient/explosions/explode_6.wav", 0.0)
		EntFire("player", "$PlaySoundToSelf", "=80|ambient/explosions/explode_6.wav", 0.0)
		
		for (local player_to_hurt; player_to_hurt = Entities.FindByClassnameWithin(player_to_hurt, "player", self.GetOrigin(), 3000); )
		{
			if (player_to_hurt == null) continue;
			if (NetProps.GetPropInt(player_to_hurt, "m_lifeState") == 3) continue
			
			player_to_hurt.TakeDamage(10000.0, 64, null)
		}
		
		SpawnEntityFromTable("info_particle_system",
		{
			origin             = zeppelin.GetOrigin() + Vector(0, 1500, -300)
			start_active       = 1,
			effect_name        = "base_destroyed_smoke_doomsday"
		})
		
		for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
		{
			local bot_to_depacify = PlayerInstanceFromIndex(i)
			
			if (bot_to_depacify == null) continue;
			if (!IsPlayerABot(bot_to_depacify)) continue;
			
			bot_to_depacify.RemoveCustomAttribute("cannot pick up intelligence")
			bot_to_depacify.RemoveBotAttribute(8)
		}
		
		self.Kill()
	}
	
    return -1
}

::Zeppelin_BombDeployCheck <- function()
{
	if (debug_zeppelin) ClientPrint(null,3,"" + zeppelin_path_train.GetVelocity())
	zeppelin_tank_fall_accel_rate = 0
	if (zeppelin_engines_status == "alive, alive, alive" && zeppelin_path_train.GetVelocity().y == 0.0)
	{
		local destr_tank_1
		destr_tank_1 = Entities.FindByName(destr_tank_1, "zeppelin_engine_1_destructible")
		EntFire("zeppelin_cage_model_s1_floor", "Kill")
		zeppelin_tank_fall_accel_rate = 0
		AddThinkToEnt(destr_tank_1, "Zeppelin_DropTankIntoHatch_Think")
		EntFire("player", "$PlaySoundToSelf", "physics/metal/metal_chainlink_impact_hard" + RandomInt(1,3) + ".wav", -1.0)
	}
	if (zeppelin_engines_status == "dead, alive, alive" && zeppelin_path_train.GetVelocity().y == 0.0)
	{
		local destr_tank_2
		destr_tank_2 = Entities.FindByName(destr_tank_2, "zeppelin_engine_2_destructible")
		EntFire("zeppelin_cage_model_s2_floor", "Kill")
		AddThinkToEnt(destr_tank_2, "Zeppelin_DropTankIntoHatch_Think")
		EntFire("player", "$PlaySoundToSelf", "physics/metal/metal_chainlink_impact_hard" + RandomInt(1,3) + ".wav", -1.0)
	}
	if (zeppelin_engines_status == "dead, dead, alive" && zeppelin_path_train.GetVelocity().y == 0.0)
	{
		local destr_tank_3
		destr_tank_3 = Entities.FindByName(destr_tank_3, "zeppelin_engine_3_destructible")
		EntFire("zeppelin_cage_model_s3_floor", "Kill")
		zeppelin_tank_fall_accel_rate = 0
		AddThinkToEnt(destr_tank_3, "Zeppelin_DropTankIntoHatch_Think")
		EntFire("player", "$PlaySoundToSelf", "physics/metal/metal_chainlink_impact_hard" + RandomInt(1,3) + ".wav", -1.0)
	}
	
}

::Zeppelin_DropTankIntoHatch_Think <- function()
{
	if (self.GetOrigin().z >= -400.0)
	{
		zeppelin_tank_fall_accel_rate = zeppelin_tank_fall_accel_rate - 0.15
		
		self.KeyValueFromVector("origin", self.GetOrigin() + Vector (0, 0, zeppelin_tank_fall_accel_rate))
	}
	if (self.GetOrigin().z < -400.0)
	{
		EntFire("boss_deploy_relay", "Trigger")
		self.Kill()
	}
	
	return -1
}

::Zeppelin_SpawnHeliumCrates_Think <- function()
{
	if (debug_zeppelin) ClientPrint(null,3,"spawn helium think active\n");
	
	if (zeppelin_engines_status != "dead, dead, dead")
	{
		local pick = RandomInt(1, 8)
		
		local x = 0
		local y = 0
		local z = 0
		
		if (pick == 1)
		{
			x = 0
			y = -1000
			z = -175
		}
		if (pick == 2)
		{
			x = -500
			y = 250
			z = -275
		}
		if (pick == 3)
		{
			x = 500
			y = 250
			z = -275
		}
		if (pick == 4)
		{
			x = -600
			y = -1700
			z = -360
		}
		if (pick == 5)
		{
			x = -100
			y = -2600
			z = 0
		}
		if (pick == 6)
		{
			x = 1000
			y = -2600
			z = 0
		}
		if (pick == 7)
		{
			x = 400
			y = -2600
			z = -370
		}
		if (pick == 8)
		{
			x = 1100
			y = 0
			z = -410
		}
		
		for (local helium_crate; helium_crate = Entities.FindInSphere(helium_crate, Vector(x, y, z), 32); )
		{
			if (helium_crate.GetModelName() == "models/props_hydro/barrel_crate_half.mdl")
			{
				helium_crate.Kill()
			}
		}
		
		local the_helium_crate = SpawnEntityFromTable("prop_dynamic",
		{
			targetname            = "helium_crate_" + helium_crate_number
			origin                = Vector(x, y, z)
			model           	  = "models/props_hydro/barrel_crate_half.mdl"
		})
		
		local the_helium_crate_glow = SpawnEntityFromTable("tf_glow",
		{
			targetname            = "crate_glow_" + helium_crate_number
			origin                = Vector(x, y, z)
			target           	  = "helium_crate_" + helium_crate_number
			GlowColor             = "184 56 59 255"
		})
		
		local the_helium_crate_trigger = SpawnEntityFromTable("trigger_multiple", 
		{
			targetname = "give_effects_trigger_" + helium_crate_number
			spawnflags = 1
			origin     = Vector(x, y, z)
			filtername = "filter_redteam"
		})
		
		the_helium_crate_trigger.KeyValueFromInt("solid", 2)
		the_helium_crate_trigger.KeyValueFromString("mins", "-64 -64 -64")
		the_helium_crate_trigger.KeyValueFromString("maxs", "64 64 64")
		
		EntityOutputs.AddOutput(the_helium_crate_trigger, "OnStartTouch", "!activator", "AddOutput", "basevelocity 0 0 800", 0.0, -1)
		EntityOutputs.AddOutput(the_helium_crate_trigger, "OnStartTouch", "!activator", "$AddCond", "107 12", 1.0, -1)
		EntityOutputs.AddOutput(the_helium_crate_trigger, "OnStartTouch", "!activator", "$AddPlayerAttribute", "voice pitch scale|2", 0.0, -1)
		EntityOutputs.AddOutput(the_helium_crate_trigger, "OnStartTouch", "!activator", "$RemovePlayerAttribute", "voice pitch scale", 12.0, -1)
		
		EntityOutputs.AddOutput(the_helium_crate_trigger, "OnStartTouch", "crate_glow_" + helium_crate_number, "Kill", null, 0.0, -1)
		EntityOutputs.AddOutput(the_helium_crate_trigger, "OnStartTouch", "helium_crate_" + helium_crate_number, "Kill", null, 0.0, -1)
		EntityOutputs.AddOutput(the_helium_crate_trigger, "OnStartTouch", "give_effects_trigger_" + helium_crate_number, "Kill", null, 0.0, -1)
		
		if (helium_crate_number == 3)
		{
			for (local i = 1; i <= Constants.Server.MAX_PLAYERS; i++)
			{
				local player = PlayerInstanceFromIndex(i)
				
				if (player == null) continue;
				if (IsPlayerABot(player)) continue;
				
				EntFireByHandle(player, "SetScriptOverlayMaterial","zeppelin_fight_tip_overlay", 0.0, null, null);
				EntFireByHandle(player, "SetScriptOverlayMaterial","", 8.0, null, null);
			}
		}
		
		if (helium_crate_number >= 3 && helium_crate_number <= 5)
		{
			SendGlobalGameEvent("show_annotation", 
			{
				text = "Helium crate!"
				worldPosX = x
				worldPosY = y
				worldPosZ = z
				play_sound = "misc/null.wav"
				show_distance = true
				show_effect = true
				lifetime = 5
			})
		}
		
		helium_crate_number = helium_crate_number + 1
		
		return 8
	}
	
	else return 3600
}

::RotateHeliumCrates_Think <- function()
{
	if (zeppelin_engines_status != "dead, dead, dead")
	{
		for (local helium_crate; helium_crate = Entities.FindByName(helium_crate, "helium_crate_*"); )
		{
			helium_crate.SetAbsAngles(helium_crate.GetAngles() + QAngle(0, 1, 0))
		}
		
		return -1
	}
	
	else return 3600
}
	

/////////////////////////////////// ZEPPELIN BOSS ///////////////////////////////////
/////////////////////////////////// MISCELLANEOUS ///////////////////////////////////

::SetUpInWaveHUD <- function()
{
	if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 1)
	{	
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$3", "0") // jumping sandman support
	}
	
	if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 2)
	{	
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$5", "0") // soldier support
		
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassCounts$9", "1") // air raid support
		EntFire("tf_objective_resource", "$SetProp$m_iszMannVsMachineWaveClassNames$9", "plane_lite_blu") // air raid support
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$9", "0") // air raid support
	}
	
	if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 3)
	{	
		local think_havedefendersbeenpushed = SpawnEntityFromTable("logic_relay", {
			targetname = "defenderspushedcheck"
		})
		AddThinkToEnt(think_havedefendersbeenpushed, "HaveDefendersBeenPushed_Think")
		
		local think_teleskylight = SpawnEntityFromTable("logic_relay", {
			targetname = "teleskylight"
		})
		AddThinkToEnt(think_teleskylight, "TeleSkyLight_Think")
		
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassCounts$10", "1") // suppply drop tele support
		EntFire("tf_objective_resource", "$SetProp$m_iszMannVsMachineWaveClassNames$10", "teleporter") // suppply drop tele support
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$10", "0") // suppply drop tele support
		
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassCounts$11", "1") // suppply drop crate support
		EntFire("tf_objective_resource", "$SetProp$m_iszMannVsMachineWaveClassNames$11", "helicopter_blue_nys_nomiplod") // suppply drop crate support
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$11", "0") // suppply drop crate support
	}
	
	if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 4)
	{
		local think_havedefendersbeenpushed = SpawnEntityFromTable("logic_relay", {
			targetname = "defenderspushedcheck"
		})
		AddThinkToEnt(think_havedefendersbeenpushed, "HaveDefendersBeenPushed_Think")
		
		local think_teleskylight = SpawnEntityFromTable("logic_relay", {
			targetname = "teleskylight"
		})
		AddThinkToEnt(think_teleskylight, "TeleSkyLight_Think")
		
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassCounts$9", "1")
		EntFire("tf_objective_resource", "$SetProp$m_iszMannVsMachineWaveClassNames$9", "teleporter")
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$9", "0")
		
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassCounts$10", "1")
		EntFire("tf_objective_resource", "$SetProp$m_iszMannVsMachineWaveClassNames$10", "plane_lite_blu")
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$10", "0")
	}
	
	if (NetProps.GetPropInt(objective_resource_entity, "m_nMannVsMachineWaveCount") == 5)
	{	
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$2", "0") // demoknight support
		EntFire("tf_objective_resource", "$SetProp$m_nMannVsMachineWaveClassFlags$6", "0") // pyro support
	}
}

::HaveDefendersBeenPushed_Think <- function()
{
	// ClientPrint(null,3,"" + teleport_status)
	
	if (teleport_status == "disabled") return
	if (teleport_status == "inactive")
	{
		NetProps.SetPropInt(tele_spot_1, "m_nSkin", 2)
		NetProps.SetPropInt(tele_spot_2, "m_nSkin", 2)
		NetProps.SetPropInt(tele_spot_3, "m_nSkin", 2)
		NetProps.SetPropInt(tele_spot_4, "m_nSkin", 2)
		NetProps.SetPropInt(tele_spot_5, "m_nSkin", 2)
		NetProps.SetPropInt(tele_spot_6, "m_nSkin", 2)
		NetProps.SetPropInt(tele_spot_7, "m_nSkin", 2)
		
		NetProps.SetPropFloat(tele_spot_1, "m_flPlaybackRate", 0.0)
		NetProps.SetPropFloat(tele_spot_2, "m_flPlaybackRate", 0.0)
		NetProps.SetPropFloat(tele_spot_3, "m_flPlaybackRate", 0.0)
		NetProps.SetPropFloat(tele_spot_4, "m_flPlaybackRate", 0.0)
		NetProps.SetPropFloat(tele_spot_5, "m_flPlaybackRate", 0.0)
		NetProps.SetPropFloat(tele_spot_6, "m_flPlaybackRate", 0.0)
		NetProps.SetPropFloat(tele_spot_7, "m_flPlaybackRate", 0.0)
	}
	if (teleport_status == "active")
	{
		if (intel_entity.GetOrigin().y < -2500.0)
		{	
			NetProps.SetPropInt(tele_spot_1, "m_nSkin", 1)
			NetProps.SetPropInt(tele_spot_2, "m_nSkin", 1)
			NetProps.SetPropInt(tele_spot_3, "m_nSkin", 1)
			NetProps.SetPropInt(tele_spot_4, "m_nSkin", 1)
			NetProps.SetPropInt(tele_spot_5, "m_nSkin", 2)
			NetProps.SetPropInt(tele_spot_6, "m_nSkin", 1)
			NetProps.SetPropInt(tele_spot_7, "m_nSkin", 2)
			
			NetProps.SetPropFloat(tele_spot_1, "m_flPlaybackRate", 1.0)
			NetProps.SetPropFloat(tele_spot_2, "m_flPlaybackRate", 1.0)
			NetProps.SetPropFloat(tele_spot_3, "m_flPlaybackRate", 1.0)
			NetProps.SetPropFloat(tele_spot_4, "m_flPlaybackRate", 1.0)
			NetProps.SetPropFloat(tele_spot_5, "m_flPlaybackRate", 0.0)
			NetProps.SetPropFloat(tele_spot_6, "m_flPlaybackRate", 1.0)
			NetProps.SetPropFloat(tele_spot_7, "m_flPlaybackRate", 0.0)
			
			// ClientPrint(null,3,"not pushed/n");
		}
		else if (intel_entity.GetOrigin().y < -1200.0)
		{
			NetProps.SetPropInt(tele_spot_1, "m_nSkin", 1)
			NetProps.SetPropInt(tele_spot_2, "m_nSkin", 2)
			NetProps.SetPropInt(tele_spot_3, "m_nSkin", 2)
			NetProps.SetPropInt(tele_spot_4, "m_nSkin", 1)
			NetProps.SetPropInt(tele_spot_5, "m_nSkin", 2)
			NetProps.SetPropInt(tele_spot_6, "m_nSkin", 1)
			NetProps.SetPropInt(tele_spot_7, "m_nSkin", 2)
			
			NetProps.SetPropFloat(tele_spot_1, "m_flPlaybackRate", 1.0)
			NetProps.SetPropFloat(tele_spot_2, "m_flPlaybackRate", 0.0)
			NetProps.SetPropFloat(tele_spot_3, "m_flPlaybackRate", 0.0)
			NetProps.SetPropFloat(tele_spot_4, "m_flPlaybackRate", 1.0)
			NetProps.SetPropFloat(tele_spot_5, "m_flPlaybackRate", 0.0)
			NetProps.SetPropFloat(tele_spot_6, "m_flPlaybackRate", 1.0)
			NetProps.SetPropFloat(tele_spot_7, "m_flPlaybackRate", 0.0)
			
			// ClientPrint(null,3,"pushed to tunnel/n");
		}
		else
		{
			NetProps.SetPropInt(tele_spot_1, "m_nSkin", 2)
			NetProps.SetPropInt(tele_spot_2, "m_nSkin", 2)
			NetProps.SetPropInt(tele_spot_3, "m_nSkin", 2)
			NetProps.SetPropInt(tele_spot_4, "m_nSkin", 2)
			NetProps.SetPropInt(tele_spot_5, "m_nSkin", 1)
			NetProps.SetPropInt(tele_spot_6, "m_nSkin", 2)
			NetProps.SetPropInt(tele_spot_7, "m_nSkin", 1)
			
			NetProps.SetPropFloat(tele_spot_1, "m_flPlaybackRate", 0.0)
			NetProps.SetPropFloat(tele_spot_2, "m_flPlaybackRate", 0.0)
			NetProps.SetPropFloat(tele_spot_3, "m_flPlaybackRate", 0.0)
			NetProps.SetPropFloat(tele_spot_4, "m_flPlaybackRate", 0.0)
			NetProps.SetPropFloat(tele_spot_5, "m_flPlaybackRate", 1.0)
			NetProps.SetPropFloat(tele_spot_6, "m_flPlaybackRate", 0.0)
			NetProps.SetPropFloat(tele_spot_7, "m_flPlaybackRate", 1.0)
			
			// ClientPrint(null,3,"pushed to incline/n");
		}
	}
	
	return
}

::TeleSkyLight_Think <- function()
{
	// ClientPrint(null,3,"" + teleport_status)
	
	if (teleport_status != "active") return
	
	else
	{
		for (local active_telespot; active_telespot = Entities.FindByName(active_telespot, "telespot*"); )
		{
			if (NetProps.GetPropInt(active_telespot, "m_nSkin") == 1) DispatchParticleEffect("teleported_mvm_bot", active_telespot.GetOrigin(), Vector(0, 90, 0))
		}
	}
	
	return 5 // the amount of time the particle runs for
}

::CrateCrushPlayers <- function()
{
	for (local entity_to_crush; entity_to_crush = Entities.FindInSphere(entity_to_crush, self.GetOrigin(), 100); )
	{
		entity_to_crush.TakeDamage(1000.0, 64, self)
	}
	return
}

::SetUpRain <- function()
{	
	local rain_sfx = SpawnEntityFromTable("ambient_generic", 
	{
		health       = 10
		spawnflags   = 1
		radius       = 9999
		pitchstart   = 100
		pitch        = 100
		message      = "ambient/rain.wav"
	})
	
	EntFireByHandle(rain_sfx, "PlaySound", null, 0.0, null, null)
	
	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, 2400, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, 1900, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, 1400, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, 900, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, 400, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, -100, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, -600, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, -1100, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, -1600, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, -2100, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, -2600, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, -3100, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(-500, -3600, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, 2400, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, 1900, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, 1400, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, 900, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, 400, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, -100, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, -600, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, -1100, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, -1600, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, -2100, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, -2600, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, -3100, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(100, -3600, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	// local handle_rain = SpawnEntityFromTable("info_particle_system", 
	// {
		// origin       = Vector(700, 2400, 1000)
		// start_active = 1
		// effect_name  = "env_rain_001"
	// })

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(700, 1900, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(700, 1400, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(700, 900, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(700, 400, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(700, -100, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(700, -600, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(700, -1100, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(700, -1600, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(700, -2100, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(700, -2600, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(700, -3100, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_rain = SpawnEntityFromTable("info_particle_system", 
	{
		origin       = Vector(700, -3600, 1000)
		start_active = 1
		effect_name  = "env_rain_001"
	})

	local handle_color_change_test = SpawnEntityFromTable("color_correction", 
	{
		StartDisabled    = 0
		maxfalloff       = -1
		minfalloff       = -1
		filename         = "download/darker_color_correction.raw"
	}) 
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// FUNCTIONS ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// UNUSED ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// local teledestination_1 = Vector(-500, 200, -250) // a1
// local teledestination_2 = Vector(1100, 0, -400) // a1
// local teledestination_3 = Vector(500, 200, -250) // a1
// local teledestination_4 = Vector(-100, -1400, -150) // a2
// local teledestination_5 = Vector(500, -700, -150) // a2
// local teledestination_6 = Vector(1000, -2000, -400) // a3
// local teledestination_7 = Vector(-600, -1700, -380) // a3

// local trigger_pick = null
// local trigger_1_picks = RandomInt(1, 3)
// local trigger_2_or_3_picks = RandomInt(1, 2)

// ::SupplyDropTeles_SetUpTeleporterTriggers <- function()
// {
	// teledest_1_trigger = SpawnEntityFromTable("trigger_multiple", 
	// {
		// targetname = "teledestination_trigger_1"
		// spawnflags = 1
		// origin     = Vector(0, 0, 0)
		// filtername = "filter_redteam"
	// })

	// teledest_2_trigger = SpawnEntityFromTable("trigger_multiple", 
	// {
		// targetname = "teledestination_trigger_2"
		// spawnflags = 1
		// origin     = Vector(0, -1000, 0)
		// filtername = "filter_redteam"
	// })

	// teledest_3_trigger = SpawnEntityFromTable("trigger_multiple", 
	// {
		// targetname = "teledestination_trigger_3"
		// spawnflags = 1
		// origin     = Vector(0, -2000, 0)
		// filtername = "filter_redteam"
	// })

	// teledest_1_trigger.KeyValueFromInt("solid", 2)
	// teledest_1_trigger.KeyValueFromString("mins", "-1500 -800 -1500")
	// teledest_1_trigger.KeyValueFromString("maxs", "1500 500 1500")

	// teledest_2_trigger.KeyValueFromInt("solid", 2)
	// teledest_2_trigger.KeyValueFromString("mins", "-1500 -800 -1500")
	// teledest_2_trigger.KeyValueFromString("maxs", "1500 700 1500")

	// teledest_3_trigger.KeyValueFromInt("solid", 2)
	// teledest_3_trigger.KeyValueFromString("mins", "-1500 -500 -1500")
	// teledest_3_trigger.KeyValueFromString("maxs", "1500 700 1500")
// }

// if (Entities.FindByName(null, "on_teledestination_trigger_1") != null && Entities.FindByName(null, "on_teledestination_trigger_2") != null && Entities.FindByName(null, "on_teledestination_trigger_3") != null)
// {
	// trigger_pick = RandomInt(1, 3)
// }
// if (Entities.FindByName(null, "on_teledestination_trigger_1") != null && Entities.FindByName(null, "on_teledestination_trigger_2") != null && Entities.FindByName(null, "on_teledestination_trigger_3") == null)
// {
	// trigger_pick = RandomInt(4, 5)
// }
// if (Entities.FindByName(null, "on_teledestination_trigger_1") != null && Entities.FindByName(null, "on_teledestination_trigger_2") == null && Entities.FindByName(null, "on_teledestination_trigger_3") != null)
// {
	// trigger_pick = RandomInt(6, 7)
// }
// if (Entities.FindByName(null, "on_teledestination_trigger_1") == null && Entities.FindByName(null, "on_teledestination_trigger_2") != null && Entities.FindByName(null, "on_teledestination_trigger_3") != null)
// {
	// trigger_pick = RandomInt(8, 9)
// }
// if (Entities.FindByName(null, "on_teledestination_trigger_1") != null && Entities.FindByName(null, "on_teledestination_trigger_2") == null && Entities.FindByName(null, "on_teledestination_trigger_3") == null)
// {
	// trigger_pick = 10
// }
// if (Entities.FindByName(null, "on_teledestination_trigger_1") == null && Entities.FindByName(null, "on_teledestination_trigger_2") != null && Entities.FindByName(null, "on_teledestination_trigger_3") == null)
// {
	// trigger_pick = 11
// }
// if (Entities.FindByName(null, "on_teledestination_trigger_1") == null && Entities.FindByName(null, "on_teledestination_trigger_2") == null && Entities.FindByName(null, "on_teledestination_trigger_3") != null)
// {
	// trigger_pick = 12
// }
// if (debug_supplydrop_teles) ClientPrint(null,3,"the pick is " + trigger_pick)
// if (debug_supplydrop_teles) ClientPrint(null,3,"" + Entities.FindByName(null, "on_teledestination_trigger_1") + Entities.FindByName(null, "on_teledestination_trigger_2") + Entities.FindByName(null, "on_teledestination_trigger_3"))
// if (trigger_pick == 1 || trigger_pick == 4 || trigger_pick == 6 || trigger_pick == 10)
// {
	// if (trigger_1_picks == 1)
	// {
		// self.Teleport(true, teledestination_1, false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		// if (debug_supplydrop_teles) ClientPrint(null,3,"successfully teleported bot to dest 1\n")
	// }
	// if (trigger_1_picks == 2)
	// {
		// self.Teleport(true, teledestination_2, false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		// if (debug_supplydrop_teles) ClientPrint(null,3,"successfully teleported bot to dest 2\n")
	// }
	// if (trigger_1_picks == 3)
	// {
		// self.Teleport(true, teledestination_3, false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		// if (debug_supplydrop_teles) ClientPrint(null,3,"successfully teleported bot to dest 3\n")
	// }
// }
// if (trigger_pick == 2 || trigger_pick == 5 || trigger_pick == 8 || trigger_pick == 11)
// {
	// if (trigger_2_or_3_picks == 1)
	// {
		// self.Teleport(true, teledestination_4, false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		// if (debug_supplydrop_teles) ClientPrint(null,3,"successfully teleported bot to dest 4\n")
	// }
	// if (trigger_2_or_3_picks == 2)
	// {
		// self.Teleport(true, teledestination_5, false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		// if (debug_supplydrop_teles) ClientPrint(null,3,"successfully teleported bot to dest 5\n")
	// }
// }
// if (trigger_pick == 3 || trigger_pick == 7 || trigger_pick == 9 || trigger_pick == 12)
// {
	// if (trigger_2_or_3_picks == 1)
	// {
		// self.Teleport(true, teledestination_6, false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		// if (debug_supplydrop_teles) ClientPrint(null,3,"successfully teleported bot to dest 6\n")
	// }
	// if (trigger_2_or_3_picks == 2)
	// {
		// self.Teleport(true, teledestination_7, false, QAngle(0, 0, 0), false, Vector(0, 0, 0))
		// if (debug_supplydrop_teles) ClientPrint(null,3,"successfully teleported bot to dest 7\n")
	// }
// }

// local zeppelin_crashing_alarm = SpawnEntityFromTable("ambient_generic", 
// {
	// targetname   = "zeppelin_crashing_alarm"
	// health       = 10
	// spawnflags   = 33
	// radius       = 99999
	// pitchstart   = 100
	// pitch        = 100
	// message      = "ambient/alarms/doomsday_lift_alarm.wav"
// })

// EntFireByHandle(zeppelin, "RunScriptCode", "self.EmitSound(`Zeppelin.CrashAlarm_P100`)", 0.0, null, null)
// EntFireByHandle(zeppelin, "RunScriptCode", "self.EmitSound(`Zeppelin.CrashAlarm_P105`)", 2.75, null, null)
// EntFireByHandle(zeppelin, "RunScriptCode", "self.EmitSound(`Zeppelin.CrashAlarm_P110`)", 5.5, null, null)
// EntFireByHandle(zeppelin, "RunScriptCode", "self.EmitSound(`Zeppelin.CrashAlarm_P115`)", 8.25, null, null)
// EntFireByHandle(zeppelin, "RunScriptCode", "self.EmitSound(`Zeppelin.CrashAlarm_P120`)", 11.0, null, null)
// EntFireByHandle(zeppelin, "RunScriptCode", "self.EmitSound(`Zeppelin.CrashAlarm_P125`)", 13.75, null, null)
// EntFireByHandle(zeppelin, "RunScriptCode", "self.EmitSound(`Zeppelin.CrashAlarm_P130`)", 16.5, null, null)
// EntFireByHandle(zeppelin, "RunScriptCode", "self.EmitSound(`Zeppelin.CrashAlarm_P135`)", 19.25, null, null)
// EntFireByHandle(zeppelin, "RunScriptCode", "self.EmitSound(`Zeppelin.CrashAlarm_P140`)", 22.0, null, null)

// EntFire("zeppelin_crashing_alarm", "PlaySound", null, 0.0)
// EntFire("zeppelin_crashing_alarm", "Pitch", 105, 2.75)
// EntFire("zeppelin_crashing_alarm", "Pitch", 110, 5.5)
// EntFire("zeppelin_crashing_alarm", "Pitch", 115, 8.25)
// EntFire("zeppelin_crashing_alarm", "Pitch", 120, 11.0)
// EntFire("zeppelin_crashing_alarm", "Pitch", 125, 13.75)
// EntFire("zeppelin_crashing_alarm", "Pitch", 130, 16.5)
// EntFire("zeppelin_crashing_alarm", "Pitch", 135, 19.25)
// EntFire("zeppelin_crashing_alarm", "Pitch", 140, 22.0)

// EntityOutputs.AddOutput(teledest_1_trigger, "OnStartTouchAll", "gamerules", "RunScriptCode", "TeleTriggerCoordinator()", 0.0, -1)
// EntityOutputs.AddOutput(teledest_1_trigger, "OnEndTouchAll", "gamerules", "RunScriptCode", "TeleTriggerCoordinator()", 0.0, -1)

// EntityOutputs.AddOutput(teledest_2_trigger, "OnStartTouchAll", "gamerules", "RunScriptCode", "TeleTriggerCoordinator()", 0.0, -1)
// EntityOutputs.AddOutput(teledest_2_trigger, "OnEndTouchAll", "gamerules", "RunScriptCode", "TeleTriggerCoordinator()", 0.0, -1)

// EntityOutputs.AddOutput(teledest_3_trigger, "OnStartTouchAll", "gamerules", "RunScriptCode", "TeleTriggerCoordinator()", 0.0, -1)
// EntityOutputs.AddOutput(teledest_3_trigger, "OnEndTouchAll", "gamerules", "RunScriptCode", "TeleTriggerCoordinator()", 0.0, -1)

// if (defenders_pushed_status == "not_pushed")
// {
	// NetProps.SetPropString(teledest_1_trigger, "m_iName", "on_teledestination_trigger_1")
	// NetProps.SetPropString(teledest_2_trigger, "m_iName", "on_teledestination_trigger_2")
	// NetProps.SetPropString(teledest_3_trigger, "m_iName", "off_teledestination_trigger_3")
// }

// if (defenders_pushed_status == "pushed_to_tunnel_entrance")
// {
	// NetProps.SetPropString(teledest_1_trigger, "m_iName", "on_teledestination_trigger_1")
	// NetProps.SetPropString(teledest_2_trigger, "m_iName", "off_teledestination_trigger_2")
	// NetProps.SetPropString(teledest_3_trigger, "m_iName", "off_teledestination_trigger_3")
// }

// if (defenders_pushed_status == "pushed_to_incline")
// {
	// NetProps.SetPropString(teledest_1_trigger, "m_iName", "off_teledestination_trigger_1")
	// NetProps.SetPropString(teledest_2_trigger, "m_iName", "off_teledestination_trigger_2")
	// NetProps.SetPropString(teledest_3_trigger, "m_iName", "on_teledestination_trigger_3")
// }

// AddThinkToEnt(cur_zeppelin_tank, "Zeppelin_GetCurrentOrigin_Think")

// ::Zeppelin_GetCurrentOrigin_Think <- function()
// {
	// cur_zeppelin_tank_origin = self.GetOrigin()
	// return
// }

// local enginetank_bomb = SpawnEntityFromTable("prop_physics_multiplayer",
// {
	// origin                  = cur_zeppelin_tank_origin
	// targetname              = "zeppelin_enginetank_bomb_" + num,
	// model                   = "models/weapons/w_models/w_cannonball.mdl"
	// modelscale              = 2
	// massscale               = 50
	// spawnflags              = 0
// })

// enginetank_bomb_explosion_timer = -1
// AddThinkToEnt(enginetank_bomb, "ExplodeIn3Seconds")

// ::Zeppelin_DestroyedTankPayloadExplosion_Think <- function()
// {
	// enginetank_bomb_explosion_timer = enginetank_bomb_explosion_timer + 1
	// if (enginetank_bomb_explosion_timer == 3)
	// {
        // DispatchParticleEffect("fluidSmokeExpl_ring_mvm", self.GetOrigin(), Vector(0, 0, 0))
		// local explosion = SpawnEntityFromTable("tf_point_weapon_mimic",
		// {
			// origin               = self.GetOrigin(),
			// angles               = QAngle(90, 0, 0)
			// TeamNum              = 5,
			// SplashRadius         = 500
			// Damage               = 600
			// WeaponType           = 0
		    // speedmin             = 1000
		    // speedmax             = 1000
		// })
		// EntFireByHandle(explosion, "FireOnce", null, 0.0, null, null);
		// EntFireByHandle(explosion, "Kill", null, 0.1, null, null);
		// EntFireByHandle(self, "Kill", null, 0.1, null, null);
	// }
	// return 1
// }

// ::SupplyDropTeles_TeleTriggerCoordinator <- function()
// {
	// if (defenders_pushed_status == "not_pushed")
	// {
		// NetProps.SetPropString(teledest_1_trigger, "m_iName", "on_teledestination_trigger_1")
		// NetProps.SetPropString(teledest_2_trigger, "m_iName", "on_teledestination_trigger_2")
		// NetProps.SetPropString(teledest_3_trigger, "m_iName", "off_teledestination_trigger_3")
	// }
	
	// if (defenders_pushed_status == "pushed_to_tunnel_entrance")
	// {
		// NetProps.SetPropString(teledest_1_trigger, "m_iName", "on_teledestination_trigger_1")
		// NetProps.SetPropString(teledest_2_trigger, "m_iName", "off_teledestination_trigger_2")
		// NetProps.SetPropString(teledest_3_trigger, "m_iName", "off_teledestination_trigger_3")
	// }
	
	// if (defenders_pushed_status == "pushed_to_incline")
	// {
		// NetProps.SetPropString(teledest_1_trigger, "m_iName", "off_teledestination_trigger_1")
		// NetProps.SetPropString(teledest_2_trigger, "m_iName", "off_teledestination_trigger_2")
		// NetProps.SetPropString(teledest_3_trigger, "m_iName", "on_teledestination_trigger_3")
	// }
// }
// SpawnEntityFromTable("prop_dynamic",
// {
	// origin        = Vector(-500, 200, -280)
	// model         = "models/props_mvm/robot_spawnpoint.mdl"
// })

// SpawnEntityFromTable("prop_dynamic",
// {
	// origin        = Vector(-100, -1400, -180)
	// model         = "models/props_mvm/robot_spawnpoint.mdl"
// })

// SpawnEntityFromTable("prop_dynamic",
// {
	// origin        = Vector(500, -700, -190)
	// model         = "models/props_mvm/robot_spawnpoint.mdl"
// })

// SpawnEntityFromTable("prop_dynamic",
// {
	// origin        = Vector(500, 200, -290)
	// model         = "models/props_mvm/robot_spawnpoint.mdl"
// })

// SpawnEntityFromTable("prop_dynamic",
// {
	// origin        = Vector(1000, -2000, -410)
	// model         = "models/props_mvm/robot_spawnpoint.mdl"
// })

// SpawnEntityFromTable("prop_dynamic",
// {
	// origin        = Vector(1100, 0, -420)
	// model         = "models/props_mvm/robot_spawnpoint.mdl"
// })

// local plane_template_ent6 = SpawnEntityFromTable("prop_dynamic",
// {
	// targetname              = gunny,
	// origin                  = plane_template_ent4.GetOrigin() + Vector(0, 0, 150) - Vector(125, 0, 0),
	// model                   = "models/props_frontline/tank_turret.mdl",
	// angles                  = "QAngle(0, 0, -180)"
// })

// local player = ""
// local players_angles = ""

// function OnGameEvent_player_spawn(params)
// {
   // ClientPrint(null,3,"someone spawned\n");
// }

// function OnGameEvent_post_inventory_application(params)
// {
   // player = GetPlayerFromUserID(params.userid);
   // players_angles = player.GetAbsAngles()
	// if (player != null)
	// {
		// EntFireByHandle(player, "$DisplayTextChat","you are " + players_angles, 0.0, null, null);
	// }
// }

// local aircannon_sentry = SpawnEntityFromTable("prop_dynamic",
// {
	// targetname      = "friend",
	// model           = "models/buildables/sentry2.mdl"
	// origin          = Vector(-150, -2650, 100),
	// angles          = Vector(0, 0, 0)
// })

// AddThinkToEnt(aircannon_sentry, "IgnoreEnemies")

// ::IgnoreEnemies <- function()
// {
	// NetProps.SetPropVector(self, "m_angRotation", players_angles);
	// ClientPrint(null,3,""+NetProps.GetPropVector(self, "m_angRotation"));
	// return;
// }

// ClientPrint(null,3,player.GetTeam);

// local aircannon_1_prop = SpawnEntityFromTable("prop_dynamic", 
// {
	// origin 		 = Vector(-150, -2650, 100),
	// model        = "models/turret/turret.mdl"
// })

// local aircannon_1_trigger = SpawnEntityFromTable("trigger_multiple", 
// {
	// origin 		 = Vector(-150, -2650, 100),
	// mins         = Vector (-50, -50, -50),
	// maxs         = Vector (50, 50, 50)
// })

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// UNUSED ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// DEBUGGING ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if (debug)
{
	function OnGameEvent_player_say(params)
	{
		local player = GetPlayerFromUserID(params.userid)

		if (params.text == "1")
		{
			player.SetScriptOverlayMaterial("airraid_warning_overlay")
		}
		if (params.text == "2")
		{
			player.SetScriptOverlayMaterial("supplydrop_tele_warning_overlay")
		}
		if (params.text == "3")
		{
			player.SetScriptOverlayMaterial("supplydrop_crate_warning_overlay")
		}
		if (params.text == "4")
		{
			player.SetScriptOverlayMaterial("zeppelin_fight_tip_overlay")
		}
		if (params.text == "5")
		{
			player.SetScriptOverlayMaterial(null)
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

__CollectGameEventCallbacks(this)