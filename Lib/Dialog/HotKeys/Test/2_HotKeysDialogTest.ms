clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Dialog.ms" )

--global TEST_VAR = "VALUE-X"

/** Test callback
 */
function hotkeyCallback val =
(
	format "\n"; print ("Hotkey " + val)
)

Dialog 	= Dialog_v "Test Dialog"



Dialog.HotKey #(#ctrl)	"hotkeyCallback 'Ctrl'"
Dialog.HotKey #(#ctrl, #space)	"hotkeyCallback 'Ctrl + Space'"


Dialog.create()