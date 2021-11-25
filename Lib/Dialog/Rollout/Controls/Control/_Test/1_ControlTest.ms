clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../Rollout.ms" )

try( destroyDialog ROLLOUT_test )catch()

_Rollout 	= Rollout_v title:"Test"





/** Create controls
 */
function createControls groups_count:1 controls_count:4 =
(
	for g = 1 to groups_count do
	(
		_Controls = _Rollout.Controls.new ("Group "+g as string )
	
		for c = 1 to 2 do
			_Button = _Controls.button ("Button "+c as string ) id:("button_"+ g as string +"_"+ c as string )
	)
)

createControls()


_Rollout.createRollout()