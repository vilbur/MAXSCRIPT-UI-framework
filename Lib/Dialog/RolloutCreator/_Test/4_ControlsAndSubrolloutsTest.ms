clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()



/* ROLLOUT */ 
_RolloutCreator = RolloutCreator_v()
_Rollout        = _RolloutCreator.new "Test"

_Controls = _Rollout.Controls()
_Button_1 = _Controls.control #button "Button 1" id:#button_1



/* SUBROLLOUT */ 
Subrollouts = _Rollout.Subrollouts()

Subrollout_1 = Subrollouts.new "Subrollout1" id:#subrollout_1
Subrollout_2 = Subrollouts.new "Subrollout2" id:#subrollout_2

_Controls_Subrollout = Subrollout_1.Controls()

_ButtonSub_1 = _Controls_Subrollout.control #button "Button Sub 1" id:#button_sub_1

format "_Controls_Subrollout	= % \n" _Controls_Subrollout

/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout)

_RolloutCreator.addSubRollouts _Rollout