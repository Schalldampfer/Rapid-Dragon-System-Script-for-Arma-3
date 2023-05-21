/*
	Cruise Missile Guidance Script by Schalldämpfer
	2023/4/24
	Guide a missile to a target(object).
	Usage:
	[_missile, _target] spawn RapidDragon_fnc_missile_cruise;
*/
//if (isServer) then {systemChat _fnc_scriptName;};

params [["_missile",objNull],["_target",[0,0,0]]];

if (!local _missile) exitWith {}; //Execute in local

//Initialize Variables
private _timestep = 0.1;

private _dir = getDir _missile;
private _dirTo = _dir;
private _pitchBank = _missile call BIS_fnc_getPitchBank;
private _pitch = _pitchBank select 0;
private _bank = _pitchBank select 1;
private _pitchTo = _pitch;
private _height = getPosATL _missile select 2;
private _heightTo = 25 + random (5);

//ASM capability
private _target_ship = objNull; //Target ship if existis
private _targets = [];

//Homing to target
while {isNull missileTarget _missile} do { //Until missile's own guidance system activates
	//Wait
	sleep _timestep;
	
	//Update Status
	_dir = getDir _missile;
	_pitchBank = _missile call BIS_fnc_getPitchBank;
	_pitch = _pitchBank select 0;
	_bank = _pitchBank select 1;
	_height = getPos _missile select 2;
	
	//Calculate Target Direction & Pitch depending on status of homing
	_dirTo = _missile getDir _target;
	_pitchTo = [getPos _missile,_target] call RapidDragon_fnc_pitchtoTgt;
	//hintSilent format["Dir:%1  DirTo:%2 Pitch:%3 PitchTo:%4",_dir,_dirTo, _pitch, _pitchTo];
	if (_height > _heightTo * 2) then {_dirTo = _dir;}; //Don't change course untill getting low altitude
	
	//Change mode  distance
	//<2km - Search for ships.
	if (_missile distance _target < 2000) then {
		//Search for ships within 250m from initial target
		if(isNull _target_ship) then {
			_targets = (_target nearEntities [["Ship"], 250]) select {alive _x};
			//Select Target
			if(count _targets >0) then {
				//_target_ship = selectRandom _targets;
				private _weight = [];
				{
					private _size = (boundingBox _x) select 2;
					private _rcs = getNumber (configFile >> "CfgVehicles" >> typeOf _x >> "radarTargetSize");
					_weight set [_forEachIndex, _size * (_rcs + 1)];
					//systemChat format["%1: Size %2 RCS %3",typeOf _x, _size, _rcs];
				} forEach _targets;
				_target_ship = _targets selectRandomWeighted _weight;
				//systemChat format["Target: %2 %1",_target_ship, _weight];
				
				//Pop-up
				if (_heightTo < 75) then {_heightTo = 75 + random (15);}; //pop-up once. ToDo:Only do this in ASM mode
			};
		};
		//Update targt position if missile finds any target
		if(!isNull _target_ship) then {
			_target = getPos _target_ship;
		};
	};
	
	//>250m - Cruise. Adjust pitch to follow Terrain
	if (_missile distance _target > 250) then {
		_pitchTo = -45 * ((((_height-_heightTo)/_heightTo ) min 1) max -1);
 	};
	
	//Adjust Direction
	private _diffDir = _dirTo - _dir;
	if (_diffDir > 180) then {_diffDir= _diffDir - 360};
	if (_diffDir < -180) then {_diffDir= _diffDir + 360};
	if(abs(_diffDir)>5) then {_dir = _dir + _diffDir/5;};
	if(abs(_diffDir)>0) then {_dir = _dir + _diffDir/abs(_diffDir);};
	_missile setDir _dir;
	
	//Adjust Pitch&Bank
	private _diffPitch = _pitchTo - _pitch;
	if (abs(_diffPitch)>5) then {_pitch = _pitch + _diffPitch/4;};
	if (abs(_diffPitch)>0) then {_pitch = _pitch + _diffPitch/abs(_diffPitch);};
	if (abs(_bank)>1) then {_bank = _bank - _bank/abs(_bank);};
	[_missile, _pitch, _bank] call BIS_fnc_setPitchBank;
};
