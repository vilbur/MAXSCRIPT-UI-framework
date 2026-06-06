clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../include-menus.ms" )	--"./../../include-menus.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../../Dialog/Rollout/Rollout.ms" )

/* ROLLOUT DEFINITION */
_Rollout	= Rollout_v title:(filenameFromPath(getSourceFileName()))

/* DEFINE MAIN MENU */
global Menu = RcMenu_v name:"ButtonRcMenu"

/* DEFINE MENU */
menu_1	= Menu.menu "Menu 1"


/** MENU ITEMS 
 */
menu_1.item "Item 1" "messagebox \"Item 1\""


/* CONTROLS */
Controls	= _Rollout.controls groupbox:"Test Groupbox"
Button_LMB = Controls.Control #button "Menu LMB"
Button_RMB = Controls.Control #button "Menu RMB"


/* -----------------------------------------------------------------

	SET MENU TO CONTROL
	
	
----------------------------------------------------------------- */
Button_LMB.setMenu Menu event:#pressed
Button_RMB.setMenu Menu


/* CREATE ROLLOUT */
_Rollout.createRollout()

/* CREATE DIALOG */
CreateDialog ( _Rollout.RCI.def) ) width:640 height:512

_Rollout.addSubRollouts() -- dialog must exist for adding subrollouts