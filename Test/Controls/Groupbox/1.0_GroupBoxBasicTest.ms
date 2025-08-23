clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" )


/* DIALOG */
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))


/* CONTROLS */
_Controls = Dialog.Controls group:"Controls Group"


/* GROUPBOX */
_GroupBox = _Controls.control #GroupBox "Test groupbox" params:#( #height, 256 ) --id:#GB_test_groupbox



/* ADD CONTROL BY ID of groupbox */
_Controls.control #button ("Button 1") across:1 params:#(#groupbox, _GroupBox.id )
 

/* ADD CONTROL BY TITLE of groupbox */
_Controls.control #button ("Button 2") across:1 params:#(#groupbox, _GroupBox.caption )
 

/* CREATE DIALOG */
Dialog.create height:256