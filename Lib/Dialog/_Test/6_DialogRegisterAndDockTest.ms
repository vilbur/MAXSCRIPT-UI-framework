clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Dialog.ms" )


Dialog 	= Dialog_v title:"Test"


/** Dock dialog
 */
function dockDialog state =
(
	Dialog.dock state
	
	messageBox ( state as string ) title:"Dialog dock test"  beep:false
)

Dialog.create pos:[300, 256]

dockDialog #left
dockDialog #right
dockDialog #float

Dialog.destroy()