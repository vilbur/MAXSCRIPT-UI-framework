clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"

--Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))  ini:( getSourceFileName())
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))

--Dialog.ini.delete()

/* CONTROLS */

_Controls = Dialog.Controls group:"Test"

_Controls.control #button "Button 1" id:#button_1 params:#( #tooltip, "Test Tooltip", #across, 1)

_Controls.control #checkbox "Checkbox 1"

_Controls.control #EditText "EditText" value:"Default text"

_Controls.control #EditText "EditText no ini" value:"Default text" ini:false

--_Controls.control #BrowsePath "BrowsePath 1"
_Controls.control #BrowsePath ""

_Controls.control #radioButtons "RadioButtons"	items:#("Item 1","Item 2")


/* CREATE DIALOG */
Dialog.create()