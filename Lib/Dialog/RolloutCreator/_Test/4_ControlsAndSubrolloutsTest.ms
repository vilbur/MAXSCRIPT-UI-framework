clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */

_RolloutCreator = RolloutCreator_v()
_Rollout        = _RolloutCreator.new "Test" id:#ROLLOUT_test

_Controls = _Rollout.Controls()
_Button_1 = _Controls.control #button "Button 1" id:#button_1


Subrollouts = _Rollout.Subrollouts()

Subrollout_1 = Subrollouts.new "Subrollout1" id:#subrollout_1
--Subrollout_2 = Subrollouts.new "Subrollout2" id:#subrollout_2

/** CREATE UI 
 *	
 */
_RolloutCreator.createRollouts()

CreateDialog (_RolloutCreator.getDefinition _Rollout)

_RolloutCreator.addSubRollouts()