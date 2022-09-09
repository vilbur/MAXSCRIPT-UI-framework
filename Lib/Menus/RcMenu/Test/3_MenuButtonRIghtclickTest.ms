clearListener()

filein ( getFilenamePath(getSourceFileName()) + "/../RcMenu.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../../../Dialog/Rollout/Rollout.ms" )

/* ROLLOUT DEFINITION */
_Rollout	= Rollout_v title:(filenameFromPath(getSourceFileName()))

/* DEFINE MAIN MENU */
global Menu = Menu_v name:"ButtonRcMenu"

/* DEFINE MENU */
menu_1	= Menu.menu "Menu 1"


/** MENU ITEMS 
 */
menu_1.item "Item 1" "messagebox \"Item 1\""


/* CONTROLS */
Controls	= _Rollout.controls.Roll groupbox:"Test Groupbox"
Button_LMB = Controls.button "Menu LMB"
Button_RMB = Controls.button "Menu RMB"


/* -----------------------------------------------------------------

	SET MENU TO CONTROL
	
	
----------------------------------------------------------------- */
Button_LMB.setMenu Menu event:#pressed
Button_RMB.setMenu Menu


/* CREATE ROLLOUT */
_Rollout.createRollout()

/* CREATE DIALOG */
CreateDialog ( _Rollout.RolloutCreator.getDefinition() ) width:640 height:512

_Rollout.addSubRollouts() -- dialog must exist for adding subrollouts