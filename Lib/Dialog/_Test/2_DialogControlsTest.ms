clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Dialog.ms" )

try( destroyDialog ROLLOUT_test )catch()


Dialog 	= Dialog_v title:"Test"

_Controls = Dialog.Controls.new "Controls"

_Button = _Controls.button "Button Test" id:#button_1


Dialog.create()