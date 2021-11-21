clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Dialog/RolloutCreator/RolloutCreator.ms" )

try( destroyDialog ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */
_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.new "Test"



/** Create controls
 */
function createControls groups_count:1 controls_count:4 =
(
	for g = 1 to groups_count do
	(
		_Controls = _Rollout.Controls()

		for c = 1 to controls_count do
		(
			_Button = _Controls.control #button ("Button "+c as string ) id:("button_"+ g as string +"_"+ c as string )
			_Button.Events.add #pressed "print @Pressed Event@"
			
		)
	)
)


createControls()


/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout)