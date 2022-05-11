clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../Lib/RolloutCreator/RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */
_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.new "Test"

_Controls = _Rollout.Controls group:"Test"

_Button_1 = _Controls.control #button "Button 1" id:#button_1 params:#( #tooltip, "Test Tooltip", #across, 1)

_EditText = _Controls.control #EditText "EditText 1"

_BrowsePath = _Controls.control #BrowsePath "BrowsePath 1"

/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout)