clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))  ini:( getSourceFileName())

/* ROLLOUTS */ 
_Rollouts  = Dialog.Rollouts()

_Rollout_1 = _Rollouts.roll "Rollout 1"

_Controls = _Rollout_1.Controls group:"Test"

--_Button_1 = _Controls.control #button "Button 1" id:#button_1 params:#( #tooltip, "Test Tooltip", #across, 1)
--
--_Checkbox = _Controls.control #checkbox "Checkbox 1"
--
--_EditText = _Controls.control #EditText "EditText 1"
--
--_BrowsePath = _Controls.control #BrowsePath "BrowsePath 1"

_RadioButtons =  _Controls.control #radioButtons "RadioButtons"	items:#("Item 1","Item 2")


/* CREATE DIALOG */ 
Dialog.create()