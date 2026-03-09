clearListener(); print("Cleared in:"+getSourceFileName())

format "DOCK_STATE: %\n" (execute ("try(cui.getDockState DIALOG_dock_test )catch( #WTF )"))

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

/* DEFINE INI FILE */ 
ini = undefined
ini = (getSourceFileName())


/* IMPORTANT:

	param #width WORKS AS WIDTH OF DOCKED DIALOG
*/
Dialog 	    = Dialog_v title:"Test" ini:ini  min_size:[128, 128] max_size:[256, 128]


format "DOCK_STATE: %\n" (execute ("try(cui.getDockState DIALOG_dock_test )catch( #WTF )"))

/*------------------------------------------------------------------------------
	DEFAULT DOCK SATES
--------------------------------------------------------------------------------*/
--Dialog.create()



/*------------------------------------------------------------------------------
	SET ALLOWED DOCK STATES
--------------------------------------------------------------------------------*/
--Dialog.create dock:#ALL
--Dialog.create dock:#TOP

--Dialog.create dock:#( #LEFT, #RIGHT )


--Dialog.create dock:#HORZ	--  #BOTTOM	| #TOP
Dialog.create dock:#VERT	--  #LEFT	| #RIGHT



/*------------------------------------------------------------------------------
	REGISTER AFTER CREATE
--------------------------------------------------------------------------------*/
Dialog.register()



/* DOCK DIALOG */ 
--Dialog.dock #LEFT


/*------------------------------------------------------------------------------
	OPEN INI FILE
--------------------------------------------------------------------------------*/

--Dialog.Ini.open()