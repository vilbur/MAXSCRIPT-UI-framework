clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" )

/* DIALOG */ 
Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName()))

/* CONTROLS */ 
_Controls = Dialog.Controls group:"Test Dialog"
 
/* GROUPBOX */ 
_GroupBox = _Controls.control #GroupBox (groupbox_name = "Test groupbox") params:#( #height, 128 )

/* BUTTON */ 
_Controls.control #button ("Button 1") across:1 params:#(#groupbox, groupbox_name)

/* CREATE DIALOG */ 
Dialog.create()