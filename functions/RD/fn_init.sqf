/*
	Rapid Dragon System Initialization Script by Schalldämpfer
	2023/4/23
	
	Usage: In init line of a cargo container
	[this, "Ammo classname"] call RapidDragon_fnc_init;
	I prefer USAF's AGM158; [this,'USAF_AGM158_LGB'] call RapidDragon_fnc_init;
	If you create the container in a server-side script, this function should be called with remoteExec
*/
//if (isServer) then {systemChat _fnc_scriptName;};

params [["_container",objNull],["_ammo","ammo_Missile_Cruise_01"]];

if (isServer) then { //Global commands
	//Initial Parameters
	_container setVariable ["missileType",_ammo,true];

	private _positions = switch _ammo do {
		case "ammo_Missile_Cruise_01": {[
			[0.4,1,.1],
			[-.1,1,.1],
			[-.6,1,.1],
			[0.5,1,-.4],
			[0,1,-.4],
			[-.5,1,-.4]
		]};
		case "USAF_AGM158_LGB": {[
			[0.5,0,.15],
			[0,0,.15],
			[-.5,0,.15],
			[0.5,.7,-.3],
			[0,.7,-.3],
			[-.5,.7,-.3]
		]};
		case "FIR_AGM158B": {[
			[0.5,0,.15],
			[0,0,.15],
			[-.5,0,.15],
			[0.5,.7,-.3],
			[0,.7,-.3],
			[-.5,.7,-.3]
		]};
		default {[
			[0.5,1,0],
			[0,1,0],
			[-.5,1,0],
			[0.5,1,-.5],
			[0,1,-.5],
			[-.5,1,-.5]
		]};
	};

	//Load fake Missiles
	_fakeMissiles = [];
	{
		private _fakeMissile = createSimpleObject [_ammo,[0,0,0]];
		_fakeMissile attachTo [_container,_x];
		_fakeMissiles pushBack _fakeMissile;
	} forEach _positions;
	_container setVariable ["visibleMissiles",_fakeMissiles,true]; //Log Missiles
	
	//Create Invisible Targets
	private _targets = [];
	for "_i" from 1 to 6 do {
		_targets pushBack (createSimpleObject ["Land_Battery_F", [0,0,0]]);
	};
	{_x allowDamage false; _x enableSimulationGlobal false;} forEach _targets;
	_container setVariable ["missileTargets",_targets,true];
	
	
	//Implement Launching Sequence. Assign Eventhandler on Unloading
	_container addEventHandler ["CargoUnloaded", {
		params ["_parent", "_cargo"];
		//Remove Assigned Actions to _parent for this pallet
		private _actions = _cargo getVariable ["RD_loadedAction",[]];
		if (count _actions > 0) then {{_parent removeAction _x;} forEach _actions;};
		
		//Launching Sequence
		_this spawn RapidDragon_fnc_launch;
	}];
	
};

//Create Tag
private _objID = getObjectID _container;
private _objID36arry = [];
private _num = parseNumber _objID;
while {_num > 0} do {
 _objID36arry pushBack (_num % 36);
 _num = floor (_num / 36);
};
private _strlist = "0123456789abcdefghijklmnopqrstuvwxyz";
{_objID36arry set [_forEachIndex, _strlist select [_x,1]];} forEach _objID36arry;
private _objID36str = _objID36arry joinString "";
_container setVariable ["objID",_objID36str,false];

if (!isDedicated) then { //Player commands
	//Initial Parameters
	
	_container addEventHandler ["CargoLoaded", {
		params ["_parent", "_cargo"];
		//Add targeting actions (plane)
		private _tgtAct = _parent addAction [
			format["<t color='#BB0099'>Rapid Dragon Target Designation</t> : Pallet %1", _cargo getVariable ["objID",getObjectID _cargo]],
			{
				params ["_target", "_caller", "_actionId", "_arguments"];
				//Open Dialog
				private _disp = findDisplay 46 createDisplay 'RD_ui_Main_Dialog';
				
				//SetUp Dialog
				[2,_arguments select 0,_disp] spawn RapidDragon_fnc_dialog_control;
			},
			[_cargo],
			1.1,
			true,
			false,
			"",
			"_this == effectiveCommander _target",
			50,
			false
		];
		
		//Add launching actions for each pallet (plane)
		private _lncAct = _parent addAction [
			format[if(_parent isKindOf "Air") then {"<t color='#EE9900'>Launch Rapid Dragon</t> : Pallet %1"} else {"<t color='#0099BB'>Unload Rapid Dragon</t> : Pallet %1"}, _cargo getVariable ["objID",getObjectID _cargo]],
			{
				params ["_target", "_caller", "_actionId", "_arguments"];
				//Unload this Container
				objNull setVehicleCargo (_arguments select 0);
			},
			[_cargo],
			1.0,
			true,
			false,
			"",
			"_this == effectiveCommander _target",
			50,
			false
		];
		
		//Log Actions
		_cargo setVariable ["RD_loadedAction",[_tgtAct,_lncAct],false];
	}];
	
	//Add targeting actions (landed)
	_container addAction [
		format["<t color='#BB0099'>Rapid Dragon Target Designation</t> : Pallet %1", _container getVariable ["objID",getObjectID _container]],
		{
			params ["_target", "_caller", "_actionId", "_arguments"];
			//Open Dialog
			private _disp = findDisplay 46 createDisplay 'RD_ui_Main_Dialog';
			
			//SetUp Dialog
			[2,_target,_disp] spawn RapidDragon_fnc_dialog_control;
		},
		nil,
		1.5,
		true,
		false,
		"",
		"isNull isVehicleCargo _target", //Disabled when loaded.
		10,
		false
	];
	//Targeting information should be globally shared


	//Add Loading actions
	_container addAction [
		format["<t color='#0099BB'>Load Rapid Dragon</t> : Pallet %1", _container getVariable ["objID",getObjectID _container]],
		{
			params ["_target", "_caller", "_actionId", "_arguments"];
			//Find Nearest Vehicle with Cargo capacity
			private _carrier = objNull;
			{
				if ((_x canVehicleCargo _target) select 0) exitWith {_carrier = _x};
			} forEach ((nearestObjects [getPos _target, ["Air"], 30]) + (nearestObjects [getPos _target, ["AllVehicles"], 20]));
			
			//Load
			if (!isNull _carrier) then {
				_carrier setVehicleCargo _target;
				systemChat format["Rapid Dragon Pallet %1 Loaded to %2", _target getVariable ["objID",getObjectID _target], typeOf _carrier];
			} else {
				systemChat "No suitable vehicle nearby";
			};
		},
		nil,
		1.5,
		true,
		false,
		"",
		"isNull isVehicleCargo _target", //Disabled when loaded.
		10,
		false
	];
	
};