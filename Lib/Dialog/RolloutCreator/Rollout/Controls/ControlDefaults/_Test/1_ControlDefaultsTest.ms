clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()



/** DEFINE UI 
 *	
 */
_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.new "Test"

_Controls = _Rollout.Controls()


/** TEST PARAMS 
 *	
 */
_Controls.Default width:320 height:32

Button_1 = _Controls.control #Button "Default width"
Button_2 = _Controls.control #Button "Params string"	params:"width:256"
Button_3 = _Controls.control #Button "Params array"	params:#(#width, 128 )
Button_4 = _Controls.control #Button "Params multiple"	params:#(#width, 96, #height, 64, #border, false )
Button_5 = _Controls.control #Button "Invalid param" 	params:"foobar:256"



/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout) width:512