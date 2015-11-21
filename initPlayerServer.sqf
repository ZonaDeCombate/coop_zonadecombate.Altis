_player = _this select 0;
_uid = getPlayerUID _player;

if ( _player getVariable [ "reserved", false ] && { !( _uid in reserved_uids ) } ) then {
	[ [], "fnc_reservedSlot", _player ] call BIS_fnc_MP;
};
