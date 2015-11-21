fnc_reservedSlot = {
	player enableSimulationGlobal false;
	endMission "not_r3dcell";
};

 if (!isServer && (player != player)) then { waitUntil {player == player}; waitUntil {time > 10}; };
 
 _OpsMenu = [player,"OpsMenu"] call BIS_fnc_addCommMenuItem;
 
//Script Interaccion//
 
action_interrogate = player addAction["Interrogar", {0 = cursorTarget spawn interrogate}, nil, 1.5, false, true, "", "(alive cursorTarget && side cursorTarget == civilian && {player distance cursorTarget < 3})"] spawn BIS_fnc_MP;

directionText = {
    if ((_this > 22.5) && (_this <= 67.5)) exitWith {"NORTHEAST"};
    if ((_this > 67.5) && (_this <= 112.5)) exitWith {"EAST"};
    if ((_this > 112.5) && (_this <= 157.5)) exitWith {"SOUTHEAST"};
    if ((_this > 157.5) && (_this <= 202.5)) exitWith {"SOUTH"};
    if ((_this > 202.5) && (_this <= 247.5)) exitWith {"SOUTHWEST"};
    if ((_this > 247.5) && (_this <= 295.5)) exitWith {"WEST"};
    if ((_this > 295.5) && (_this <= 337.5)) exitWith {"NORTHWEST"};
    "NORTH"
};

interrogate = {
    if (random 100 > 30) exitWith {systemChat "I don't feel like talking..."};

    private "_enemy";
    _enemy = { if (side _x == east || side _x == independent) exitWith {_x}; objNull } forEach (_this nearEntities [["Man", "Air", "Car", "Motorcycle", "Tank"],1000] - [player]);
    if (isNull _enemy) exitWith {systemChat "I've seen no baddies recently"};

    systemChat format["There is a %1 group of enemies to the %2 of here",
        call {
            private "_n";
            _n = count units group _enemy;
            switch true do {
                case (_n > 8): {"massive"};
                case (_n > 5): {"large"};
                case (_n > 0): {"small"};
                default "";
            }
        },
        ([_this,_enemy] call BIS_fnc_dirTo) call directionText
    ];
};