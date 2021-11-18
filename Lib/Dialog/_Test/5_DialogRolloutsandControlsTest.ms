clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Dialog.ms" )

try( destroyDialog ROLLOUT_test )catch()


/* DIALOG */ 
Dialog 	    = Dialog_v title:"Test"
_Controls   = Dialog.Controls.new "Main Controls"
_Button     = _Controls.button "Main" id:#button_1


/* ROLLOUT */ 
_Rollouts	 = Dialog.Rollouts()
_Rollout    = _Rollouts.new "Subrollout"
_Controls   = _Rollout.Controls.new "Rollout Controls"
_Button     = _Controls.button "Rollout" id:#button_2



/* SUBROLLOUTS */ 
Subrolllouts = _Rollout.Rollouts()
_Subrolllout = Subrolllouts.new "Nested"
_Controls    = _Subrolllout.Controls.new "Subrollout Controls"
_Button      = _Controls.button "Subrollout" id:#button_3


/* DIALOG BOTTOM */ 
_Controls   = Dialog.Controls.new "Main Controls Bottom"
_Button     = _Controls.button "Bottom" id:#button_4


/* DIALOG CREATE */ 
Dialog.create()