
--/** Wait when modifier stack will be ready
-- */
--function waitOnModifiyStackIsReady =
--(
--	--print "Start: waitOnModifiyStackIsReady()"
--	callbacks.addScript #modPanelObjPostChange "onModifyStackReady()" id:#onModifyStackReady
--)
--
--/**
-- */
--function waitOnModifiyStackIsReadyKill =
--(
--	--print "Kill: waitOnModifiyStackIsReadyKill()"
--	try(callbacks.removeScripts #modPanelObjPostChange id:#onModifyStackReady)catch()
--)

/*------------------------------------------------------------------------------
		EXECUTE CALLBACKS
--------------------------------------------------------------------------------*/

/** Call callback when mod panel is fully loaded
 */
function onModifyStackReady =
(
	--format "\n"; print "Callback: onModifyStackReady WAIT"

	max modify mode
	
	if (_modifier = modPanel.getCurrentObject()) != undefined then -- current object is undefined than Modify panel is fully loaded
	(
		--format "\n"; print "Callback: onModifyStackReady READY"
	
		CALLBACKMANAGER.kill("onModifyStackReady")
	
		--for callback in ON_MOD_PANEL_CHANGED_CALLBACKS do
		--(
			--format "execute callback: %\n" callback
			
		CALLBACKMANAGER.exe #onSelectionChangedModPanelReady

			--execute(callback+"()")
		--)
	
	)
)

