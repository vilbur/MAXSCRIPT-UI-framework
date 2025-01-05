clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../CallbackManager.ms" ) -- "./../CallbackManager.ms"




/*------------------------------------------------------------------------------
	CREATE TEST OBJECTS
--------------------------------------------------------------------------------*/
delete objects

_box = box()

/*----------------------------------------------------------------------------------------------------------------------------------------
  
	MASS FILEIN CALLBACK FILES
	
	• Import all files in subdirs of given name
	• callback function and type are get from "DIR_NAME/FILENAME.ms" >>> callback:FILENAME  type:DIR_NAME
	
------------------------------------------------------------------------------------------------------------------------------------------*/

CALLBACKMANAGER.import( getFilenamePath(getSourceFileName()) + "/Callbacks" )	



/*------------------------------------------------------------------------------

	ADD CALLBACK

--------------------------------------------------------------------------------*/

--CALLBACKMANAGER.add "postNodesClonedEndCallback" #postNodesClonedEnd

/* START CALLBACK */
CALLBACKMANAGER.start "postNodesClonedEndCallback" --"./Callbacks/postNodesClonedEnd/postNodesClonedEndCallback.ms"

/* TEST CALLLBACK */ 
copy _box