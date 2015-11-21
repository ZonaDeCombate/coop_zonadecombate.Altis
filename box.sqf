//Init stuff
_crate = _this select 0;
["AmmoboxInit",[_crate,false,{true}]] spawn BIS_fnc_arsenal;

//Lists of items to include
_availableHeadgear = [
    "LOP_H_Shemag_BLK",
	"H_Watchcap_camo",
	"H_Watchcap_blk",
	"H_Cap_blk",
	"H_Cap_tan",
    "H_Bandanna_khk",
	"H_Bandanna_gry",
	"H_Bandanna_camo",
    "H_Booniehat_oli",
    "H_Booniehat_tan",
    "H_BandMask_blk",
    "H_Shemag_olive",
	"H_Shemag_khk"
];

_availableGoggles = [
    "G_Sport_BlackWhite",
    "G_Sport_Blackred"
];

_availableUniforms = [
    "LOP_U_US_Fatigue_01",
    "LOP_U_US_Fatigue_02",
    "LOP_U_US_Fatigue_03",
    "LOP_U_US_Fatigue_04",
	"U_C_Poloshirt_tricolour",
	"U_C_Poloshirt_blue",
	"U_C_Poloshirt_stripped",
	"U_OrestesBody",
	"U_NikosBody"
];

_availableVests = [
    "LOP_V_6B23_6Sh92_OLV",
    "LOP_V_6Sh92_OLV",
    "LOP_V_6Sh92_WDL"
];

_availableBackpacks = [
    "B_AssaultPack_rgr",
    "B_Kitbag_rgr"
];

_availableItems = [
    "ItemWatch",
    "ItemCompass",
    "ItemGPS",
    "ItemMap",
	"tf_fadak",
	"ItemRadio",
	"Binocular",
    "MineDetector",
	"rhs_acc_1pn93_1",
	"rhs_acc_1p29",
	"rhs_acc_pso1m2",
	"rhs_acc_pkas",
    "Rangefinder",
	"rhsusf_acc_ACOG_wd",
	"rhs_acc_ak5",
	"rhs_acc_tgpv",
	"ACE_fieldDressing",
	"ACE_microDAGR",
	"ACE_TacticalLadder_Pack",
	"ACE_CableTie",
	"ACE_Clacker",
	"ACE_Flashlight_MX991",
	"ACE_atropine",
	"ACE_elasticBandage",
	"ACE_quikclot",
	"ACE_packingBandage",
	"ACE_personalAidKit",
	"ACE_salineIV_500",
	"ACE_surgicalKit",
	"ACE_tourniquet",
	"ACE_epinephrine",
	"ACE_morphine",
	"optic_LRPS",
	"optic_Hamr",
	"ACE_EarPlugs",
	"ACE_MapTools",
	"optic_ACO_grn_smg"
];

_availableMagazines = [
    "DemoCharge_Remote_Mag",
    "IEDUrbanSmall_Remote_Mag",
    "IEDLandSmall_Remote_Mag",
    "SatchelCharge_Remote_Mag",
    "IEDUrbanBig_Remote_Mag",
    "IEDLandBig_Remote_Mag",
    "ATMine_Range_Mag",
    "ClaymoreDirectionalMine_Remote_Mag",
    "APERSMine_Range_Mag",
    "APERSBoundingMine_Range_Mag",
    "SLAMDirectionalMine_Wire_Mag",
    "APERSTripMine_Wire_Mag",
    "rhs_mag_9k38_rocket",
    "rhs_rpg7_PG7VL_mag",
    "rhs_rpg7_PG7VR_mag",
    "rhs_rpg7_OG7V_mag",
    "rhs_rpg7_TBG7V_mag",
    "rhs_B_762x39_Ball_89",
    "rhs_B_762x39_Tracer",
    "rhs_B_762x54_7N1_Ball",
	"rhs_B_762x54_Ball_Tracer_Green",
	"6Rnd_45ACP_Cylinder",
	"9Rnd_45ACP_Mag",
	"SmokeShellGreen",
	"SmokeShellRed",
	"SmokeShell",
	"Chemlight_red",
	"ACE_HandFlare_Red",
	"rhs_B_545x39_Ball",
	"rhs_g_vog25",
	"rhs_g_vg40sz",
	"rhs_g_grd50",
	"ACE_M84",
	"HandGrenade"
];

_availableWeapons = [
    "rhs_weap_ak103",
    "hgun_ACPC2_F",
    "hgun_Pistol_heavy_02_F",
    "rhs_weap_svdp_wd",
    "rhs_weap_pkp",
	"rhs_weap_ak74m_gp25",
    "rhs_weap_rpg7",
	"rhs_weap_rpg26",
	"rhs_weap_igla"
];








//Populate with predefined items and whatever is already in the crate
[_crate,((backpackCargo _crate) + _availableBackpacks)] call BIS_fnc_addVirtualBackpackCargo;
[_crate,((itemCargo _crate) + _availableHeadgear + _availableGoggles + _availableUniforms + _availableVests + _availableItems)] call BIS_fnc_addVirtualItemCargo;
[_crate,((magazineCargo _crate) + _availableMagazines)] call BIS_fnc_addVirtualMagazineCargo;
[_crate,((weaponCargo _crate) + _availableWeapons)] call BIS_fnc_addVirtualWeaponCargo;
