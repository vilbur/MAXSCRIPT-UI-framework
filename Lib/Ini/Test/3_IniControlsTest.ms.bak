clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Dialog/Rollout/Rollout.ms" )


/** CREATE ROLLOUTS 
 *	
 */
_Rollout     = Rollout_v title:(getFilenameFile(getSourceFileName())) id:"rollout_main"
_Rollout.ini (getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini")

SubRollouts = _Rollout.subrollouts()

Rollout_A    = SubRollouts.new "Subrollout A"

_Controls = Rollout_A.Controls.new()


/* BUTTON  */
--Button_A1 = _Controls.button "Test 1" 


/* CHECKBOX  */
--_Checkbox = _Controls.checkbox	"Checkbox" checked:true


/* SPINNER  */
--_Controls.spinner	"Spinner int"   range:[0,9,99]
--_Controls.spinner	"Spinner float" range:[0,999,999.0] type:#float
--_Controls.spinner	"Test Spinner" 


/* CHECKBUTTON  */
--_Controls.checkbutton	"Checkbutton"


/* EDITTEXT  */
--_EditText = _Controls.edittext	"Edit Text" 


/* PATH  */
--BrowsePath = _Controls.BrowsePath	"Browse test" columns:14

--format "_Controls.Controls.count	= % \n" _Controls.Controls.count

/**  Set ini path 
 *	
 */
--Rollout_A.ini	= (getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini")
--Rollout_A.setDefaultEvents()


/* CREATE ROLLOUT */
_Rollout.createRollout()

/* CREATE DIALOG */
CreateDialog ( _Rollout.RolloutCreator.getDefinition() ) width:640 height:512

_Rollout.addSubRollouts() -- dialog must exist for adding subrollouts

--SubRollouts.property height:256
  