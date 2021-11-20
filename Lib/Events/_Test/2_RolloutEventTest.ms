clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Dialog/RolloutCreator/RolloutCreator.ms" )

try(cui.UnRegisterDialogBar ROLLOUT_test)catch() 
try( destroyDialog          ROLLOUT_test )catch()


/** DEFINE UI 
 *	
 */
_RolloutCreator 	= RolloutCreator_v()

_Rollout = _RolloutCreator.new "Test"


Subrollouts_1 = _Rollout.Subrollouts()
--Subrollouts_2 = _Rollout.Subrollouts()

Subrollout_1 = Subrollouts_1.new "Subrollout1"

/* DIALOG EVENTS */ 
_Rollout.Events.add #open   "print \"Open\""
_Rollout.Events.add #close  "print \"Close\""
_Rollout.Events.add #moved  "print \"Moved\""
_Rollout.Events.add #docked "print \"Docked\""


/* ROLlOUT EVENTS */ 
Subrollout_1.Events.add #rolledUp   "print \"RolledUp\""
Subrollout_1.Events.add #rolledDown "print \"RolledDown\""


--/** Create controls
-- */
--function createControls groups_count:1 controls_count:4 =
--(
--	for g = 1 to groups_count do
--	(
--		_Controls = _Rollout.Controls()
--
--		for c = 1 to controls_count do
--		(
--			_Button = _Controls.control #button ("Button "+c as string ) id:("button_"+ g as string +"_"+ c as string )
--			_Button.Events.add #pressed "print @Pressed Event@"
--			
--		)
--	)
--)


--createControls()


/** CREATE UI 
 *	
 */
_RolloutCreator.createRollout _Rollout

CreateDialog (_RolloutCreator.getDefinition _Rollout)

_RolloutCreator.addSubRollouts _Rollout


cui.RegisterDialogBar ROLLOUT_test style:#( #cui_dock_all, #cui_floatable )
