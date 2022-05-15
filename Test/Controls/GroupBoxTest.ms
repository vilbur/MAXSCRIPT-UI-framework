clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/RolloutCreator/RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */
_RolloutCreator = RolloutCreator_v()
_Rollout        = _RolloutCreator.new "Test"


/* CONTROLS IN GROUP */ 
_Controls = _Rollout.Controls group:"Controls A"
_Button_1 = _Controls.control #button "Button A1"
_Button_1 = _Controls.control #button "Button A2"

_Controls = _Rollout.Controls group:"Controls B"
_Button_1 = _Controls.control #button "Button B1"
--_Button_1 = _Controls.control #button "Button B2"

/* CONTROLS WITHOUT GROUP */ 
_Controls = _Rollout.Controls()
_Button_2 = _Controls.control #button "Button c1"

/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout) width:420