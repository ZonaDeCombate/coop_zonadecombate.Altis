private ["_civData","_civInfo","_hostile","_hostility","_asked","_civ","_answerGiven"];
params [
	["_question", ""]
];

//-- Define control ID's
#define MAINCLASS SCI_fnc_civilianInteraction
#define QUESTION_HANDLER SCI_fnc_questionHandler
#define SCI_ResponseList (findDisplay 923 displayCtrl 9239)

//-- Get civ hostility
_hostile =  false;
_civData = [SCI_Logic, "CurrentCivData"] call ALiVE_fnc_hashGet;
_civInfo = [_civData, "CivInfo"] call ALiVE_fnc_hashGet;_civInfo = _civInfo select 0;
_civ = [SCI_Logic, "CurrentCivilian"] call ALiVE_fnc_hashGet;
_civName = name _civ;

//-- Set questions asked
_asked = ([_civData, "Asked"] call ALiVE_fnc_hashGet) + 1;	
[_civData, "Asked", _asked] call ALiVE_fnc_hashSet;

if (!isNil {[_civData, "Hostile"] call ALiVE_fnC_hashGet}) then {
	_hostile = true;
} else {
	_hostility = _civInfo select 1;
	if (random 100 < _hostility) then {
		_hostile = true;
		[_civData, "Hostile", true] call ALiVE_fnc_hashSet;
	};
};

//-- Hash new data to logic
[SCI_Logic, "CurrentCivData", _civData] call ALiVE_fnc_hashSet;

//-- Get previous responses
_answersGiven = [_civData, "AnswersGiven"] call ALiVE_fnc_hashGet;

//-- Clear previous responses
SCI_ResponseList ctrlSetText "";

//-- Check if question has already been answered
if ((_question in _answersGiven) and (floor random 100 < 75)) exitWith {
	_response1 = "Eu não vou repetir o que acabei de falar.";
	_response2 = "A gente já não discutiu sobre isso?";
	_response3 = "Eu já respondi isso.";
	_response4 = "Porque você está perguntando isso denovo?";
	_response5 = "Você já me perguntou isso.";
	_response6 = "Você está começando a me irritar com essas perguntas.";
	_response7 = "Eu não posso mais falar sobre isso.";
	_response8 = "Você já ouviu o que queria ouvir.";
	_response = [_response1,_response2,_response3,_response4,_response5,_response6,_response7,_response8] call BIS_fnc_selectRandom;
	SCI_ResponseList ctrlSetText _response;
		
	//-- Check if civilian is irritated
	["isIrritated", [_hostile,_asked,_civ]] call MAINCLASS;
};

