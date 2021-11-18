clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../Rolloutor.ms" )

try( destroyDialog ROLLOUT_test )catch()



/** Create controls
 */
function createControls groups_count:1 controls_count:4 =
(
	for g = 1 to groups_count do
	(
		
		_Controls = Rolloutor.Controls.new ("Group "+g as string )
	
	
		for c = 1 to 2 do
		(
			_Button = _Controls.button ("Button "+c as string ) id:("button_"+ g as string +"_"+ c as string )
			--params:"across:2"
			format "_Button	= % \n" _Button
			--_Button.Events.add #pressed "print @Pressed Event@"
		)
		
	)
)



Rolloutor 	= Rolloutor_v title:"Test"


_Subrolllouts = Rolloutor.Controls.subrollouts()



--createControls()


Rolloutor.createRollout()