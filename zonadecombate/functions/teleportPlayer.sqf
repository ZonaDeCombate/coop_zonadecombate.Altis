private["_player","_marker","_location","_locationHeight","_owner"];

_player	= player;
_marker = _this select 0 select 0;
_location = getMarkerPos _marker;
_locationHeight = _this select 0 select 1;
_owner = owner _player;

playSound "SEN_transportWelcome";
//["SEN_transportWelcome", "playSound", _owner] call BIS_fnc_MP;


titleText ["Você está sendo transportado para o local", "BLACK", 1];
sleep 5;
titleFadeOut 2;

playSound "SEN_transportAccomplished";

// E não é que matemática ajudou saporra? Código para ter um offset na hora de spawnar.
_player setPosASL [(_location select 0) + (4 * sin floor(random 360)), (_location select 1) + (4 * cos floor(random 360)), _locationHeight];
