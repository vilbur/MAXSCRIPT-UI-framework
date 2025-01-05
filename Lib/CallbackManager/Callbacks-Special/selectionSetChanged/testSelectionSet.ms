--/*------------------------------------------------------------------------------
--	WAIT ON SELECTION CHANGED
----------------------------------------------------------------------------------*/
--
--/** Wait for selection change callback
-- */
--function waitOnSelectionChanged =
--(
--	--print "Start: waitOnSelectionChanged()"
--	callbacks.addScript #selectionSetChanged "isNewSelectionCreated()" id:#isNewSelectionCreated
--)
--
--/** Kill callback
-- */
--function waitOnSelectionChangedKill =
--(
--	--print "Kill: waitOnSelectionChangedKill()"
--	try(callbacks.removeScripts #selectionSetChanged   id:#isNewSelectionCreated)catch()
--)



/*--------------------------------------------------------------------------------
	TEST SELECTION
--------------------------------------------------------------------------------*/

/** addScript #modPanelObjPostChange callback when selection is really changed
  *
  * This method avoid re selection of same object
  *
  *
 */
function testSelectionSet =
(
	format "\n"; print "Callback: testSelectionSet()"

	if( selection.count > 0 ) then
	(
		format "GLOBAL_SELECTION_LAST	= % \n" GLOBAL_SELECTION_LAST
		if( GLOBAL_SELECTION_LAST != selection ) then -- if new selection has been created
		(
			print "Selection changed"
	
			CALLBACKMANAGER.start "onModifyStackReady" --"./../../../../../CallBacks/modPanelObjPostChange/onModifyStackReady.ms"
	
		) else
		(
			print "Reselected"
		)
	)
	else -- if( selection.count == 0 ) then
	(
		print "DESELECTED ALL"
	
		CALLBACKMANAGER.kill "onModifyStackReady" 
	)
)
