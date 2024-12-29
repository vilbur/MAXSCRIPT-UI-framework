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
  
	FILEIN CALLBACK FILES
	
	• Import all files in subdirs of given name
	• callback function and type are get from "DIR_NAME/FILENAME.ms" >>> callback:FILENAME  type:DIR_NAME
	
------------------------------------------------------------------------------------------------------------------------------------------*/

CALLBACKMANAGER.import( getFilenamePath(getSourceFileName()) + "/Callbacks" )	


/*------------------------------------------------------------------------------

	ADD CALLBACKS

--------------------------------------------------------------------------------*/

--CALLBACKMANAGER.add #nodeCreatedCallback	#nodeCreated
--CALLBACKMANAGER.add "nodeCreatedCallback"	#nodeCreated	id:#nodeCreated_2nd
--CALLBACKMANAGER.add #nodeDeletedCallback	#nodePreDelete	id:#nodeDeletedCallback_id



/*------------------------------------------------------------------------------
  
	GET CALLBACKS
	
--------------------------------------------------------------------------------*/
--
--/* ALL CALLBACKS */ 
--all_callbacks = CALLBACKMANAGER.getCallbacks()
--format "all_callbacks: %\n" all_callbacks
--
--
--/* GET ALL BY CALLBACK FN */ 
--all_callBackFn = CALLBACKMANAGER.getCallbacks callback:#nodeCreatedCallback
--format "all_callBackFn: %\n" all_callBackFn
--
--/* GET ALL BY TYPE */ 
--all_nodeCreated = CALLBACKMANAGER.getCallbacks type:#nodeCreated
--format "all_nodeCreated: %\n" all_nodeCreated
--
--/* GET CALLBACK BY ID */ 
--callback_by_id = CALLBACKMANAGER.getCallbacks id:#id_first
--format "callback_by_id: %\n" callback_by_id




/*------------------------------------------------------------------------------

	START CALLBACKS

--------------------------------------------------------------------------------*/

/* START CALLBACKS */ 
--CALLBACKMANAGER.start()

/* START CALLBACKS BY TYPE */ 
--CALLBACKMANAGER.start type:#nodeCreated

/* START BY ID */ 
--CALLBACKMANAGER.start id:#nodeCreated_2nd



/*------------------------------------------------------------------------------

	KILL CALLBACKS

--------------------------------------------------------------------------------*/

--CALLBACKMANAGER.kill id:#nodeCreated_2nd

/* KILL ALL CALLBACKS */ 
--CALLBACKMANAGER.kill()

/* KILL CALLBACKS BY TYPE */ 
--CALLBACKMANAGER.kill type:#nodeCreated

/* KILL BY ID */ 
--CALLBACKMANAGER.kill id:#nodeCreated_2nd




/*------------------------------------------------------------------------------
	
	DELETE CALLBACKS
	
--------------------------------------------------------------------------------*/

/*------ GET BY ALL PARAMS ------*/
--format "TEST ALL PARAMS: % \n"	(( CALLBACKMANAGER.remove  callback:#nodeCreatedCallback type:#nodeCreated id:#id_first).count	== 1)


/*------ GET BY MULTIPLE PARAMS ------*/
--format "TEST CALLBACK AND ID PARAMS: % \n"	((CALLBACKMANAGER.remove callback:#nodeCreatedCallback	id:#id_first).count	== 1)
--format "TEST CALLBACK AND TYPE PARAMS: % \n"	((CALLBACKMANAGER.remove callback:#nodeCreatedCallback	type:#nodeCreated).count	== 2)
--format "TEST TYPE AND ID PARAMS: % \n"	((CALLBACKMANAGER.remove type:#nodeCreated	id:#id_first).count	== 1)


/*------ GET BY SINGLE PARAM ------*/
--format "TEST CALLBACK PARAM: % \n"	((CALLBACKMANAGER.remove callback:#nodeCreatedCallback).count	== 3)
--format "TEST TYPE PARAM: % \n"	((CALLBACKMANAGER.remove type:#nodeCreated).count	== 2)
--format "TEST ID PARAM: % \n"	((CALLBACKMANAGER.remove id:#id_first).count	== 1)









