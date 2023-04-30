/*
	Rapid Dragon System Targeting Dialog Control Script by Schalldämpfer
	2023/4/25

	Usage:
	private _disp = findDisplay 46 createDisplay 'RD_ui_Main_Dialog'; //Open Dialog
	[2,_pallet,_disp] spawn RapidDragon_fnc_dialog_control; //SetUp Dialog with RD pallet as _pallet
*/
params [["_mode",1],["_container",objNull],["_disp",objNull]];

switch _mode do {
	case 0: { //onLoad (Initialization)
		//systemChat "Dialog Opened";
		uiNamespace setVariable ['RD_ui_Main_Dialog', _this select 0];
		RD_Markers = []; //Array of Marker
	};
	case 1: { //onUnLoad (De-initialization)
		//systemChat "Dialog Closed";
		uiNamespace setVariable ['RD_ui_Main_Dialog', nil];
		
		//Remove Function
		onMapSingleClick '';

		//Delete Markers
		{deleteMarkerLocal _x;} forEach RD_Markers;
	};
	case 2: { //Main Console
		//systemChat "Dialog Running";
		
		private _targets = _container getVariable ["missileTargets",[objNull,objNull,objNull,objNull,objNull,objNull]];
		
		//Pallet Info
		(_disp displayCtrl 1001) ctrlSetText format["Pallet %1", _container getVariable ["objID",getObjectID _container]];
		
		//Show each Missile's data
		private _ui_missileSelection = _disp displayCtrl 1500; //RD_ui_MissileSelection
		private _ui_coordinate =  _disp displayCtrl 1000; //RD_ui_Location
		for "_i" from 1 to 6 do {
			_ui_missileSelection lbAdd format["Missile %1",_i];
			private _marker = createMarkerLocal [format["RD_Missile_%1",_i], [0,0,0]];
			RD_Markers pushBack _marker;
			_marker setMarkerShapeLocal "ICON";
			_marker setMarkerTypeLocal "selector_selectedEnemy";
			_marker setMarkerColorLocal "ColorEAST";
			_marker setMarkerTextLocal format["Target (Missile %1)",_i];
			_marker setMarkerSizeLocal [0.5,0.5];
			private _target = _targets select (_i-1);
			if (!isNull _target) then {
				_marker setMarkerPosLocal (getPos _target);
			};
		};
		
		//Initial Selection and data
		_ui_missileSelection lbSetCurSel 0;
		_ui_missileSelection ctrlCommit 0;
		_ui_coordinate ctrlSetText (mapGridPosition (_targets select 0));
		
		//Click Ctrl -> Update Coordinate
		_ui_missileSelection ctrlAddEventHandler ["LBSelChanged", {
			//systemChat str(_this);
			(ctrlParent (_this select 0) displayCtrl 1000) ctrlSetText (mapGridPosition (getMarkerPos format["RD_Missile_%1",(_this select 1)+1]));
		}];
	
		//Map Click -> Get Current Missile, Get Coordinates, Create target and set it as target, Move Marker
		[_disp, _container] onMapSingleClick {
			//Initialize
			private _disp = _this select 0;
			private _ui_missileSelection = _disp displayCtrl 1500; //RD_ui_MissileSelection
			private _ui_coordinate = _disp displayCtrl 1000; //RD_ui_Location
			private _container = _this select 1;
			
			private _current = lbCurSel _ui_missileSelection; //Current Missile
			
			//Move Target
			private _targets = _container getVariable ["missileTargets",[]];
			private _target = _targets select _current;
			if (isNull _target) then { //If target is deleted, create again
				_target = "Land_Battery_F" createVehicle [0,0,0];
				_target allowDamage false;
				_target enableSimulationGlobal false;
				_targets set [_current, _target];
				_container setVariable ["missileTargets",_targets,true];
				systemChat "Targeting issue detected. Report to the mission editor.";
			};
			_target setPos [round(_pos select 0), round(_pos select 1), 0];
			_ui_coordinate ctrlSetText (mapGridPosition _pos);
			
			//Move Marker
			format["RD_Missile_%1",_current+1] setMarkerPos _pos;
			
			//systemChat format["Missile(%1)",_current,_pos];
		};
		
	};
	default {};
};