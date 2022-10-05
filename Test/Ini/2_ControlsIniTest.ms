clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))  ini:( getSourceFileName())

--Dialog.ini.delete()

/* ROLLOUTS */ 
_Rollouts  = Dialog.Rollouts()

_Rollout_1 = _Rollouts.roll "Rollout 1"

_Controls = _Rollout_1.Controls group:"Test"

_Controls.control #button "Button 1" id:#button_1 params:#( #tooltip, "Test Tooltip", #across, 1)

_Controls.control #checkbox "Checkbox 1"

_Controls.control #EditText "EditText" value:"Default text"

_Controls.control #EditText "EditText no ini" value:"Default text" ini:false

_Controls.control #BrowsePath "BrowsePath 1"

_Controls.control #radioButtons "RadioButtons"	items:#("Item 1","Item 2")


/* CREATE DIALOG */ 
Dialog.create()