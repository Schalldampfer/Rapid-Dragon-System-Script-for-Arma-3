/*
	Rapid Dragon System GUI Definition by Schalldämpfer 2023/4/25
*/
/*
#Soqeva
$[
	1.063,
	["RapidDragonCruiseMissileControl",[[0,0,1,1],0.025,0.04,"GUI_GRID"],1,0,0],
	[1800,"RD_ui_OuterFrame",[1,"",["0.298906 * safezoneW + safezoneX","0.236 * safezoneH + safezoneY","0.402187 * safezoneW","0.528 * safezoneH"],[-1,-1,-1,-1],[0,0,0,1],[0.2,0.2,0.2,1],"","-1"],[]],
	[1200,"RD_ui_Background",[1,"#(argb,8,8,3)color(0.5,0.5,0.5,0.5)",["0.304062 * safezoneW + safezoneX","0.247 * safezoneH + safezoneY","0.391875 * safezoneW","0.506 * safezoneH"],[-1,-1,-1,-1],[0,0,0,1],[0.5,0.5,0.5,1],"","-1"],[]],
	[1201,"RD_ui_Map",[1,"#(argb,8,8,3)color(1,1,1,1)",["0.412344 * safezoneW + safezoneX","0.291 * safezoneH + safezoneY","0.273281 * safezoneW","0.44 * safezoneH"],[-1,-1,-1,-1],[0,0,0,1],[0.5,0.5,0.5,1],"","-1"],[]],
	[1100,"RD_ui_title",[1,"Rapid Dragon Console",["0.412344 * safezoneW + safezoneX","0.245 * safezoneH + safezoneY","0.170156 * safezoneW","0.044 * safezoneH"],[1,1,1,1],[0,0.5,0.5,0.5],[-1,-1,-1,-1],"","-1"],[]],
	[1001,"RD_ui_pallet",[1,"Pallet XXXXX",["0.309219 * safezoneW + safezoneX","0.270 * safezoneH + safezoneY","0.085 * safezoneW","0.044 * safezoneH"],[1,1,1,1],[0,0,0,1],[-1,-1,-1,-1],"","-1"],[]],
	[1500,"RD_ui_MissileSelection",[1,"Missile Selection",["0.309219 * safezoneW + safezoneX","0.320 * safezoneH + safezoneY","0.0876563 * safezoneW","0.044 * safezoneH"],[0,0,0,1],[0.2,0.2,0.2,1],[1,1,1,1],"","-1"],[]],
	[1000,"RD_ui_Location",[1,"123456",["0.309219 * safezoneW + safezoneX","0.370 * safezoneH + safezoneY","0.085 * safezoneW","0.044 * safezoneH"],[0,0,0,1],[1,1,1,1],[0.7,0.7,0.7,1],"","-1"],[]],
	[2600,"RD_ui_closeOK",[1,"CLOSE",["0.314375 * safezoneW + safezoneX","0.709 * safezoneH + safezoneY","0.0464063 * safezoneW","0.030 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/

import RscText;
import RscStructuredText;
import RscFrame;
import RscPicture;
import RscMapControl;
//import RscListBox;
import RscCombo;
import RscButtonMenuOK;

class RD_ui_Main_Dialog
{
	idd=-1;
	name="RD_ui_Main_Dialog";
	movingEnable=0;
	duration = 1e+011;
	onLoad="[0] call RapidDragon_fnc_dialog_control";
	onUnload="[1] call RapidDragon_fnc_dialog_control";
	class controlsBackground {
		class RD_ui_OuterFrame: RscFrame
		{
			idc = 1800;
			x = 0.298906 * safezoneW + safezoneX;
			y = 0.236 * safezoneH + safezoneY;
			w = 0.402187 * safezoneW;
			h = 0.528 * safezoneH;
			colorBackground[] = {0,0,0,1};
			colorActive[] = {0.2,0.2,0.2,1};
		};
		class RD_ui_Background: RscPicture
		{
			idc = 1200;
			text = "a3\structures_f\items\electronics\data\electronics_screens_laptop_co.paa"; //"#(argb,8,8,3)color(0.5,0.5,0.5,0.5)";
			x = 0.304062 * safezoneW + safezoneX;
			y = 0.247 * safezoneH + safezoneY;
			w = 0.391875 * safezoneW;
			h = 0.506 * safezoneH;
			colorBackground[] = {0,0,0,1};
			colorActive[] = {0.5,0.5,0.5,1};
		};
		class RD_ui_title: RscStructuredText
		{
			idc = 1100;
			text = "<t color='#ff0000' size='1.25' align='center' font='Caveat'>Rapid Dragon Console</t><br/><t color='#00cc99' size='0.75' align='right'>Click map to assign target</t>"; //--- ToDo: Localize;
			x = 0.412344 * safezoneW + safezoneX;
			y = 0.245 * safezoneH + safezoneY;
			w = 0.170156 * safezoneW;
			h = 0.044 * safezoneH;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0.15,0.25,0.25,0.75};
		};
	};
	class controls {
		class RD_ui_Map: RscMapControl
		{
			idc = 1201;
			text = "#(argb,8,8,3)color(1,1,1,1)";
			x = 0.412344 * safezoneW + safezoneX;
			y = 0.291 * safezoneH + safezoneY;
			w = 0.273281 * safezoneW;
			h = 0.44 * safezoneH;
			colorBackground[] = {0.92,0.92,0.90,1};
			colorActive[] = {0.5,0.5,0.5,1};
			colorOutside[] = {0,0.18,0.33,1};
			
			maxSatelliteAlpha = 0.5;
			sizeEx = 0.04;
			sizeExGrid = 0.0375;
			sizeExInfo = 0;
			sizeExLabel = 0;
			sizeExLevel = 0.03;
			sizeExNames = 0.05;
			sizeExUnits = 0.01;
			
			stickX[] = {0.2,["Gamma",1,1.5]};
			stickY[] = {0.2,["Gamma",1,1.5]};
			
			drawObjects = 0.75;
			drawShaded = 0.2;
			shadedSea = 1;
			
			ptsPerSquareFor = 2.8;
			ptsPerSquareForEdge = 4;
			ptsPerSquareForLod1 = 2;
			ptsPerSquareForLod2 = 1;
			ptsPerSquareMainRoad = 4;
			ptsPerSquareMainRoadSimple = 1;
			ptsPerSquareExp = 10;
			ptsPerSquareObj = 200;
			ptsPerSquareObjLod1 = 200;
			ptsPerSquareRoad = 5.5;
			ptsPerSquareRoadSimple = 1;
			ptsPerSquareTxt = 18;
			
			colorInactive[] = {1,1,1,0.5};
			colorNames[] = {0.1,0.1,0.1,0.5};
			colorLevels[] = {0.68,0.43,0.27,0};
			
			colorGrid[] = {0.1,0.1,0.1,0.4};
			colorGridMap[] = {0.1,0.1,0.1,0.4};
		
			colorSea[] = {0,0.27,0.50,0.3};
			
			colorForest[] = {0.56,0.81,0,0};
			colorForestBorder[] = {0.22,0.50,0,0};
			colorForestTextured[] = {0.624,0.78,0.388,0};
			colorRocks[] = {0.33,0.33,0.33,0};

			colorMainCountlines[] = {0.73,0.48,0.31,0};
			colorCountlines[] = {0.73,0.48,0.31,0};
			colorMainCountlinesWater[] = {0,0.27,0.50,0};
			colorCountlinesWater[] = {0,0.27,0.50,0};
			
			widthRailWay = 10;
			colorRailWay[] = {0.8,0.2,0,0};
			
			colorMainRoads[] = {0.88,0.31,0,0};
			colorMainRoadsFill[] = {1,0.48,0.16,0};
			
			colorRoads[] = {0.74,0.59,0,0};
			colorRoadsFill[] = {1,1,0,0};
			
			colorTracks[] = {0,0,0,0};
			colorTracksFill[] = {0.69,0.69,0.69,0};

			colorTrails[] = {0.51,0.41,0.33,0};
			colorTrailsFill[] = {0.51,0.41,0.33,0};
		};
		class RD_ui_pallet: RscText
		{
			idc = 1001;
			text = "Pallet XXXXX"; //--- ToDo: Localize;
			x = 0.309219 * safezoneW + safezoneX;
			y = 0.270 * safezoneH + safezoneY;
			w = 0.085 * safezoneW;
			h = 0.044 * safezoneH;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0,0,0,1};
			font = "PuristaMedium";
		};
		class RD_ui_MissileSelection: RscCombo
		{
			idc = 1500;
			text = "Missile Selection"; //--- ToDo: Localize;
			x = 0.309219 * safezoneW + safezoneX;
			y = 0.320 * safezoneH + safezoneY;
			w = 0.0876563 * safezoneW;
			h = 0.044 * safezoneH;
			colorText[] = {1,1,1,1};
			colorBackground[] = {0.2,0.2,0.2,1};
			colorActive[] = {0.25,0.25,0.25,1};
			font = "PuristaMedium";
			sizeEx = 0.030 * safezoneH;
		};
		class RD_ui_Location: RscText
		{
			idc = 1000;
			text = "000000"; //--- ToDo: Localize;
			x = 0.309219 * safezoneW + safezoneX;
			y = 0.370 * safezoneH + safezoneY;
			w = 0.085 * safezoneW;
			h = 0.044 * safezoneH;
			align = "center";
			colorText[] = {0,1,0,1};
			colorBackground[] = {0,0,0,1};
			colorActive[] = {0,0,0,1};
			font = "LCD14";
			sizeEx = 0.04 * safezoneH;
		};
		class RD_ui_closeOK: RscButtonMenuOK
		{
			text = "CLOSE"; //--- ToDo: Localize;
			x = 0.314375 * safezoneW + safezoneX;
			y = 0.709 * safezoneH + safezoneY;
			w = 0.045 * safezoneW;
			h = 0.030 * safezoneH;
			align = "center";
		};
	};
};
