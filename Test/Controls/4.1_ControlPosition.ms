clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"

/**  CONTROL TYPES: https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_E421933F_958E_42FD_80A1_D66F2A2C0A06_htm
  *
  */

/* DIALOG */
--Dialog 	    = Dialog_v title:"Test" ini:(getSourceFileName())
Dialog 	    = Dialog_v title:"Test"	--WITHOUT INI FILE


/* CONTROLS */
--Controls   = Dialog.Controls group:"Main Controls"
Controls   = Dialog.Controls()


/*------ BUTTONS ------*/
for i = 1 to 5 do
	Controls.control #BUTTON ("Button"+ i as string ) across:1

/*------ SLIDER ------*/
_Slider = Controls.control #slider "Slider" orient:#vertical width:32 height:128 across:1 pos:[ 4, 4 ]




/* DIALOG CREATE */
--Dialog.create()
Dialog.create   width:320 height:256
--Dialog.create   width:1024
