clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" )


/* DIALOG */
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))


/* CONTROLS */
_Controls = Dialog.Controls group:"Controls Group"


/* GROUPBOX */
_GroupBox = _Controls.control #GroupBox "Test groupbox" params:#( #height, 128 ) --id:#GB_test_groupbox



/* ADD CONTROL BY ID of groupbox */
--_Controls.control #button ("Button 1") groupbox:_GroupBox.id across:1 
 

/* ADD CONTROL BY TITLE of groupbox */
_Controls.control #button ("Button 2") groupbox:_GroupBox.caption across:1

/* TEST SPINNER -  */ 
_Controls.control #SPINNER "Spinner" params:#(#groupbox, _GroupBox.caption ) across:1 width:64 align:#LEFT

/* CREATE DIALOG */
Dialog.create height:256