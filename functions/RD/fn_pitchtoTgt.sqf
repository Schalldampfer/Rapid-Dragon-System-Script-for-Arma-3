/*
	Author: Dankan37
	Function: Returns pitch needed to aim a target.
	USAGE:
	Params:
	[startingPoint, target] spawn Dan_fnc_CruiseMissile / or ExecVM "fn_cruiseMissile.sqf";

	-startingPoint i
	-direction is the where the missile is gonna come from.

	NOTE: You may reuse this script in any of your missions or server, you may tweak this as you please and there's no need to credit me, as long as you don't claim it as yours.
*/


_pointOne = param [0];
_pointTwo = param [1];

//Getting the altitudes
_altitudeOne = ((getPosASL _pointOne) select 2);
_altitudeTwo = ((getPosASL _pointTwo) select 2);

//Getting the greatest and lowest of the two
_greatest = [_altitudeOne,_altitudeTwo] call BIS_fnc_greatestNum;
_lowest = [_altitudeOne,_altitudeTwo] call BIS_fnc_lowestNum;

//Altitude diff.
_altittudeDiff = _greatest - _lowest;

//Getting distance
_distance = _pointOne distance _pointTwo;

//Calculating pitch
dist3d = sqrt (_distance ^ 2 + _altittudeDiff ^ 2); //Pytagora
pitchTgt = -acos (_distance / dist3d); //Returning the angle //Fixed.

pitchTgt
