clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	--"./../../Lib/Dialog/Dialog.ms"




Dialog_A = Dialog_v("ALIGN TO")

Dialog_A.create height:256

Dialog_A.register()




Dialog_B = Dialog_v("ALIGNED")

Dialog_B.create height:128

Dialog_B.register()


/*------------------------------------------------------------------------------
	TRY ALIGN TO EACH CORNER
--------------------------------------------------------------------------------*/

Dialog_B.alignToDialog( DIALOG_align_to )
Dialog_B.alignToDialog( DIALOG_align_to ) side:#RIGHT
Dialog_B.alignToDialog( DIALOG_align_to ) height:#BOTTOM
Dialog_B.alignToDialog( DIALOG_align_to ) height:#BOTTOM side:#RIGHT 

