clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Rolloutor.ms" )

try( destroyDialog ROLLOUT_test )catch()

Rolloutor 	= Rolloutor_v title:"Test"


_Controls = Rolloutor.Controls

_Button = _Controls.button "Button Test" id:#button_1

format "_Button	= % \n" _Button

_Button.Events.add #pressed "print @Pressed Event@"

--CreateDialog (Rolloutor.getDefinition())

Rolloutor.createRolloout()