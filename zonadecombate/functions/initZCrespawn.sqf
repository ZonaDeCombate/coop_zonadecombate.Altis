if (isServer) then {

// Ativa o sistema de respawn na bandeira

  _locations = [["USS Wasp","cctMRK"],["USS NIMITZ","aegisMRK"],["Hospital","sealsMRK"],["Logistica","goteMRK"]];


  // Coloca os addAction para cada localizacao
  {
    private ["_locationName","_locationPos"];

    _locationName = _x select 0;
    _locationPos = _x select 1;
    [
      [
        zcRespawnObject,
        [
          format ["<t color='#FF0000'>%1</t>",_locationName],
          {


          [_this select 3] call ZC_fnc_teleportPlayer;


        },_locationPos,6,false,true,"","_this distance _target < 5"
        ]
      ],
      "addAction",
      true,
      true,
      false
    ] call BIS_fnc_MP;
  } forEach _locations;

};
