# Rapid Dragon System Script for Arma 3
This script system implements a simplified Rapid Dragon system, a pallet system to drop and launch cruise missiles from a transport plane, for Arma 3.

A test mission (rapidDragon.Altis) included.
2023/4/26 created by Schalldämpfer

# License:
Arma Public License Share Alike (APL-SA).
http://www.bistudio.com/community/licenses/arma-public-license-share-alike

With this licence you are free to adapt (i.e. modify, rework or update) and share (i.e. copy, distribute or transmit) the material under the following conditions:
* Attribution - You must attribute the material in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the material).
* Noncommercial - You may not use this material for any commercial purposes.
* Arma Only - You may not convert or adapt this material to be used in other games than Arma.
* Share Alike - If you adapt, or build upon this material, you may distribute the resulting material only under the same license.

# Installation:
0. Copy&paste whole `functions` folder into your mission or addon.
There will be `functions\RD\` folder.
1. Merge contents in `description.ext`:
Add this code into your CfgFunctions block.
```cpp
	#include "functions\RD\fnc_rapidDragon.hpp"
```
Then, add this code into the root.
```sqf
#include "functions\RD\gui_rapidDragon.hpp"
```

2. Implementation in mission:
Create a HEMTT Rack (Contact DLC) in 3DEN editor and add this code in init window of Attributes for the rack.
```sqf
[this] call RapidDragon_fnc_init;
```
This will make the rack a Rapid Dragon Pallet with 6 Venator Cruise Missile (Jets DLC).
(If you don't have the DLCs, you can change them to any loadable object and any slow missile.)

If you have installed [USAF mod](https://steamcommunity.com/workshop/filedetails/?id=2397360831) then you can use the AGM-158 JASSM.
In this case the init line will be
```sqf
[this,'USAF_AGM158_LGB'] call RapidDragon_fnc_init;
```

If want to use the code out of init line of the pallet, 
you need to execute the code in both a server and all clients, 
by `remoteExec` as the script works different in servers and clients.

# How to use in-game:
1. Set Target:
* Get close to a pallet, or get in a plane which you (manually) loaded the pallets.
* Choose "Rapid Dragon Target Designation" action in the action menu.
* Select a missile from the pull down menu at top left of the GUI.
* Then click the small map to set the coordinate which you want shoot the missile at - The missile will target the position.
* You need to select all target locations for each missiles.

2. Load Pallets:
* Get close to a pallet on ground.
* Choose "Load Rapid Dragon" action in the action menu.
* The pallet will be immediately loaded into a plane nearby (within 30m). If there is no plane, then it is loaded onto a car (so that you can move it somewhere).
* If you are grounded, you can unload it in the vehicle.

* The plane should have VIV capacity enough to hold the pallet.
* If you use a smaller pallet, you can load many missiles in a plane.

* Do not use USAF's loading action and/or ACE3's cargo.
* Pallet's won't launch missiles on unloading from ACE3 cargo.

3. Launch the missiles:
* After you take off, select "Launch Rapid Dragon" action to drop one or "Unload all vehicles" to drop all pallets.
* After some seconds, the pallet will release the missiles and they go boom!
