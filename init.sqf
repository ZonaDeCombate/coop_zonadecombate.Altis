execVM "R3F_LOG\init.sqf";
call ZC_fnc_initZCrespawn;
CHHQ_showMarkers = true;

["init",["WEST","LOP_ChDKZ"]] call SCI_fnc_civilianInteraction;

[] execVM "staticData.sqf";
//------------------------------//


//HandlessClient Inicialização

if (!hasInterface && !isDedicated) then {
headlessClients = [];
headlessClients set [(count headlessClients), player];
publicVariable "headlessClients";
isHC = true;
};

enableSaving [false,false];


if (! isDedicated) then
{

  zc_fnc_setRating = {
    _setRating = _this select 0;
    _unit = _this select 1;
    _getRating = rating _unit;
    _addVal = _setRating - _getRating;
    _unit addRating _addVal;
  };

  waituntil {
    _score = rating player;

    if (_score < 0) then {
      [0,player] call zc_fnc_setRating;
      hint parseText format["<t color='#ffff00'>Atenção %1: </t><br/>*** Evite ferir aliados e civis. ***",name player];
    };
    sleep 0.4;
    false
  };
};

waituntil {(player getvariable ["alive_sys_player_playerloaded",false])};
