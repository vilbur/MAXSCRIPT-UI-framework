clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )


/** Test callback
 */
function hotkeyCallback val =
(
	format "\n"; print ("hotkeyCallback() " + val as string )
)

Dialog 	= Dialog_v "Test Dialog"



-- Dialog.HotKey #(#Control)	"hotkeyCallback()"
-- Dialog.HotKey #(#Control)	"hotkeyCallback  'Ctrl'"
Dialog.HotKey #(#Control)	"hotkeyCallback  \"Ctrl\""
Dialog.HotKey #(#Esc)	"hotkeyCallback  \"Esc\""

--Dialog.HotKey #(#Space, #Control)	"hotkeyCallback 'Ctrl + Space'"
-- Dialog.HotKey #(#Control, #Space)	"hotkeyCallback 'Ctrl + Space'"


Dialog.create()