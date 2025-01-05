clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../CallbackManager.ms" ) -- "./../CallbackManager.ms"




/*------------------------------------------------------------------------------
	CREATE TEST OBJECTS
--------------------------------------------------------------------------------*/
delete objects

_box = box()

/*----------------------------------------------------------------------------------------------------------------------------------------
  
	MASS FILEIN CALLBACK FILES

------------------------------------------------------------------------------------------------------------------------------------------*/

CALLBACKMANAGER.import( getFilenamePath(getSourceFileName()) + "/Callbacks" )	



/*------------------------------------------------------------------------------

	ADD CALLBACK

--------------------------------------------------------------------------------*/

/* START CALLBACK */ 
CALLBACKMANAGER.start "onSelectionChangedModPanelReadyCalllback" --"./Callbacks/onSelectionChangedModPanelReady/onSelectionChangedModPanelReadyCalllback.ms"

/* TEST CALLLBACK */

max modify mode

select _box