clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../Rollout.ms" )

try( destroyDialog ROLLOUT_test )catch()

Rollout 	= Rollout_v title:"Test"


_Controls = Rollout.Controls

--_Button = _Controls.button "Button Test" id:#button_1

--format "_Button	= % \n" _Button

--_Button.Events.add #pressed "print @Pressed Event@"

--CreateDialog (Rollout.getDefinition())

Rollout.createRolloout()