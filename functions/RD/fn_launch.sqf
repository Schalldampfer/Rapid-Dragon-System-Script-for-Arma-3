/*
	Rapid Dragon System Launching Script by Schalldämpfer
	2023/4/23
	
	Usage: Eventhandler on launching a pallet from the plane
	_container addEventHandler ["CargoUnloaded", {
		_this spawn RapidDragon_fnc_launch;
	}];
*/
//if (isServer) then {systemChat _fnc_scriptName;};

params [["_vehicle",objNull],["_container",objNull]];

//Vehicle Check. Inert in cars & ships
if (!(_vehicle isKindOf "Air") || getPos _vehicle select 2 < 1) exitWith {
	systemChat format["Rapid Dragon Pallet %1 Unloaded", _container getVariable ["objID",getObjectID _container]];
};

//Altitude check. Revert if too low
if (getPos _vehicle select 2 < 500) exitWith {
	systemChat "Too low to launch Rapid Dragon. Pallet returned to cargo bay";
	sleep 1;
	_vehicle setVehicleCargo _container;
};

//Initialize Variables
private _ammo = _container getVariable ["missileType","ammo_Missile_Cruise_01"];
private _side = west;

if (local _container) then { //Execute in local

	// // Initial Sequence

	//Find Parachute
	sleep 0.2;
	private _para = nearestObject [_container, "B_Parachute_02_F"];

	//Attach
	if (!isNull _para) then {_container attachTo [_para, [0,-2.5,0]];};
	//if (!isNull _para) then {deleteVehicle _para;};

	//Container
	if (!isNull _para) then {_para setVelocity [0,0,-10];};
	_container setVectorUp [0,-0.7,0.3]; //Missiles to be Downward

	//Acquire Targets
	_targets = _container getVariable ["missileTargets",[]];
	//ToDo: Assign another target if Null or less than 6

	//Wait a bit
	sleep 7;

	// // Launching Sequence
	private _fakeMissiles = _container getVariable ["visibleMissiles",[]];
	private _missiles = [];
	{
		//Get Target (Object)
		private _target = _x;
		
		//Get Fake Missile
		private _fakeMissile = _fakeMissiles select _forEachIndex;
		
		//Spawn missiles
		private _missile = _ammo createVehicle [0,0,0];
		
		//Set Initial Position
		_missile setPosASL (getPosASL _container vectorAdd [0,0,-7]);
		
		//Set Initial Direction
		_missile setVectorDirAndUp [(vectorDir _fakeMissile) vectorMultiply -1 vectorAdd [random 0.1,random 0.1,random 0.1], vectorUp _fakeMissile]; //Somehow Opposite Direction
		
		//Add Initial Speed //Free Falling seems to be enough
		_missile setVelocity (velocity _container vectorAdd ((vectorDir _fakeMissile) vectorMultiply -10));
		
		//Set Information
		if (!isNull effectiveCommander _vehicle) then {
			_missile setShotParents [_vehicle, effectiveCommander _vehicle];
		};
		
		//Delete fake Missiles
		deleteVehicle _fakeMissile;
		
		//Debug Marker on missile and target
		/*
		[_missile,_target] spawn {
			params["_msl","_tgt"];
			private _marker = createMarker [format["S_Tgt_%1",_tgt], getPos _tgt];
			_marker setMarkerShape "ICON";
			_marker setMarkerType "hd_dot";
			_marker setMarkerColor "ColorEAST";
			private _marker2 = createMarker [format["S_Missile_%1",_msl], getPos _msl];
			_marker2 setMarkerShape "ICON";
			_marker2 setMarkerType "mil_triangle";
			_marker2 setMarkerColor "ColorWEST";
			while {alive _msl} do {
				_marker setMarkerPos (getPos _tgt);
				_marker setMarkerDir (getDir _tgt);
				_marker2 setMarkerPos (getPos _msl);
				_marker2 setMarkerDir (getDir _msl);
				sleep .75;
			};
			deleteMarker _marker;
			deleteMarker _marker2;
		};
		*/
	
		//List up Missiles
		_missiles pushBack _missile;
	
		//Sleep a bit
		sleep 0.15;
	} forEach _targets;
	
	//Wait a bit
	sleep 2;

	// // Homing Sequence
	//Now Missiles are away.
	
	//Direct missiles toward targets
	{
		_target = _x;
		_missile = _missiles select _forEachIndex;
		[_missile, _target] spawn RapidDragon_fnc_missile_cruise;
		sleep 0.05;
	} forEach _targets;
	
	//Wait a bit
	sleep 3;

	//Kill Container
	_container setDamage 1;
	//if (!isNull _para) then {_para setDamage 1; detach _container;};
};
