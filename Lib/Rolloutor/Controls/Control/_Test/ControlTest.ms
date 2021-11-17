clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Rolloutor.ms" )

try( destroyDialog ROLLOUT_test )catch()

Rolloutor 	= Rolloutor_v title:"Test"


_Controls = Rolloutor.Controls


for i = 1 to 12 do
(
	_Button = _Controls.button ("Button "+i as string ) id:("button_"+i as string ) params:"across:3"
	
	_Button.Events.add #pressed "print @Pressed Event@"
)

--format "_Button	= % \n" _Button


--CreateDialog (Rolloutor.getDefinition())

Rolloutor.createRolloout()