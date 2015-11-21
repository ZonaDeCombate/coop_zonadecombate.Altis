// Mantem o check no Loop do jogo...
while {true} do
{
  private ["_reserved_units", "_reserved_uids", "_uid"];

  // Faz o check para o player no jogo. Espera algo que não seja null
  waitUntil {!isNull player};
  waitUntil {(vehicle player) == player};
  waitUntil {(getPlayerUID player) != ""};

  // UID de cada operador redcell. Não esquecer de colocar o nome do lado para não confundir...
  _reserved_uids =
  [
    "76561198070476773"/* John */,
    "UIDXXXXXXXXXXXXXX"/* Raphael */,
    "UIDXXXXXXXXXXXXXX"/* Hawk */,
    "76561197982383189"/* NFC3SPECTRO */
  ];

  // Salva o UID na variavel
  _uid = getPlayerUID player;

  {
    if (side _x isEqualTo EAST && !(_uid in _reserved_uids)) then {
      diag_log format["%1's side is %2", name _x, side _x];
      ["not_r3dcell",false,2] call BIS_fnc_endMission;  // Falha a missao para ele voltar ao lobby. Somente para o player
      //[{serverCommand format["#kick %1",_uid];}, "BIS_fnc_spawn", false] call BIS_fnc_MP; // Avisa o server para kickar o player.
    }
  } forEach playableUnits;

  // Delay do check do script
  sleep 5;
};
