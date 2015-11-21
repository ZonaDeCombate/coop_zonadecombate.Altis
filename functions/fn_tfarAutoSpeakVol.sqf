/*
	file: fn_tfarAutoSpeakVol.sqf
	author: rakowozz
	description: toggles automatic direct speech Volume (Ctrl+Shift+Tab)
	v0.1
*/

private ["_localName","_hintText","_oldLevel","_counter","_vehicle"];

if (alive TFAR_currentUnit) then
{
	if (RAK_Var_autoSpeakVol) then
	{
		_oldLevel = TF_speak_volume_level;
		player removeEventHandler ["FiredNear",RAK_EH_autoSpeakDetector];
		
		if (_oldLevel == "Normal") then { TF_speak_volume_meters = 20 } else { TF_speak_volume_meters = 5 };
		["OnSpeakVolume", TFAR_currentUnit, [TFAR_currentUnit, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
		
		RAK_Var_autoSpeakVolCounter = 0;
		RAK_Var_autoSpeakVol = false;
		_localName = localize "STR_voice_autoOff";
	}
	else
	{	
		RAK_EH_autoSpeakDetector = player addEventHandler ["FiredNear",
		{
			if (TF_speak_volume_level == "Yelling") exitWith { };

			private ["_firer","_distance","_silencer","_hasSilencer","_oldLevel"];
			_firer = _this select 1;
			_distance = _this select 2;
			
			if (vehicle player != player) exitWith { };

			_oldLevel = TF_speak_volume_level;

			if (_distance < 50) then
			{
				_silencer = _firer weaponAccessories currentMuzzle _firer select 0;
				_hasSilencer = !isNil "_silencer" && {_silencer != ""};
				if (_hasSilencer) exitWith { };
			
				if (RAK_Var_autoSpeakVolCounter < 6) then
				{
					RAK_Var_autoSpeakVolCounter = RAK_Var_autoSpeakVolCounter + 1;
				};
				
				if (RAK_Var_autoSpeakVolCounter > 1) then
				{
					TF_speak_volume_meters = 60;
					["OnSpeakVolume", TFAR_currentUnit, [TFAR_currentUnit, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
					
					_oldLevel spawn
					{
						waitUntil {RAK_Var_autoSpeakVolCounter <= 1};
						if (RAK_Var_autoSpeakVolCounter == 0) exitWith { };
						if (TF_speak_volume_level != _this) exitWith { };

						if (_this == "Normal") then { TF_speak_volume_meters = 20 } else { TF_speak_volume_meters = 5 };
						["OnSpeakVolume", TFAR_currentUnit, [TFAR_currentUnit, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
					};
				};
			};
		}];
		
		RAK_Var_autoSpeakVol = true;
		
		_counter = 0 spawn
		{
			while {RAK_Var_autoSpeakVol} do
			{
				sleep 2;
				
				if (RAK_Var_autoSpeakVolCounter > 0) then
				{
					RAK_Var_autoSpeakVolCounter = RAK_Var_autoSpeakVolCounter - 1;
				};
			};
		};
		
		_vehicle = 0 spawn
		{
			private ["_oldLevel"];
			
			while {RAK_Var_autoSpeakVol} do
			{				
				if (vehicle player != player) then
				{
					_oldLevel = TF_speak_volume_level;
					if (_oldLevel == "Yelling") exitWith {};
					
					TF_speak_volume_meters = 60;
					["OnSpeakVolume", TFAR_currentUnit, [TFAR_currentUnit, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
					
					waitUntil {sleep 1; vehicle player == player};
					
					if (TF_speak_volume_level != _oldLevel) exitWith { };
					
					if (_oldLevel == "Normal") then { TF_speak_volume_meters = 20 } else { TF_speak_volume_meters = 5 };
					["OnSpeakVolume", TFAR_currentUnit, [TFAR_currentUnit, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
				};
				
				sleep 1;
			};
		};
		
		_localName = localize "STR_voice_autoOn";
	};

	_hintText = format [localize "STR_voice_auto", _localName];
	if (time > 2) then { [parseText (_hintText), 5] call TFAR_fnc_showHint };
};

true