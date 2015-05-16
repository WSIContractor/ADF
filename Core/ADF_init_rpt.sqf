/****************************************************************
ARMA Mission Development Framework
ADF version: 1.39 / MAY 2015

Script: Mission init / Init reporting
Author: Whiztler
Script version: 1.01

Game type: n/a
File: ADF_init_rpt.sqf

****************************************************************/

if (!isServer) exitWith {}; // Server only

// Init
ADF_log_CntHC = 0;
ADF_log_rptMods = "";
if !(isNil "ADF_HC1") then {ADF_log_CntHC = ADF_log_CntHC + 1};
if !(isNil "ADF_HC2") then {ADF_log_CntHC = ADF_log_CntHC + 1};
if !(isNil "ADF_HC3") then {ADF_log_CntHC = ADF_log_CntHC + 1};
if (isMultiplayer) then {ADF_log_pUnits = playableUnits;} else {ADF_log_pUnits = switchableUnits};
if (((count allUnits)-(count ADF_log_pUnits)) < 0) then {ADF_log_aiUnits = 0} else {ADF_log_aiUnits = ((count allUnits)-(count ADF_log_pUnits))};
if (ADF_mod_CBA) then {ADF_log_rptMods = ADF_log_rptMods + "CBA A3";};
if (ADF_mod_ACRE) then {ADF_log_rptMods = ADF_log_rptMods + ", ACRE2";};
if (ADF_mod_TFAR) then {ADF_log_rptMods = ADF_log_rptMods + ", TFAR";};
if (ADF_mod_CTAB) then {ADF_log_rptMods = ADF_log_rptMods + ", cTab";};
if (ADF_mod_ACE3) then {ADF_log_rptMods = ADF_log_rptMods + ", ACE3";};

// Init reporting
if (ADF_debug) then {
	diag_log "--------------------------------------------------------------------------------------";
	_ADF_log_compileMsg = format ["Init - ADF version: %1",_ADF_tpl_version];
	[_ADF_log_compileMsg,false] call ADF_fnc_log;
	_ADF_log_compileMsg = format ["Init - Mission version: %1",_ADF_mission_version];
	[_ADF_log_compileMsg,false] call ADF_fnc_log;
	_ADF_log_compileMsg = format ["Init - Number of clients connected: %1", (count ADF_log_pUnits)];
	[_ADF_log_compileMsg,false] call ADF_fnc_log;
	_ADF_log_compileMsg = format ["Init - Number of AI's active: %1", ADF_log_aiUnits];
	[_ADF_log_compileMsg,false] call ADF_fnc_log;
	diag_log "--------------------------------------------------------------------------------------";
	ADF_log_pUnits = nil; ADF_log_aiUnits = nil;
} else { // Live mission logging
	diag_log ""; diag_log "";
	diag_log "--------------------------------------------------------------------------------------";
	diag_log format ["ADF RPT: Init - ADF version: %1",_ADF_tpl_version];
	diag_log "--------------------------------------------------------------------------------------";
	diag_log format ["ADF RPT: Init - Mission version: %1",_ADF_mission_version];
	diag_log format ["ADF RPT: Init - Mission name: %1",(getText (missionConfigFile >> "overviewText"))];
	diag_log format ["ADF RPT: Init - Mission developer: %1",(getText (missionConfigFile >> "author"))];
	diag_log "--------------------------------------------------------------------------------------";
	diag_log format ["ADF RPT: Init - Number of clients connected: %1", (count ADF_log_pUnits)];
	diag_log format ["ADF RPT: Init - Number of HC's connected: %1", ADF_log_CntHC];
	diag_log "--------------------------------------------------------------------------------------";
	diag_log format ["ADF RPT: Init - Number of AI's active: %1", ADF_log_aiUnits];
	diag_log "--------------------------------------------------------------------------------------";
	diag_log format ["ADF RPT: Init - ADF addons active: %1", ADF_log_rptMods];
	diag_log "--------------------------------------------------------------------------------------";
	ADF_log_pUnits = nil; ADF_log_aiUnits = nil; ADF_log_rptMods = nil; ADF_log_CntHC = nil;
};

// Server FPS reporting in RPT when ADF_debug is disabled. The frequency of the reporting is based on server performance.
if (!ADF_debug && isServer) then { // ADF_debug already reports on server FPS
	[] spawn {	
		waitUntil {
			ADF_rptSnooz = 60;
			_ADF_serverFPS = round (diag_fps);
			if (_ADF_serverFPS < 40) then {ADF_rptSnooz = 15};
			if (_ADF_serverFPS < 30) then {ADF_rptSnooz = 10};
			if (_ADF_serverFPS < 20) then {ADF_rptSnooz = 5};
			if (_ADF_serverFPS < 15) then {ADF_rptSnooz = 1};
			diag_log format ["ADF RPT: PERF - Elapsed time in sec: %1  --  Server FPS: %2  --  Server Min FPS: %3",(round time),_ADF_serverFPS,round (diag_fpsmin)];
			uiSleep ADF_rptSnooz;
			false
		};
	};
};