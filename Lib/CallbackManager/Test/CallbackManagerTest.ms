clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../CALLBACKMANAGER.ms" ) -- "./../CALLBACKMANAGER.ms"\

/** Callback test
 */
function nodeDeletedCallback =
(
	--format "\n"; print "CallbackManagerTest.ms.nodeDeletedCallback()"

	obj	= (callbacks.notificationParam())

	format "NODE PRE DELETE	= % \n" obj.name
)

/*------------------------------------------------------------------------------
	CREATE TEST OBJECTS
--------------------------------------------------------------------------------*/
delete objects

b = box()



/*----------------------------------------------------------------------------------------------------------------------------------------
  
	MASS FILEIN CALLBACK FILES
	
	• Import all files in subdirs of given name
	• callback function and type are get from "DIR_NAME/FILENAME.ms" >>> callback:FILENAME  type:DIR_NAME
	
------------------------------------------------------------------------------------------------------------------------------------------*/

CALLBACKMANAGER.import( getFilenamePath(getSourceFileName()) + "/Callbacks" )	


/*------------------------------------------------------------------------------

	ADD CALLBACKS MANNUALY

--------------------------------------------------------------------------------*/

CALLBACKMANAGER.add #nodeCreatedCallback	#nodeCreated
CALLBACKMANAGER.add "nodeCreatedCallback"	#nodeCreated   id:#nodeCreated_2nd
CALLBACKMANAGER.add #nodeDeletedCallback	#nodePreDelete id:#nodeDeletedCallback_id



/*------------------------------------------------------------------------------
  
	GET CALLBACKS
	
------------------------------------------------------------------------*/

/* ALL CALLBACKS */ 
all_callbacks = CALLBACKMANAGER.getCallbacks(undefined)
format "all_callbacks: %\n" all_callbacks

/* GET ALL BY CALLBACK FN */ 
all_callBackFn = CALLBACKMANAGER.getCallbacks "nodeCreatedCallback"
format "all_callBackFn: %\n" all_callBackFn

/* GET ALL BY TYPE */ 
all_nodeCreated = CALLBACKMANAGER.getCallbacks #nodeCreated
format "all_nodeCreated: %\n" all_nodeCreated

/* GET CALLBACK BY ID */ 
callback_by_id = CALLBACKMANAGER.getCallbacks #id_first
format "callback_by_id: %\n" callback_by_id




/*------------------------------------------------------------------------------

	START CALLBACKS

--------------------------------------------------------------------------------*/

/* START ALL CALLBACKS */ 
CALLBACKMANAGER.start(undefined)


/* START BY CALLBACK FN */ 
CALLBACKMANAGER.start "nodeCreatedCallback"

/* START CALLBACKS BY TYPE */ 
CALLBACKMANAGER.start #nodeCreated

/* START BY ID */ 
CALLBACKMANAGER.start #nodeCreated_2nd



/*------------------------------------------------------------------------------

	KILL CALLBACKS

--------------------------------------------------------------------------------*/

/* KILL ALL CALLBACKS */ 
CALLBACKMANAGER.kill(undefined)


/* KILL BY CALLBACK FN */ 
CALLBACKMANAGER.kill "nodeCreatedCallback"


/* KILL CALLBACKS BY TYPE */ 
CALLBACKMANAGER.kill #nodeCreated

/* KILL BY ID */ 
CALLBACKMANAGER.kill #nodeCreated_2nd




/*------------------------------------------------------------------------------

	DELETE CALLBACKS

--------------------------------------------------------------------------------*/

/* REMOVE ALL CALLBACKS */ 
CALLBACKMANAGER.remove(undefined)


/* REMOVE BY CALLBACK FN */ 
CALLBACKMANAGER.remove "nodeCreatedCallback"


/* REMOVE CALLBACKS BY TYPE */ 
CALLBACKMANAGER.remove #nodeCreated

/* REMOVE BY ID */ 
CALLBACKMANAGER.remove #nodeCreated_2nd