switch (_question) do {

	//-- Where is your home located
	case "Home": {
		_homePos = _civInfo select 0;

		if (!(_hostile) and (floor random 100 > 15)) then {
			_response1 = format ["Eu moro por ali, vou te mostrar (A casa de %1 foi marcada no mapa).", _civName];
			_response2 = format ["Eu moro perto (A casa de %1 foi marcada no mapa).", _civName];
			_response3 = format ["Eu vou aponta-la para você (A casa de %1 foi marcada no mapa).", _civName];
			_response4 = format ["Eu moro por ali (A casa de %1 foi marcada no mapa).", _civName];
			_response = [_response1,_response2,_response3,_response4] call BIS_fnc_selectRandom;
			SCI_ResponseList ctrlSetText _response;

			//-- Create marker on home
			_answersGiven pushBack "Casa";_answerGiven = true;
			_markerName = format ["A casa de %1", _civName];
			_marker = [str _homePos, _homePos, "ICON", [.35, .35], "ColorCIV", _markerName, "mil_circle", "Solid", 0, .5] call ALIVE_fnc_createMarkerGlobal;
			_marker spawn {sleep 30;deleteMarker _this};
		} else {
			_response1 = "Me desculpe, não me sinto confortável te contando essa informação.";
			_response2 = "Eu não quero compartilhar isso com você.";
			_response3 = "Eu não te devo nada.";
			_response4 = "Me deixe em paz, por favor.";
			_response5 = "Por favor, se retire.";
			_response6 = "Saia daqui!";
			_response = [_response1,_response2,_response3,_response4,_response5,_response6] call BIS_fnc_selectRandom;
			SCI_ResponseList ctrlSetText _response;
		};
	};

	//-- What town do you live in
	case "Town": {
		_homePos = _civInfo select 0;
		_town = [_homePos] call ALIVE_fnc_taskGetNearestLocationName;

		if !(_hostile) then {
			if (floor random 100 > 15) then {
				_response1 = format ["Eu moro pela região de %1.", _town];
				_response2 = format ["Eu moro em %1.", _town];
				_response3 = format ["Eu moro na vila de %1.", _town];
				_response4 = format ["Minha cidade natal é %1.", _town];
				_response5 = "Você não deveria estar aqui.";
				_response6 = "Eles não vão gostar de ver eu conversando com você.";
				_response = [_response1, _response2, _response3, _response4, _response5, _response6] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
				_answersGiven pushBack "Town";_answerGiven = true;
			} else {				
				_response1 = "Me desculpe, mas não me sinto confortável compartilhando essa informação com você.";
				_response2 = "Desculpe, eu não quero responder isso.";
				_response3 = "Eu não deveria compartilhar isso com você.";
				_response4 = "Eu só quero que me deixe em paz.";
				_response5 = "Por favor, deixe minha comunidade em paz.";
				_response = [_response1,_response2,_response3,_response4,_response5] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
			};
		} else {
			_response1 = "Desculpa, mas não me sinto confortável em te passar essa informação.";
			_response2 = "Não devo compartilhar isso com você.";
			_response3 = "Não te devo nada.";
			_response4 = "Você não deveria estar aqui.";
			_response5 = "Por favor, me deixe em paz.";
			_response6 = "Eu não vou te dizer aonde moro!";
			_response7 = "Você não vai aterrorizar minha cidade!";
			_response = [_response1, _response2, _response3, _response4, _response5, _response6, _response7] call BIS_fnc_selectRandom;
			SCI_ResponseList ctrlSetText _response;
		};
	};

	//-- Have you seen any IED's nearby
	case "IEDs": {

		_IEDs = [];
		{
			if (_x distance2D (getPos _civ) < 1000) then {_IEDs pushBack _x};
		} forEach allMines;

		if (count _IEDs == 0) then {
			if !(_hostile) then {
				if (floor random 100 > 25) then {
					_response1 = "Não tem nenhuma IED próxima.";
					_response2 = "Desculpe, não vi nenhuma.";
					_response3 = "Não que eu saiba, desculpe.";
					_response4 = "Nenhuma IED foi vista por perto.";
					_response = [_response1, _response2, _response3, _response4] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
					_answersGiven pushBack "IEDs";_answerGiven = true;
				} else {
					_response1 = "Desculpe, eu não sei.";
					_response2 = "Eu não posso te dar esse tipo de informação.";
					_response3 = "Se te contar, serei um homem morto.";
					_response4 = "Por favor, retire-se, eles não podem me ver conversando contigo.";
					_response = [_response1, _response2, _response3, _response4] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
				};
			} else {
				_response1 = "Como se eu fosse te contar...";
				_response2 = "Me deixe em paz logo!";
				_response3 = "Você vai ter que descobrir isso por conta própria.";
				_response4 = "Cuidado aonde pisa.";
				_response5 = "Talvez eu devesse ter plantado algumas.";
				_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
			};
			
		} else {
			_iedLocation = getPos (_IEDs call BIS_fnc_selectRandom);

			if !(_hostile) then {
				if (floor random 100 > 25) then {
					_response1 = "Sim, eu vi uma mais cedo neste local (Local marcado no mapa).";
					_response2 = "Deixe-me te mostrar uma (Local marcado no mapa).";
					_response3 = "Eu acho que sei aonde pode ter uma (Local marcado no mapa).";
					_response4 = "Eu vi um insurgente plantando uma aqui (Local marcado no mapa).";
					_response = [_response1, _response2, _response3, _response4] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
					_answersGiven pushBack "IEDs";_answerGiven = true;

					//-- Create marker on IED
					_iedPos = getPos (_IEDs call BIS_fnc_selectRandom);
					_iedPos = [_iedPos, (25 + ceil random 15)] call CBA_fnc_randPos;
					_marker = [str _iedPos, _iedPos, "ELLIPSE", [40, 40], "ColorRed", "IED", "n_installation", "FDiagonal", 0, 0.5] call ALIVE_fnc_createMarkerGlobal;
					_text = [str (str _iedPos),_iedPos,"ICON", [0.1,0.1],"ColorRed","IED", "mil_dot", "FDiagonal",0,0.5] call ALIVE_fnc_createMarkerGlobal;
					[_marker,_text] spawn {sleep 30;deleteMarker (_this select 0);deleteMarker (_this select 1)};
				} else {
					_response1 = "Desculpe, eu não sei.";
					_response2 = "Não posso dar esse tipo de informação.";
					_response3 = "Seria morto se te contasse.";
					_response4 = "Saia por favor, eles não podem me ver com você.";
					_response = [_response1, _response2, _response3, _response4] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
				};
			} else {
				_response1 = "Como se eu quisesse te contar.";
				_response2 = "Me deixe em paz.";
				_response3 = "Você vai ter que descobrir sozinho.";
				_response4 = "Olhe por onde anda.";
				_response5 = "Posso ter plantado algumas, não sei...";
				_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
			};
			
		};
	};

	//-- Have you seen any insurgent activity lately
	case "Insurgents": {

		_insurgentFaction = [SCI_Logic, "InsurgentFaction"] call ALiVE_fnc_hashGet;
		_pos = getPos _civ;
		_town = [_pos] call ALIVE_fnc_taskGetNearestLocationName;

		//-- Get nearby insurgents
		_insurgents = [];
		{
			_leader = leader _x;

			if ((faction _leader == _insurgentFaction) and {_leader distance2D _pos < 1100}) then {
				_insurgents pushBack _leader;
			};
		} forEach allGroups;

		if (count _insurgents == 0) then {
			//-- Insurgents are not nearby
			if !(_hostile) then {
				if (floor random 100 > 40) then {
					_response1 = "Desculpa, eu não vi nenhum.";
					_response2 = "Não, não tem nenhum por perto.";
					_response3 = "Recentemente não, desculpe.";
					_response4 = "Graças a Alá, não.";
					_response5 = "Eu não vi nenhum.";
					_response = [_response1, _response2, _response3, _response4,_response5] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
					_answersGiven pushBack "Insurgents";_answerGiven = true;
				} else {
					_response1 = "Por favor, só me deixe em paz.";
					_response2 = "Eu não quero falar sobre isso.";
					_response3 = "Eu não quero falar com você.";
					_response4 = "Não posso contar para você.";
					_response5 = "Eles não vão gostar de saber que eu conversei com você.";
					_response = [_response1, _response2, _response3, _response4,_response5] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
				};
			} else {
				_response1 = "Como se eu fosse te contar algo.";
				_response2 = "Saia de perto de mim.";
				_response3 = "Por favor, saia de perto.";
				_response4 = "Não quero falar sobre isso.";
				_response5 = "Não quero falar com você.";
				_response = [_response1, _response2, _response3, _response4,_response5] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
			};
		} else {
			//-- Insurgents are nearby
			if !(_hostile) then {
				//-- Random chance to reveal insurgents
				if (floor random 100 > 50) then {
					//-- Reveal location
					_response1 = format ["Alguns insurgentes estão perto de %1.", _town];
					_response2 = "Não me dedure (Insurgentes marcados no mapa).";
					_response3 = "Sim, deixe-me te mostrar aonde vi eles (Insurgentes marcados no mapas).";
					_response4 = "Sim, mas você tem que guardar segredo (Insurgentes marcados no mapa).";
					_response = [_response1, _response2, _response3, _response4] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
					_answersGiven pushBack "Insurgents";_answerGiven = true;

					//-- Create marker on insurgent group
					_insurgentPos = getPos (_insurgents call BIS_fnc_selectRandom);
					_insurgentPos = [_insurgentPos, (75 + ceil random 25)] call CBA_fnc_randPos;
					_marker = [str _insurgentPos, _insurgentPos, "ELLIPSE", [100, 100], "ColorEAST", "Insurgentes", "n_installation", "FDiagonal", 0, 0.5] call ALIVE_fnc_createMarkerGlobal;
					_text = [str (str _insurgentPos),_insurgentPos,"ICON", [0.1,0.1],"ColorRed","Insurgentes", "mil_dot", "FDiagonal",0,0.5] call ALIVE_fnc_createMarkerGlobal;
					[_marker,_text] spawn {sleep 30;deleteMarker (_this select 0);deleteMarker (_this select 1)};
				} else {
					//-- Don't reveal location
					_response1 = "Eles não querem que eu fale contigo.";
					_response2 = "Você não pode fazer essas perguntas.";
					_response3 = "Você é louco?";
					_response4 = "Por favor, me deixe só.";
					_response5 = "Eu não quero falar sobre isso.";
					_response6 = "Não quero falar com você.";
					_response = [_response1, _response2, _response3, _response4] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
				};
			} else {
				_response1 = "Como se eu fosse te contar algo.";
				_response2 = "Se afaste de mim.";
				_response3 = "Só me deixe em paz.";
				_response4 = "Eu não quero conversar sobre isso.";
				_response5 = "Não quero falar com você.";
				_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
			};
		};
		
	};

	//-- Do you know the location of any insurgent hideouts
	case "Hideouts": {
		_installations = [_civData, "Installations"] call ALiVE_fnc_hashGet;
		_actions = [_civData, "Actions"] call ALiVE_fnc_hashGet;
		_installations params ["_factory","_HQ","_depot","_roadblocks"];
		_actions params ["_ambush","_sabotage","_ied","_suicide"];

		if ((_factory isEqualTo []) and (_HQ isEqualTo []) and (_depot isEqualTo []) and (_roadblocks isEqualTo [])) then {
			if !(_hostile) then {
				if (floor random 100 > 30) then {
					_response1 = "Os insurgentes não construiram nenhuma instalação por aqui.";
					_response2 = "Por sorte, não.";
					_response3 = "Não, não sei.";
					_response4 = "Não há bases insurgentes aqui.";
					_response5 = "Não há esconderijos insurgentes por aqui.";
					_response6 = "Os insurgentes não assaltaram essa área ainda.";
					_response7 = "Não há esconderijos aqui.";
					_response8 = "Não há instalações aqui.";
					_response9 = "Ainda estamos livres do reino de terror deles.";
					_response = [_response1,_response2,_response3,_response4,_response5,_response6,_response7,_response8,_response9] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
					_answersGiven pushBack "Hideouts";_answerGiven = true;
				} else {
					_response1 = "Cê é maluco?.";
					_response2 = "Não posso conversar sobre isso.";
					_response3 = "Você quer me ver morto?";
					_response4 = "Eu não me colocarei em perigo.";
					_response5 = "Eu não colocarei a mim e a minha família em risco.";
					_response = [_response1,_response2,_response3,_response4,_response5] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
				};
			} else {
				_response1 = "Não tenho tempo para isso.";
				_response2 = "Não posso falar sobre isso neste momento.";
				_response3 = "Você é doido?.";
				_response4 = "Porque você me faria tal pergunta?";
				_response5 = "Essa é uma pergunta ousada a se fazer.";
				_response6 = "Você quer que eles me matem?";
				_response7 = "Eu não me colocarei em perigo.";
				_response8 = "Porque você pergunta isso?";
				_response9 = "Não posso te ajudar sobre isso.";
				_response = [_response1,_response2,_response3,_response4,_response5,_response6,_response7,_response8,_response9] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
			};
		} else {
			private ["_installation","_type","_typeName","_installationData"];
			for "_i" from 0 to 3 do {
				_installationArray = _installations call BIS_fnc_selectRandom;

				if (!(_installationArray isEqualTo []) and (isNil "_installation")) then {
					_index = _installations find _installationArray;
					switch (str _index) do {
						case "0": {_typeName = "Fábrica de IED";_type = "IED factory"};
						case "1": {_typeName = "HQ de recrutamento";_type = "recruitment HQ"};
						case "2": {_typeName = "Depósito de munição";_type = "munitions depot"};
						case "3": {_typeName = "Bloqueio rodoviário";_type = "roadblocks"};
					};
					_installation = _installationArray;
				};
			};			

			if ((isNil "_type") or (isNil "_installation")) exitWith {
				_response1 = "Não posso falar sobre isso.";
				_response2 = "Eles me matariam.";
				_response3 = "Cê é maluco mesmo.";
				_response4 = "Então você quer me ver morto mesmo.";
				_response5 = "Não posso colocar minha familia em risco respondendo a isso.";
				_response = [_response1,_response2,_response3,_response4,_response5] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
				_answersGiven pushBack "Hideouts";_answerGiven = true;
			};

			if !(_hostile) then {
				if (floor random 100 > 60) then {
					if (floor random 100 > 60) then {
						_response1 = format ["Eu percebi %1 por perto (%2 marcado no mapa).", _type,_typeName];
						_response2 = format ["Alguem me disse que tinha %1 por perto (%2 marcado no mapa).", _type,_typeName];
						_response3 = format ["Eu observei uns insurgentes montando %1 por perto (%2 marcado no mapa).", _type,_typeName];
						_response4 = format ["Eu sei a localização de %1 (%2 marcado no mapa).", _type,_typeName];
						_response5 = format ["Os insurgentes montaram %1 por aqui (%2 marcado no mapa).", _type,_typeName];
						_response6 = format ["Posso te mostrar a localização de %1 (%2 marcado no mapa).", _type,_typeName];
						_response7 = format ["Você tem que manter isso em segredo (%2 marcado no mapa).", _type,_typeName];
						_response8 = format ["Me prometa que vai me proteger (%2 marcado no mapa).", _type,_typeName];
						_response9 = format ["Por favor retire %1 da area e traga a paz de volta (%2 marcado no mapa).", _type,_typeName];
						_response = [_response1,_response2,_response3,_response4,_response5,_response6,_response7,_response8,_response9] call BIS_fnc_selectRandom;
						SCI_ResponseList ctrlSetText _response;
						_answersGiven pushBack "Hideouts";_answerGiven = true;

						if (floor random 100 > 30) then {
							//-- Create marker on general installation location
							_installationPos = getPos _installation;
							_installationPos = [_installationPos, (75 + ceil random 25)] call CBA_fnc_randPos;
							_marker = [str _installationPos, _installationPos, "ELLIPSE", [100,100], "ColorEAST", _typeName, "n_installation", "FDiagonal", 0, 0.5] call ALIVE_fnc_createMarkerGlobal;
							_text = [str (str _installationPos),_installationPos,"ICON", [0.1,0.1],"ColorRed",_typeName, "mil_dot", "FDiagonal",0,0.5] call ALIVE_fnc_createMarkerGlobal;
							[_marker,_text] spawn {sleep 30;deleteMarker (_this select 0);deleteMarker (_this select 1)};
						} else {
							hint "Exact Marker";
							//-- Create marker on installation location
							_installationPos = getPos _installation;
							_marker = [str _installationPos, _installationPos, "ICON", [1,1], "ColorRed", _type, "n_installation", "Solid", 0, .5] call ALIVE_fnc_createMarkerGlobal;
							_marker spawn {sleep 30;deleteMarker _this};
						};
					} else {
						_response1 = format ["Eu percebi um %1 por perto.", _type];
						_response2 = format ["Alguém me contou que tinha %1 por perto.", _type];
						_response3 = format ["Eu vi os insurgentes construindo um %1.", _type];
						_response4 = format ["Insurgentes prepararam um %1 nas redondezas.", _type];
						_response5 = format ["Insurgentes estabilizaram %1 por aqui.", _type];
						_response6 = format ["Outros mencionaram %1 por perto.", _type];
						_response7 = format ["Insurgentes montaram %1 por perto.", _type];
						_response8 = format ["Recupere a paz nesta area,há %1 por aqui.", _type];
						_response9 = format ["Eu não sei aonde é, mas os insurgentes estao operando %1 em algum lugar por aqui.", _type];
						_response = [_response1,_response2,_response3,_response4,_response5,_response6,_response7,_response8,_response9] call BIS_fnc_selectRandom;
						SCI_ResponseList ctrlSetText _response;
						_answersGiven pushBack "Hideouts";_answerGiven = true;
					};
				} else {
					_response1 = "Não posso falar sobre isso.";
					_response2 = "Eles me matariam.";
					_response3 = "Você é maluco.";
					_response4 = "Você quer que eles me matem mesmo.";
					_response5 = "Não posso colocar minha familia em risco te contando isso.";
					_response = [_response1,_response2,_response3,_response4,_response5] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
					_answersGiven pushBack "Hideouts";_answerGiven = true;
				};
			} else {
				if (floor random 100 > _hostility) then {
					_response1 = format ["Eu percebi %1 por perto.", _type];
					_response2 = format ["Alguem me disse que há %1 por perto.", _type];
					_response3 = format ["Eu vi insurgentes construindo %1.", _type];
					_response4 = format ["Os insurgentes prepararam %1 por perto.", _type];
					_response5 = format ["Os insurgentes montaram %1 muito perto daqui.", _type];
					_response6 = format ["Outros mencionaram %1 por perto.", _type];
					_response7 = format ["Os insurgentes configuraram %1 por perto.", _type];
					_response8 = format ["Traga a paz de volta para essa area, tem %1 nas redondezas.", _type];
					_response9 = format ["Eu não sei aonde é, mas os insurgentes estão operando %1 em algum lugar por aqui.", _type];
					_response = [_response1,_response2,_response3,_response4,_response5,_response6,_response7,_response8,_response9] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
					_answersGiven pushBack "Hideouts";_answerGiven = true;
				} else {
					_response1 = "Não posso falar sobre isso.";
					_response2 = "Eles me matariam.";
					_response3 = "Cê é maluco mesmo.";
					_response4 = "Então você quer me ver morto mesmo.";
					_response5 = "Não posso colocar minha familia em risco respondendo a isso.";
					_response6 = "Saia daqui!!";
					_response7 = "Se afaste de mim!";
					_response8 = "Você me enoja!";
					_response = [_response1,_response2,_response3,_response4,_response5,_response6,_response7,_response8] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
					_answersGiven pushBack "Hideouts";_answerGiven = true;
				};					
			};
		};
	};

	//-- Have you noticed any strange behavior lately
	case "StrangeBehavior": {
		_hostileCivInfo = [_civData, "HostileCivInfo"] call ALiVE_fnc_hashGet;	//-- [_civ,_homePos,_activeCommands]
		//-- Check if data exists
		if (count _hostileCivInfo == 0) then {
			if !(_hostile) then {
				if (floor random 100 > 70) then {
					_response1 = "Eu não vi nada.";
					_response2 = "Não, não vi.";
					_response3 = "Não, não que me recorde.";
					_response4 = "Não teve nenhum comportamento diferente ultimamente.";
					_response5 = "Tudo está pacífico por aqui.";
					_response6 = "Nós somos uma comunidade pacífica.";
					_response = [_response1, _response2, _response3, _response4, _response5, _response6] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
					_answersGiven pushBack "StrangeBehavior";_answerGiven = true;
				} else {					
					_response1 = "Eu não arriscarei meu pescoço.";
					_response2 = "Eles vão me matar se eu te contar.";
					_response3 = "Eu não posso falar sobre isso.";
					_response4 = "Não percebi nenhum comportamento suspeito ultimamente.";
					_response5 = "Eles não gostariam de me ver falando com você.";
					_response6 = "Eu não deveria estar falando sobre isso.";
					_response = [_response1, _response2, _response3, _response4, _response5,_response6] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
				};
			} else {
				_response1 = "Eu não posso falar sobre isso.";
				_response2 = "Eles não vão gostar que eu converse com você";
				_response3 = "Não posso te ajudar.";
				_response4 = "Não, eu não vi.";
				_response5 = "Eu não vi nada ultimamente.";
				_response6 = "Não há perigo aqui.";
				_response7 = "Eu não tenho tempo pra isso";
				_response = [_response1,_response2,_response3,_response4,_response5,_response6,_response7] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
				_answersGiven pushBack "StrangeBehavior";_answerGiven = true;
			};
		} else {
			_hostileCivInfo params ["_hostileCiv","_homePos","_activeCommands"];
			_activeCommand = _activeCommands call BIS_fnc_selectRandom;
			_activeCommand = _activeCommand select 0;
			_activePlan = ["getActivePlan",_activeCommand] call MAINCLASS;

			if (isNil "_activePlan") exitWith {SCI_ResponseList ctrlSetText "Não posso falar sobre isso nesse momento."};

			if (!(_hostile) and (floor random 100 > 70)) then {
				_response1 = format ["Eu ouvi que %1 era %2.", name _hostileCiv, _activePlan];
				_response2 = format ["Alguem me disse que %1 era %2.", name _hostileCiv, _activePlan];
				_response3 = format ["Eu vi que %1 era %2.", name _hostileCiv, _activePlan];
				_response4 = format ["Eu acho que %1 era %2.", name _hostileCiv, _activePlan];
				_response5 = format ["Eu fui informado que %1 era %2.", name _hostileCiv, _activePlan];
				_response6 = format ["Me disseram que %1 era %2.", name _hostileCiv, _activePlan];
				_response = [_response1, _response2, _response3, _response4, _response5, _response6] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
				_answersGiven pushBack "StrangeBehavior";_answerGiven = true;

				if (floor random 100 <= 35) then {
					switch (str floor random 2) do {
						case "0": {
							_response1 = " Eu ouvi alguem dizendo aonde ele está (Posição marcada no mapa).";
							_response2 = " Alguém me falou aonde ele está (Posição marcada no mapa).";
							_response3 = " Eu vi ele mais cedo (Posição marcada no mapa).";
							_response4 = " Eu acho que sei aonde você pode encontrá-lo (Posição marcada no mapa).";
							_response = [_response1, _response2, _response3,_response4] call BIS_fnc_selectRandom;
							SCI_ResponseList ctrlSetText ((ctrlText SCI_ResponseList) + _response);

							//-- Create marker on hostile civ location
							_civPos = [getPos _hostileCiv, (10 + ceil random 8)] call CBA_fnc_randPos;
							_markerName = format ["Localização de %1", name _hostileCiv];
							_marker = [str _civPos, _civPos, "ELLIPSE", [40, 40], "ColorRed", _markerName, "n_installation", "FDiagonal", 0, 0.5] call ALIVE_fnc_createMarkerGlobal;
							_text = [str (str _civPos),_civPos,"ICON", [0.1,0.1],"ColorRed",_markerName, "mil_dot", "FDiagonal",0,0.5] call ALIVE_fnc_createMarkerGlobal;
							[_marker,_text] spawn {sleep 30;deleteMarker (_this select 0);deleteMarker (_this select 1)};
						};
						case "1": {
							_response1 = " Vou te mostrar aonde ele vive (Casa marcada no mapa).";
							_response2 = " Eu sei aonde ele vive (Casa marcada no mapa).";
							_response3 = " Alguém me disse aonde ele vive (Casa marcada no mapa).";
							_response4 = " Vou te mostrar aonde você pode encontrá-lo (Casa marcada no mapa).";
							_response = [_response1, _response2, _response3,_response4] call BIS_fnc_selectRandom;
							SCI_ResponseList ctrlSetText ((ctrlText SCI_ResponseList) + _response);

							//-- Create marker on hostile civ location
							_markerName = format ["Casa de %1", name _hostileCiv];
							_marker = [str _homePos, _homePos, "ICON", [.35, .35], "ColorRed", _markerName, "mil_circle", "Solid", 0, .5] call ALIVE_fnc_createMarkerGlobal;
							_marker spawn {sleep 30;deleteMarker _this};
						};
					};
				};
			} else {
				if (floor random 100 > _hostility) then {
					_response1 = format ["Eu ouvi que %1 era %2.", name _hostileCiv, _activePlan];
					_response2 = format ["Alguém me disse que %1 era %2.", name _hostileCiv, _activePlan];
					_response3 = format ["Eu vi que %1 era %2.", name _hostileCiv, _activePlan];
					_response4 = format ["Eu acho que %1 era %2.", name _hostileCiv, _activePlan];
					_response5 = format ["Eu fui informado que %1 era %2.", name _hostileCiv, _activePlan];
					_response6 = format ["Me contaram que %1 era %2.", name _hostileCiv, _activePlan];
					_response = [_response1, _response2, _response3, _response4, _response5, _response6] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
					_answersGiven pushBack "StrangeBehavior";_answerGiven = true;
				} else {
					_response1 = "Não posso falar sobre isso.";
					_response2 = "Eles não querem que conversemos com vocês";
					_response3 = "Eu não posso te ajudar.";
					_response4 = "Não, eu não.";
					_response5 = "Eu não vi nada ultimamente";
					_response6 = "Não há perigo aqui.";
					_response7 = "Não tenho tempo pra isso.";
					_response = [_response1,_response2,_response3,_response4,_response5,_response6,_response7] call BIS_fnc_selectRandom;
					SCI_ResponseList ctrlSetText _response;
					_answersGiven pushBack "StrangeBehavior";_answerGiven = true;
				};
			};
		};
	};

	//-- What is your opinion of our forces
	case "Opinion": {
		private ["_response"];
		_personalHostility = _civInfo select 1;
		_townHostility = _civInfo select 2;

		if (((_townHostility / 2.5) > 45) and (floor random 100 > 25) and (_personalHostility < 50)) exitWith {
			_response1 = "Eles não gostariam de me ver falando com vocês.";
			_response2 = "Não posso falar sobre isso..";
			_response3 = "Por favor...me deixe em paz.";
			_response4 = "Não posso te ajudar.";
			_response5 = "Por favor, saia antes que eles te vejam.";
			_response6 = "Você deve sair imediatamente.";
			_response7 = "Eles não podem me ver contigo.";
			_response = [_response1, _response2, _response3, _response4, _response5, _response6,_response7] call BIS_fnc_selectRandom;
			SCI_ResponseList ctrlSetText _response;

			//-- Check if civilian is irritated
			["isIrritated", [_hostile,_asked,_civ]] call MAINCLASS;
		};

		if !(_hostile) then {
			if (floor random 100 < 70) then {

				//-- Give answer
				if (_personalHostility <= 25) then {
					_response1 = "Eu totalmente apoio vocês.";
					_response2 = "Você não terá problemas comigo.";
					_response3 = "Eu apoio sua causa.";
					_response4 = "Você não tem que se preocupar comigo.";
					_response5 = "Eu apoio totalmente a força de vocês.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((_personalHostility > 25) and (_personalHostility <= 50)) then {
					_response1 = "Eu apoio vocês.";
					_response2 = "Eu apoio vocês. Não estraguem.";
					_response3 = "Eu tenho muitos motivos para apoiar suas forças.";
					_response4 = "Vocês podem manter minha confiança.";
					_response5 = "Eu apoiei vocês por um tempo.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((_personalHostility > 50) and (_personalHostility <= 75)) then {
					_response1 = "Suas forças fizeram más decisões ultimamente.";
					_response2 = "Estou começando a desgostar vocês.";
					_response3 = "Vocês devem reconquistar minha confiança.";
					_response4 = "É melhor você não ficar muito.";
					_response5 = "Eu não apoio vocês.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((_personalHostility > 75) and (_personalHostility <= 100)) then {
					_response1 = "Eu sou totalmente contra a força de vocês aqui.";
					_response2 = "É melhor você ir embora.";
					_response3 = "Eu não apoio vocês.";
					_response4 = "Eu odeio suas forças.";
					_response5 = "Você tem que sair imediatamente.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if (_personalHostility > 100) then {
					_response1 = "Eu sou extremamente oposto a vocês.";
					_response2 = "Você não vai fazer nada aqui.";
					_response3 = "Você deve se retirar.";
					_response4 = "Se retire ou será retirado a força!";
					_response5 = "Quem apoiaria pessoas como vocês?";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((isNil "_response") or (isNil "_personalHostility")) then {_response = "Não quero falar agora."};
				SCI_ResponseList ctrlSetText _response;
				_answersGiven pushBack "Opinion";_answerGiven = true;
			} else {
				//-- Decline to answer
				_response1 = "Eu não quero falar nesse momento.";
				_response2 = "Não acho que deveria falar com você.";
				_response3 = "Não deveria falar com você.";
				_response4 = "Você tem que seguir.";
				_response5 = "Não posso responder isso.";
				_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
			};
		} else {
			if (floor random 100 > _personalHostility) then {
				//-- Give answer
				if (_personalHostility <= 25) then {
					_response1 = "Eu apoio vocês.";
					_response2 = "Você não terá problemas comigo.";
					_response3 = "Eu apoio sua causa.";
					_response4 = "Você não tem que se preocupar comigo.";
					_response5 = "Eu totalmente apoio a força de vocês.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((_personalHostility > 25) and (_personalHostility <= 50)) then {
					_response1 = "Eu apoio vocês.";
					_response2 = "Eu apoio vocês. Não estraguem.";
					_response3 = "Eu tenho muitos motivos para apoiar suas forças.";
					_response4 = "Vocês podem manter minha confiança.";
					_response5 = "Eu apoiei vocês por um tempo.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((_personalHostility > 50) and (_personalHostility <= 75)) then {
					_response1 = "Suas forças fizeram más decisões ultimamente.";
					_response2 = "Estou começando a desgostar vocês.";
					_response3 = "Vocês devem reconquistar minha confiança.";
					_response4 = "É melhor você não ficar muito.";
					_response5 = "Eu não apoio vocês.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((_personalHostility > 75) and (_personalHostility <= 100)) then {
					_response1 = "Eu sou oposto a vocês.";
					_response2 = "Você não vai fazer nada aqui.";
					_response3 = "Você deve se retirar.";
					_response4 = "Se retire ou será retirado a força!";
					_response5 = "Quem apoiaria pessoas como vocês?";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if (_personalHostility > 100) then {
					_response1 = "Eu sou extremamente oposto a vocês.";
					_response2 = "Você não vai fazer nada aqui.";
					_response3 = "Você deve se retirar.";
					_response4 = "Se retire ou será retirado a força!";
					_response5 = "Quem apoiaria pessoas como vocês?";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((isNil "_response") or (isNil "_personalHostility")) then {_response = "I don't want to talk right now"};
				SCI_ResponseList ctrlSetText _response;
				_answersGiven pushBack "Opinion";_answerGiven = true;
			} else {
				//-- Decline to answer
				_response1 = "Eu não quero falar agora.";
				_response2 = "Acho que não deveria estar falando com você.";
				_response3 = "Não deveria estar falando com você.";
				_response4 = "Você deve prosseguir.";
				_response5 = "Não posso responder isso.";
				_response6 = "Saia daqui!";
				_response = [_response1, _response2, _response3, _response4, _response5,_response6] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
			};
		};
	};

	//-- What is the general opinion of our forces in your town
	case "TownOpinion": {
		private ["_response"];
		_personalHostility = _civInfo select 1;
		_townHostility = _civInfo select 2;

		if (((_townHostility / 2.5) > 45) and (floor random 100 > 25) and (_personalHostility < 50)) exitWith {
			_response1 = "Eles não gostariam de me ver falando com vocês.";
			_response2 = "Não posso falar sobre isso..";
			_response3 = "Por favor...me deixe em paz.";
			_response4 = "Você está em perigo aqui.";
			_response5 = "Por favor, saia antes que eles te vejam.";
			_response6 = "Você deve sair imediatamente.";
			_response7 = "Eles não podem me ver contigo.";
			_response = [_response1, _response2, _response3, _response4, _response5, _response6,_response7] call BIS_fnc_selectRandom;
			SCI_ResponseList ctrlSetText _response;

			//-- Check if civilian is irritated
			["isIrritated", [_hostile,_asked,_civ]] call MAINCLASS;
		};

		//-- This really needs to be a switch, couldn't get it to work properly the first time
		if !(_hostile) then {
			if (floor random 100 < 70) then {

				//-- Give answer
				if (_townHostility <= 25) then {
					_response1 = "Você é muito respeitado por aqui.";
					_response2 = "Não acho que deveria se preocupar com nossa hostilidade aqui.";
					_response3 = "Nós te apoiamos.";
					_response4 = "Ajudaremos se puder.";
					_response5 = "Você é apoiado aqui.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((_townHostility > 25) and (_townHostility <= 50)) then {
					_response1 = "As tensões aumentaram ultimamente.";
					_response2 = "As pessoas aqui estão indecisas.";
					_response3 = "Temos sentimentos misturados por vocês.";
					_response4 = "Talvez você queira diminuir a hostilidade por aqui.";
					_response5 = "A maioria de nós apoia vocês.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((_townHostility > 50) and (_townHostility <= 75)) then {
					_response1 = "As tensões aumentaram consideravelmente.";
					_response2 = "As pessoas não gostam de você por aqui.";
					_response3 = "Você não é querido por aqui.";
					_response4 = "Talvez você não devesse ficar por aqui.";
					_response5 = "A maioria das pessoas não te apoiam.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((_townHostility > 75) and (_townHostility <= 100)) then {
					_response1 = "As tensões estão altas.";
					_response2 = "Cuidado com as pessoas aqui.";
					_response3 = "Você é fortemente contrariado por aqui.";
					_response4 = "Você não deveria ficar muito.";
					_response5 = "Poucos te apoiam.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if (_townHostility > 100) then {
					_response1 = "As tensões estão extremamente altas.";
					_response2 = "Se continuar por aqui, é provavel que te sigam.";
					_response3 = "Você é odiado por aqui.";
					_response4 = "Você deveria se retirar agora.";
					_response5 = "Quase ninguém te apoia aqui.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((isNil "_response") or (isNil "_townHostility")) then {_response = "I don't want to talk right now"};
				SCI_ResponseList ctrlSetText _response;
				_answersGiven pushBack "TownOpinion";_answerGiven = true;
			} else {
				//-- Decline to answer
				_response1 = "Eles não gostariam de me ver falando com vocês.";
				_response2 = "Não posso falar sobre isso..";
				_response3 = "Por favor...me deixe em paz.";
				_response4 = "Você está em perigo aqui.";
				_response5 = "Por favor, saia antes que eles te vejam.";
				_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
			};
		} else {
			if (floor random 100 > _personalHostility) then {
				//-- Give answer
				if (_townHostility <= 25) then {
					_response1 = "Você é muito respeitado por aqui.";
					_response2 = "Não acho que deveria se preocupar com nossa hostilidade aqui.";
					_response3 = "Nós te apoiamos.";
					_response4 = "Ajudaremos se puder.";
					_response5 = "Você é apoiado aqui.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((_townHostility > 25) and (_townHostility <= 50)) then {
					_response1 = "As tensões aumentaram ultimamente.";
					_response2 = "As pessoas aqui estão indecisas.";
					_response3 = "Temos sentimentos misturados por vocês.";
					_response4 = "Talvez você queira diminuir a hostilidade por aqui.";
					_response5 = "A maioria de nós apoia vocês.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((_townHostility > 50) and (_townHostility <= 75)) then {
					_response1 = "As tensões aumentaram consideravelmente.";
					_response2 = "As pessoas não gostam de você por aqui.";
					_response3 = "Você não é querido por aqui.";
					_response4 = "Talvez você não devesse ficar por aqui.";
					_response5 = "A maioria das pessoas não te apoiam.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((_townHostility > 75) and (_townHostility <= 100)) then {
					_response1 = "As tensões estão altas.";
					_response2 = "Cuidado com as pessoas aqui.";
					_response3 = "Você é fortemente contrariado por aqui.";
					_response4 = "Você não deveria ficar muito.";
					_response5 = "Poucos te apoiam.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if (_townHostility > 100) then {
					_response1 = "As tensões estão extremamente altas.";
					_response2 = "Se continuar por aqui, é provavel que te sigam.";
					_response3 = "Você é odiado por aqui.";
					_response4 = "Você deveria se retirar agora.";
					_response5 = "Quase ninguém te apoia aqui.";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
				};

				if ((isNil "_response") or (isNil "_townHostility")) then {_response = "I don't want to talk right now"};
				SCI_ResponseList ctrlSetText _response;
				_answersGiven pushBack "TownOpinion";_answerGiven = true;
			} else {
				//-- Decline to answer
				_response1 = "Eles não gostariam de me ver falando com vocês.";
				_response2 = "Não posso falar sobre isso..";
				_response3 = "Por favor...me deixe em paz.";
				_response4 = "Você deveria sair.";
				_response5 = "Por favor, saia antes que eles te vejam.";
				_response6 = "Saia daqui!";
				_response = [_response1, _response2, _response3, _response4, _response5,_response6] call BIS_fnc_selectRandom;
				SCI_ResponseList ctrlSetText _response;
			};
		};
	};

};

//-- Check if civilian is irritated
["isIrritated", [_hostile,_asked,_civ]] call MAINCLASS;

if (_answerGiven) then {
	[_civData, "AnswersGiven", _answersGiven] call ALiVE_fnc_hashSet;
	_civ setVariable ["AnswersGiven",_answersGiven];
	_civ setVariable ["AnswersGiven",_answersGiven, false]; //-- Broadcasting could bring server perf loss with high use (set false to true at risk)
};


/*
Threat outline

ADD THREATS THAT CAN LOWER OR RAISE HOSTILITY DEPENDING ON THE CIVILIANS CURRENT
HOSTILITY AND THE AMOUNT OF QUESTIONS ASKED ALREADY
THREATS TOWARDS LOW HOSTILITY CIVS COULD HAVE A HIGHER CHANCE OF RAISING HOSTILITY
WHILE THREATS TOWARDS HIGH HOSTILITY CIVS COULD HAVE A HIGHER CHANCE (MAKE IT BALANCED)

if (floor random 100 > _hostility) then {
	_hostility = ceil (_hostility / 3);
	_civInfo = [_civInfo select 0, _hostility, _civInfo select 2];
	[SCI_Logic, "CivInfo", _civInfo] call ALiVE_fnc_hashSet;
} else {
	if (floor random 100 > 20) then {
		_hostility = ceil (_hostility / 3);
		_civInfo = [_civInfo select 0, _hostility, _civInfo select 2];
		[SCI_Logic, "CivInfo", _civInfo] call ALiVE_fnc_hashSet;
	};
};
*/