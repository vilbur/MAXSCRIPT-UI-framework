
global CLONED_NODES_TIMER
global CLONED_NODES_BUFFER	-- 2d Matrix of nodes E.G.: #( #(source objects) #(copies 1) #(copies 2) #(copies 3) )
global CLONED_TYPE


/*  */ 
		
	--CLONED_NODES_BUFFER = undefined
	
	--CLONED_NODES_TIMER = undefined

/** Execute post nodes cloned end callbacks
 */
function executePostNodesClonedEndCallbacks =
(
	--format "\n"; print ".executePostNodesClonedEndCallbacks()"
	
	CLONED_NODES_TIMER.stop()
	
	CALLBACKMANAGER.exe #postNodesClonedEnd
		
	CLONED_NODES_BUFFER = undefined
	
	CLONED_NODES_TIMER = undefined
	
	CLONED_TYPE = undefined
)

/** Create timeout with .dotNet timer
  *
  * Default callback #postNodesCloned is fired every time each copy is created ( when multiple copies are created at once )
  * 
  * #waitForNodesCloned store source obejct and copies in CLONED_NODES_BUFFER matrix
  * 
  * When last copy is created, then ##waitForNodesCloned callback is fired
  * 
  * 
 */
function waitForNodesCloned =
(
	--format "\n\n";	print "waitForNodesCloned()"
	--format "params: %\n" (callbacks.notificationParam())
	
	params = callbacks.notificationParam()
	--format "params[3]: %\n" params[3]
	
	
	CLONED_TYPE = #( #COPY, #INSTANCE, #REFERENCE )[params[3] +1]
	
	if params != undefined then
	(
		old_nodes = params[1]
		new_nodes = params[2]
	
		--format "old_nodes: %\n" old_nodes
		--format "new_nodes: %\n" new_nodes
		--format "CLONED_NODES_BUFFER: %\n" CLONED_NODES_BUFFER
		
		if CLONED_NODES_TIMER == undefined then
		(
			CLONED_NODES_TIMER	= dotNetObject "System.Windows.Forms.Timer"
			
			dotNet.addEventHandler CLONED_NODES_TIMER "tick" executePostNodesClonedEndCallbacks
			
			--CLONED_NODES_TIMER.interval = 500
			CLONED_NODES_TIMER.interval = 1000
		)
		else
			CLONED_NODES_TIMER.stop()
		
		if CLONED_NODES_BUFFER == undefined then
			CLONED_NODES_BUFFER = #( old_nodes ) -- append source nodes as first array
		--format "CLONED_NODES_BUFFER: %\n" CLONED_NODES_BUFFER
		
		
		append CLONED_NODES_BUFFER new_nodes
		----append CLONED_NODES_BUFFER (callbacks.notificationParam())[2]	
		--
		CLONED_NODES_TIMER.start()
		
	)
	
)