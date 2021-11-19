clearListener()


try(cui.UnRegisterDialogBar MainRollout)catch() --try to unregister if already registered
try(DestroyDialog           MainRollout)catch() --try to unregister if already registered

rollout MainRollout "Main Rollout" width:325 height:200
(	
	on MainRollout resized new_size do
	(
		format "\nResized = % \n" new_size
		dialog_current_state = try(cui.getDockState MainRollout)catch(false)
		format "dialog_current_state = % \n" dialog_current_state
		
		
		
		if( GLOBAL_DIALOG_RESIZED == undefined ) then
			GLOBAL_DIALOG_RESIZED = new_size
			
		else
		(
			GLOBAL_DIALOG_RESIZED = undefined
		)

	)
	on MainRollout moved new_pos do
	(
		format "\nMoved = % \n" new_pos
		dialog_current_state = try(cui.getDockState MainRollout)catch(false)
		format "dialog_current_state = % \n" dialog_current_state

	)
	
)



global GLOBAL_DIALOG_RESIZED

Dialog = createDialog MainRollout 


print "-------- REGISTER -------"
cui.RegisterDialogBar	MainRollout style:#(#cui_dock_left,#cui_dock_right,#cui_floatable,#cui_handles) minSize:[320,1024]


print "-------- DOCKING -------"

cui.DockDialogBar     MainRollout #cui_dock_right
print "-------- DOCKED -------"