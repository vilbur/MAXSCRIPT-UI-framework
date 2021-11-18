clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Dialog/Rollout/Rollout.ms" )

 /**  macro which is executed on UI start
 *	
 */
macroscript	startup_callback_test
category:	"_Development"
(
	if( EventFired.value ) then
		print ( "Control " + EventFired.control + " startup CALLBACK")
)


/** CREATE ROLLOUTS 
 *	
 */
_Rollout     = Rollout_v title:(getFilenameFile(getSourceFileName())) id:"rollout_main"
_Rollout.ini (getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini")

SubRollouts = _Rollout.subrollouts()

_Rollout   = SubRollouts.new "Subrollout A"

_Controls   = _Rollout.Controls.new groupbox:"test"




/* CALLBACk CONTROLS  */
_Checkbox = _Controls.checkbox "Checkbox"
_Checkbox.Events.setEvent #changed "macros.run \"_Development\" \"startup_callback_test\"" "tooltip"

_Checkbutton = _Controls.checkbutton "Checkbutton"
_Checkbutton.Events.setEvent #changed "macros.run \"_Development\" \"startup_callback_test\"" "tooltip"



/* CREATE ROLLOUT */
_Rollout.createRollout()

/* CREATE DIALOG */
CreateDialog ( _Rollout.RolloutCreator.getDefinition() ) width:640 height:512

_Rollout.addSubRollouts() -- dialog must exist for adding subrollouts


/** SIMULATE method of Dialog_v._runCallbacksOnStart() 
 *	
 */
for callback in STARTUP_EVENTS do 
	execute (callback)