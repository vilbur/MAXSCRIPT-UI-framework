clearListener()

filein ( getFilenamePath(getSourceFileName()) + "/../RcMenu.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../../../Dialog/Rollout/Rollout.ms" )


/* ROLLOUT DEFINITION */
_Rollout	= Rollout_v title:(getFilenameFile(getSourceFileName())) id:"optionable_id"

/* CREATE ROLLOUT */
_Rollout.createRollout()


/** CREATE MENU 
 */
Menu = Menu_v() 

Menu.menu "Menu"

/* CREATE DIALOG */
CreateDialog ( _Rollout.RolloutCreator.getDefinition() ) menu:(Menu.create "MainMenu")