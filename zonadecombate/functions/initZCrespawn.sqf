if (isServer) then {

  // Ativa o sistema de respawn na bandeira
  _locations = [
  // Para adicionar novos markers, basta criar mais uma entrada no array. Exemplo:
  // ["Nome para aparecer na Bandeira","nome_do_marker", altura]
  ["USS Wasp","mrk_wasp", 16.8],
  ["USS NIMITZ","mrk_nimitz",17.21],
  ["Hospital","mrk_hospital",0],
  ["Logistica","mrk_logistics",0]

  ];

  // Para adicionar novas flags, basta colocar o nome da mesma no array abaixo.
  _flags = [
    // nome_da_flag
    zcRespawnObject,
    zcRespawnObject2,
    zcRespawnObject3
  ];


  // Coloca os addAction para cada localizacao
  {
    private ["_locationName","_locationPos","_locationHeight"];

    _locationName = _x select 0;
    _locationPos = _x select 1;
    _locationHeight = _x select 2;

    {
      [
        [
          _x,
          [
            format ["<t color='#FF0000'>%1</t>",_locationName],
            {


            [_this select 3] call ZC_fnc_teleportPlayer;


          },[_locationPos,_locationHeight],6,false,true,"","_this distance _target < 5"
          ]
        ],
        "addAction",
        true,
        true,
        false
      ] call BIS_fnc_MP;
    } forEach _flags;


  } forEach _locations;

};
