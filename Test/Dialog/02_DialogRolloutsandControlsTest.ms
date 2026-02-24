clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"


/* SETUP */
main_buttons = 2

/* DIALOG */
--Dialog 	    = Dialog_v ("Test") height:1024
Dialog 	    = Dialog_v ("Test") ini:(getSourceFileName())


for x = 1 to 2 do
(
	_Controls   = Dialog.Controls group:("Main Controls " + x as string )

	for i = 1 to main_buttons do
		_Button = _Controls.control #button ("Main " + x as string + " " + i as string ) across:main_buttons
)


/* ROLLOUTS */
_Rollouts	 = Dialog.Rollouts()

/* ROLLOUT */
_Rollout    = _Rollouts.Roll "Subrollout"

--_Controls   = _Rollout.Controls group:"Rollout Controls"
--_Button     = _Controls.control #button "Rollout" id:#button_2


--
--/* SUBROLLOUTS */
--Subrollouts = _Rollout.Rollouts()
--
--/* SUBROLLOUT */
--_Subrollout = Subrollouts.Roll "Nested"
--_Controls    = _Subrollout.Controls group:"Subrollout Controls"
--_Button      = _Controls.control #button "Subrollout" id:#button_3
--
--
--/* DIALOG BOTTOM */
--_Controls   = Dialog.Controls group:"Main Controls Bottom"
--_Button     = _Controls.control #button "Bottom" id:#button_4


/* DIALOG CREATE */
Dialog.create()
