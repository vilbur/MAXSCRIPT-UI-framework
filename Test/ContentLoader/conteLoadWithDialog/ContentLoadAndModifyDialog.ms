clearListener(); print("Cleared in:\n"+getSourceFileName())

/* UI FRAMEWORK */
filein( getFilenamePath(getSourceFileName()) + "/../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms" )	--"./../MAXSCRIPT-UI-framework/Lib/Dialog/Dialog.ms"

/** Createcontent load and modify dialog
 */
function createContentLoadAndModifyDialog Dialog: =
(
	--format "\n"; print ".createContentLoadAndModifyDialog()"
	
	/* SETUP */
	main_buttons = 2
	
	/* DIALOG */
	if Dialog == undefined then 
		Dialog 	    = Dialog_v ("ContentLoadAndModify") ini:(getSourceFileName())
	
	/* DIALOG CONTROLS */ 
	_Controls   = Dialog.Controls group:("Main Controls " + x as string )
	
	for x = 1 to 2 do
	(
	
		for i = 1 to main_buttons do
			_Button = _Controls.control #button ("Main " + x as string + " " + i as string ) across:main_buttons
	)
	
	
	/* ROLLOUTS */
	_Rollouts	 = Dialog.Rollouts()
	
	/* ROLLOUT */
	_Rollout    = _Rollouts.Roll "Subrollout"
	
	_Controls   = _Rollout.Controls group:"Rollout Controls"
	_Button     = _Controls.control #button "Rollout" id:#button_2
	
	
	
	/* SUBROLLOUTS */
	Subrollouts = _Rollout.Rollouts()
	
	/* SUBROLLOUT */
	_Subrollout = Subrollouts.Roll "Nested"
	_Controls    = _Subrollout.Controls group:"Subrollout Controls"
	_Button      = _Controls.control #button "Subrollout" id:#button_3
	
	
	/* DIALOG CREATE */
	Dialog.create()
	
)