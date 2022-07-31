clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )


/*------------------------------------------------------------------------------
	SETUP
--------------------------------------------------------------------------------*/

/* DIALOG */ 
-- Dialog 	    = Dialog_v title:"Test"  ini:(getSourceFileName())
Dialog 	    = Dialog_v title:"Test" 

_Controls   = Dialog.Controls group:"Main Controls"

/* CALLBACK FUNCTION */ 
fn testCallback val = print val


/*------------------------------------------------------------------------------
	TEST
--------------------------------------------------------------------------------*/

/* FOLDER PATH */ 
_Controls.control #browsePath "_SavePath" -- #Mode:#getSavePath is default

/* SAVE FILE PATH */ 
_Controls.control #browsePath "_SaveFileName" params:#( #mode,#getSaveFileName )
 
--/* OPEN FILE PATH */ 
_OpenFileName = _Controls.control #browsePath "_OpenFileName" params:#( #mode,#getOpenFileName, #tooltip, "Test Tooltip" )
_OpenFileName.Events.add #changed ("testCallback")


/* DIALOG CREATE */ 
Dialog.create()