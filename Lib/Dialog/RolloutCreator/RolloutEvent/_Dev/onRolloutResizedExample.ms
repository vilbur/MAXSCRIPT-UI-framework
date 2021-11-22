clearListener()


try(cui.UnRegisterDialogBar MainRollout)catch() --try to unregister if already registered
try(DestroyDialog  MainRollout)catch() --try to unregister if already registered

rollout MainRollout "Main Rollout" width:325 height:200
(	
	on MainRollout resized new_size do
	(
		
		if( GLOBAL_DIALOG_RESIZED == undefined ) then
			GLOBAL_DIALOG_RESIZED = new_size
			
		else
		(
			GLOBAL_DIALOG_RESIZED = undefined
			
			format "Dialog has been resized = % \n" new_size
		)
		
		
	)
)


global GLOBAL_DIALOG_RESIZED

Dialog = createDialog MainRollout 


cui.RegisterDialogBar	MainRollout style:#(#cui_dock_left,#cui_dock_right,#cui_floatable,#cui_handles)
cui.DockDialogBar     MainRollout #cui_dock_right