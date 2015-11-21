private["_player","_location","_owner"];

_player	= player;
_location = _this select 0;
_owner = owner _player;

playSound "SEN_transportWelcome";
//["SEN_transportWelcome", "playSound", _owner] call BIS_fnc_MP;

//[{titleText ["Você está sendo transportado para o local", "BLACK", 1]; sleep 5; titleFadeOut 2;}, "BIS_fnc_spawn", _owner] call BIS_fnc_MP;
titleText ["Você está sendo transportado para o local", "BLACK", 1];
sleep 5;
titleFadeOut 2;

playSound "SEN_transportAccomplished";
//["SEN_transportAccomplished", "playSound", _owner] call BIS_fnc_MP;

_smallRandomOffset = [(random 6) - 3, (random 6) - 3, 0];
_player setPos ((getMarkerPos(_location)) vectorAdd _smallRandomOffset);
