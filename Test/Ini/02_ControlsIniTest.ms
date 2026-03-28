clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"

Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) width:512 ini:( getSourceFileName())
--Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) width:512 -- WITHOUT INI

--Dialog.ini.delete()

/*------------------------------------------------------------------------------
	CONFIG TEST
--------------------------------------------------------------------------------*/

USE_INI_ON_CONTROL = true -- default
--USE_INI_ON_CONTROL = false

/*------------------------------------------------------------------------------
	CONTROLS
--------------------------------------------------------------------------------*/

_Controls = Dialog.Controls group:"Test"

_Controls.control #checkbutton "Button 1" params:#( #across, 1) ini:USE_INI_ON_CONTROL

_Controls.control #checkbox "Checkbox 1" ini:USE_INI_ON_CONTROL

_Controls.control #EditText "EditText" value:"Default text" ini:USE_INI_ON_CONTROL

_Controls.control #EditText "EditText no ini" value:"Default text" ini:USE_INI_ON_CONTROL

_Controls.control #BrowsePath "" params:#( #mode, #getOpenFileName ) ini:USE_INI_ON_CONTROL

_Controls.control #radioButtons "RadioButtons"	items:#("Item 1","Item 2") ini:USE_INI_ON_CONTROL


/*------------------------------------------------------------------------------
	CREATE DIALOG
--------------------------------------------------------------------------------*/
Dialog.create()
--Dialog.create cache:true


/*------------------------------------------------------------------------------
	OPEN INI FILE
--------------------------------------------------------------------------------*/
--Dialog.ini.open()