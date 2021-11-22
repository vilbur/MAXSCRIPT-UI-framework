clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Dialog/Dialog.ms" )

try( destroyDialog          ROLLOUT_test )catch()

--ini_path_to_file = (getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini")
--ini_path_to_dir  = (getSourceFileName())

format "ini_path	= % \n" ini_path

Dialog 	    = Dialog_v title:"Test" ini:(getSourceFileName())

_Rollouts	  = Dialog.Rollouts()


/* DIALOG EVENTS */ 
Dialog.Events.add #open   "print \"Open\""
Dialog.Events.add #close  "print \"Close\""

_Subrolllout = _Rollouts.new "Subrollout A"


/* ROLlOUT EVENTS */ 
_Subrolllout.Events.add #rolledUp   "print \"RolledUp\""
_Subrolllout.Events.add #rolledDown "print \"RolledDown\""


Dialog.create()


--/** CREATE ROLLOUTS 
-- *	
-- */
--_Rollout = Rollout_v title:(getFilenameFile(getSourceFileName())) id:"rollout_main"
--
--SubRollouts = _Rollout.subrollouts()
--
--Rollout_A   = SubRollouts.new "Subrollout A"
--
--/**  Set ini path 
-- *	
-- */
--Rollout_A.ini	(getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini")
--Rollout_A.setDefaultEvents()
--
--
--/* CREATE ROLLOUT */
--_Rollout.createRollout()
--
--/* CREATE DIALOG */
--CreateDialog ( _Rollout.RolloutCreator.getDefinition() ) width:640 height:512
--
--_Rollout.addSubRollouts() -- dialog must exist for adding subrollouts