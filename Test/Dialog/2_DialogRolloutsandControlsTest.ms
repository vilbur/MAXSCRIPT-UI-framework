clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"



/* DIALOG */
--Dialog 	    = Dialog_v ("Test") height:1024
Dialog 	    = Dialog_v ("Test") ini:(getSourceFileName())


--_Controls   = Dialog.Controls group:"Main Controls"
--_Button     = _Controls.control #button "Main" id:#button_1


/* ROLLOUT */
--_Rollouts	 = Dialog.Rollouts()
_Rollouts	 = Dialog.Rollouts height:512
--_Rollout    = _Rollouts.Roll "Subrollout"
_Rollout    = _Rollouts.Roll "Subrollout" height:256
_Controls   = _Rollout.Controls group:"Rollout Controls"
_Button     = _Controls.control #button "Rollout" id:#button_2



/* SUBROLLOUTS */
Subrollouts = _Rollout.Rollouts()
_Subrollout = Subrollouts.Roll "Nested"
_Controls    = _Subrollout.Controls group:"Subrollout Controls"
_Button      = _Controls.control #button "Subrollout" id:#button_3


/* DIALOG BOTTOM */
_Controls   = Dialog.Controls group:"Main Controls Bottom"
_Button     = _Controls.control #button "Bottom" id:#button_4


/* DIALOG CREATE */
Dialog.create()
