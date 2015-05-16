/****************************************************************
ARMA Mission Development Framework
ADF version: 1.39 / MAY 2015

Script: Mission init / Variables init
Author: Whiztler
Script version: 1.10

Game type: n/a
File: ADF_init_pre.sqf
Previous: ADF_init_vars.sqf

****************************************************************/

ADF_dlc_MarksMan 	= isClass (configFile >> "CfgMods" >> "Mark"); // Check if Marksman DLC is present
ADF_dlc_Bundle 		= isClass (configFile >> "CfgMods" >> "DLCBundle"); // Check if DLC Bundle is present
ADF_dlc_Heli 		= isClass (configFile >> "CfgMods" >> "Heli"); // Check if Helicopters DLC is present
ADF_mod_CBA 		= isClass (configFile >> "CfgPatches" >> "cba_main"); // Check if CBA is present
ADF_mod_ACRE 		= isClass (configFile >> "CfgPatches" >> "acre_main"); // Check if ACRE is present
ADF_mod_TFAR 		= isClass (configFile >> "CfgPatches" >> "task_force_radio"); // Check if TFAR is present
ADF_mod_CTAB 		= isClass (configFile >> "CfgPatches" >> "cTab"); // Check if cTab is present
ADF_mod_ACE3 		= isClass (configFile >> "CfgPatches" >> "ace_common"); // ACE3 Core

ADF_missionInit = false;
ADF_MB_lite = true; // Mission Balancer vars 
ADF_MB_normal = true; // Mission Balancer vars 
ADF_MB_heavy = true; // Mission Balancer vars
ADF_microDAGR_all = 0; 
ADF_TFAR_LR_freq = 0;
ADF_TFAR_SW_freq = 0;
ADF_set_callSigns = false;
ADF_set_radios = false;
tf_no_auto_long_range_radio = true;

if (isNil "ADF_HC_connected") then {ADF_HC_connected = false;}; // HC init

ADF_init_vars = true;
publicVariableServer "ADF_init_vars";
 
player setVariable ["BIS_noCoreConversations",true]; // Disable AI chatter.
allowFunctionsLog = 0;	// Log functions to .rpt. disabled with 0
enableSentences false; // Disable AI chatter.
enableSaving [false,false]; // Disables save when aborting.
enableEngineArtillery false; // Disables BIS arty (map click).
enableTeamSwitch false; // Disables team switch.

ADF_fnc_log = { // if (ADF_debug) then {["YourTextMessageHere",true] call ADF_fnc_log}; // where true or false for error message
	private ["_ADF_log_pre","_ADF_msg","_ADF_log_write","_ADF_err_write","_ADF_err_pre","_ADF_error"];
	_ADF_msg = _this select 0;
	_ADF_error = _this select 1;	
	if (_ADF_error) then { // Is it an error message?
		_ADF_err_pre = "ADF Error: ";
		_ADF_err_write = _ADF_err_pre + _ADF_msg;
		[_ADF_err_write] call BIS_fnc_error;
		diag_log _ADF_err_write;
	} else { // Is it a debug log message?
		_ADF_log_pre = "ADF Debug: ";
		_ADF_log_write = _ADF_log_pre + _ADF_msg;
		systemChat _ADF_log_write;
		diag_log _ADF_log_write;
	};	
};