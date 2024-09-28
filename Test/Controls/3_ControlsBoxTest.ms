clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	--"./../../Lib/Dialog/Dialog.ms"

/* DIALOG */
Dialog 	    = Dialog_v title:"Test"

/* ROLLOUT  */
_Rollout    = Dialog.Roll "Main Rollout" --height:256



/* CONTROLS WITHOUT GROUP */
_Controls = _Rollout.Controls()
_Button_2 = _Controls.control #button "Main Ui Top"


/* CONTROLS IN GROUP */
_Controls = _Rollout.Controls group:"Controls A" offset:[16,0]
_Button_1 = _Controls.control #button "Button A"

_Controls = _Rollout.Controls group:"Controls B"
_Button_1 = _Controls.control #button "Button B"


/* CONTROLS WITHOUT GROUP */
_Controls = _Rollout.Controls()
_Button_2 = _Controls.control #button "Main Ui Bottom"



Subrollouts
/** CREATE UI
 *
 */
Dialog.create width:256
