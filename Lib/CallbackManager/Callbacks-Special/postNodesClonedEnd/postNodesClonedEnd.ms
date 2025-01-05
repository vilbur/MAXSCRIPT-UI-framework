
global CLONED_NODES_TIMER
global CLONED_NODES	-- 2d Matrix of nodes E.G.: #( #(source objects) #(copies 1) #(copies 2) #(copies 3) )

/*  */ 
		
	CLONED_NODES = undefined
	
	CLONED_NODES_TIMER = undefined

/** Execute post nodes cloned end callbacks
 */
function executePostNodesClonedEndCallbacks =
(
	format "\n"; print ".executePostNodesClonedEndCallbacks()"
	
	CALLBACKMANAGER.exe #postNodesClonedEnd
	
	CLONED_NODES_TIMER.stop()
		
	CLONED_NODES = undefined
	
	CLONED_NODES_TIMER = undefined
)

/** Create timeout with .dotNet timer
  *
  * Default callback #postNodesCloned is fired every time each copy is created ( when multiple copies are created at once )
  * 
  * #postNodesClonedEnd store source obejct and copies in CLONED_NODES matrix
  * 
  * When last copy is created, then ##postNodesClonedEnd callback is fired
  * 
  * 
 */
function postNodesClonedEnd =
(
	format "\n\n";	print "postNodesClonedEnd()"
	
	if CLONED_NODES_TIMER == undefined then
	(
		CLONED_NODES_TIMER	= dotNetObject "System.Windows.Forms.Timer"
		
		dotNet.addEventHandler CLONED_NODES_TIMER "tick" executePostNodesClonedEndCallbacks
		
		CLONED_NODES_TIMER.interval = 500
	)
	else
		CLONED_NODES_TIMER.stop()
	
	if CLONED_NODES == undefined then
		CLONED_NODES = #( (callbacks.notificationParam())[1] ) -- append source nodes as first array
	--format "CLONED_NODES: %\n" CLONED_NODES
	
	append CLONED_NODES (callbacks.notificationParam())[2]	
	
	CLONED_NODES_TIMER.start()
)