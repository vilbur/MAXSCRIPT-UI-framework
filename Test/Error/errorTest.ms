/*------------------------------------------------------------------------------
	TEMP FILE FOR TESTING
--------------------------------------------------------------------------------*/

clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"


/** Prepare scene
  *
  */
function prepareScene =
(
	--format "\n"; print "errorTest.ms.prepareScene()"
	delete objects

	_box = box()

	addModifier _box  (FFDBox ())

	select _box

)


prepareScene()

max modify mode