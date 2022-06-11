clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Dialog.ms" )

try( destroyDialog ROLLOUT_test )catch()


/* DIALOG */ 
Dialog 	    = Dialog_v title:"Test"
_Controls   = Dialog.Controls group:"Main Controls"
_Button     = _Controls.control #button "Main" id:#button_1


/* ROLLOUT */ 
_Rollouts	 = Dialog.Rollouts()
_Rollout    = _Rollouts.Roll "Subrollout"
_Controls   = _Rollout.Controls group:"Rollout Controls"
_Button     = _Controls.control #button "Rollout" id:#button_2



/* SUBROLLOUTS */ 
Subrolllouts = _Rollout.Rollouts()
_Subrolllout = Subrolllouts.Roll "Nested"
_Controls    = _Subrolllout.Controls group:"Subrollout Controls"
_Button      = _Controls.control #button "Subrollout" id:#button_3


/* DIALOG BOTTOM */ 
_Controls   = Dialog.Controls group:"Main Controls Bottom"
_Button     = _Controls.control #button "Bottom" id:#button_4


/* DIALOG CREATE */ 
Dialog.create()