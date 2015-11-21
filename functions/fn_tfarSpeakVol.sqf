/*
	file: fn_tfarSpeakVol.sqf
	author: rakowozz
	description: initializes TFAR automatic direct speech volume
	v0.1
*/

if (!hasInterface) exitWith {};

waitUntil {isPlayer player && time > 1};

RAK_Var_autoSpeakVol = true;
RAK_Var_autoSpeakVolCounter = 0;
RAK_EH_autoSpeakDetector = -100;
TF_auto_volume_scancode = 15;
TF_auto_volume_modifiers = [true,true,false];

0 call RAK_fnc_tfarAutoSpeakVol;

["TFAR","AutoSpeakingVolume",["Automatic Speaking Volume","Automatic Speaking Volume"],{call RAK_fnc_tfarAutoSpeakVol},{true},[TF_auto_volume_scancode, TF_auto_volume_modifiers],false] call cba_fnc_addKeybind;

true