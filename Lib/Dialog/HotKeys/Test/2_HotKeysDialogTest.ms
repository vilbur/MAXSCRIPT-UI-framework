clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Dialog.ms" )

/** Test callback
 */
function testCallback  =
(
	format "\n"; print ".testCallback()"
	--format "val	= % \n" val
	--format "classOf val	= % \n" (classOf val)
)

Dialog 	= Dialog_v "Test Dialog"

Dialog.create()