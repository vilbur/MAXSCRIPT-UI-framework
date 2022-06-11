clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../../Rollout.ms" )

/** CREATE ROLLOUTS 
 *	
 */
_Rollout     = Rollout_v title:(getFilenameFile(getSourceFileName())) id:"rollout_main"
_Rollout.ini	= (getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini")

SubRollouts = _Rollout.subrollouts()

Rollout_A    = SubRollouts.Roll "Subrollout A"

_Controls = Rollout_A.Controls.Roll groupbox:"test"


/* NO VALUE CONTROLS  */
--Button_A1 = _Controls.button "Test 1" 

/* VALUE CONTROLS  */
_Checkbox = _Controls.checkbox "Checkbox" checked:true


--BrowsePath = _Controls.BrowsePath	"Browse"
--
--_Controls.spinner	"Spinner with long label" columns:12
_Controls.spinner    "Spinner"     range:[-33,99,7] 
--
_Controls.checkbutton "Checkbutton" checked:true

_Controls.edittext    "Edit Text"   text:"test value"

/**  Set ini path 
 *	
 */
--Rollout_A.ini	= (getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini")
Rollout_A.setDefaultEvents()


/* CREATE ROLLOUT */
_Rollout.createRollout()

/* CREATE DIALOG */
CreateDialog ( _Rollout.RolloutCreator.getDefinition() ) width:640 height:512

_Rollout.addSubRollouts() -- dialog must exist for adding subrollouts

SubRollouts.property height:256