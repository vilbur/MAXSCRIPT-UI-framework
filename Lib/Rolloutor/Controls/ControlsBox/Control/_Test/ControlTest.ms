clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../Rolloutor.ms" )

try( destroyDialog ROLLOUT_test )catch()

Rolloutor 	= Rolloutor_v title:"Test"




groups_count   = 2
controls_count = 2

for g = 1 to groups_count do
(
	
	_Controls = Rolloutor.Controls.new ("Group "+g as string )


	for c = 1 to 2 do
	(
		_Button = _Controls.button ("Button "+c as string ) id:("button_"+ g as string +"_"+ c as string ) params:"across:3"
		format "_Button	= % \n" _Button
		--_Button.Events.add #pressed "print @Pressed Event@"
	)
	
)
--format "_Button	= % \n" _Button

format "_Controls.ControlsBox.Controls	= % \n" _Controls.ControlsBox.Controls
format "_Controls._Controls	= % \n" _Controls._Controls




--CreateDialog (Rolloutor.getDefinition())

Rolloutor.createRollout()