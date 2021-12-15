clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Dialog/Dialog.ms" )


Dialog 	    = Dialog_v title:"Test" ini:(getSourceFileName())

_Rollouts	  = Dialog.Rollouts()


/* DIALOG EVENTS */ 
Dialog.Events.add #open   "print \"Open\""
Dialog.Events.add #close  "print \"Close\""
Dialog.Events.add #resized  "print \"resized\""
Dialog.Events.add #moved  "print \"moved\""

_Subrolllout = _Rollouts.new "Subrollout A"


/* ROLlOUT EVENTS */ 
_Subrolllout.Events.add #rolledUp   "print \"RolledUp\""
_Subrolllout.Events.add #rolledDown "print \"RolledDown\""


Dialog.create()

--Dialog.register()
Dialog.dock #left