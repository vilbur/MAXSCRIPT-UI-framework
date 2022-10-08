clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )

--global TEST_VAR = "VALUE-X"

/** Test callback
 */
function hotkeyCallback val =
(
	format "\n"; print ("Hotkey " + val)
)

Dialog 	= Dialog_v "Test Dialog"



Dialog.HotKey #(#Control)	"hotkeyCallback 'Ctrl'"
--Dialog.HotKey #(#Space, #Control)	"hotkeyCallback 'Ctrl + Space'"
--Dialog.HotKey #(#Control, #Space)	"hotkeyCallback 'Ctrl + Space'"


Dialog.create()


/*------------------------------------------------------------------------------
	DEVELOPENT
--------------------------------------------------------------------------------*/
HOTKEYS_GLOBAL.stopTimer()
--HOTKEYS_GLOBAL = undefined

-- Dialog._HotKeys.startTimer(()