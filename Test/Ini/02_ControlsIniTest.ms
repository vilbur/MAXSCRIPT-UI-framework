clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"

Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))  ini:( getSourceFileName())
--Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) -- WITHOUT INI

--Dialog.ini.delete()

/* CONTROLS */

_Controls = Dialog.Controls group:"Test"

_Controls.control #checkbutton "Button 1" params:#( #across, 1) ini:false

_Controls.control #checkbox "Checkbox 1"

_Controls.control #EditText "EditText" value:"Default text"

_Controls.control #EditText "EditText no ini" value:"Default text" ini:false

_Controls.control #BrowsePath ""

_Controls.control #radioButtons "RadioButtons"	items:#("Item 1","Item 2")


/* CREATE DIALOG */
Dialog.create()