clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Dialog.ms" )

try( destroyDialog ROLLOUT_test )catch()


Dialog 	= Dialog_v title:"Test"

_Controls_1 = Dialog.Controls()

_Button_1 = _Controls_1.control #button "Button 1" id:#button_1



_Rollouts_1    = Dialog.Rollouts()
_Rollout_1     = _Rollouts_1.Roll "Subrollout A"
_Controls_Roll = _Rollout_1.Controls()

_Button_2 = _Controls_Roll.control #button "Button 2" id:#button_2


_Controls_2 = Dialog.Controls()
_Button_3   = _Controls_2.control #button "Button 3" id:#button_3


Dialog.create()