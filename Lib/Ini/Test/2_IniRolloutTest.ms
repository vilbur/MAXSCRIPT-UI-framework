clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Dialog/Dialog.ms" )

--try( destroyDialog          ROLLOUT_test )catch()

--ini_path_to_file = (getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini")
--ini_path_to_dir  = (getSourceFileName())

--format "ini_path	= % \n" ini_path

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