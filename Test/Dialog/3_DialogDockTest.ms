clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"


	ini = (getSourceFileName())


	/* IMPORTANT:

		param #width WORKS AS WIDTH OF DOCKED DIALOG
	*/
	Dialog 	    = Dialog_v title:"Dock Test" ini:ini  min_size:[128, 128] max_size:[256, 128]

	--Dialog.create()
	Dialog.create lockWidth:false


	--Dialog.create width:128

	Dialog.register()



	--Dialog.dock #LEFT






