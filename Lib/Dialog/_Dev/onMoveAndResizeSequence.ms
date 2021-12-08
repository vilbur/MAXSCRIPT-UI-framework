clearListener()

/**  
		PROBLEM:	There is on dialog #dock event
		
		SOLUTION:	save state on every move and then on resize compare state, if changed, then resized


  */	

try(cui.UnRegisterDialogBar MainRollout_test)catch() --try to unregister if already registered
try(DestroyDialog           MainRollout_test)catch() --try to unregister if already registered

rollout MainRollout_test "Main Rollout" width:325 height:200
(
 
	on MainRollout_test resized new_size do
	(
		format "\n"
		print "MainRollout_test.onResized()" 
		dialog_current_state = try(cui.getDockState MainRollout_test)catch(false)
		format "% \n" dialog_current_state
		
		
		
		if( GLOBAL_DIALOG_RESIZED == undefined ) then
			GLOBAL_DIALOG_RESIZED = new_size
			
		else
		(
			GLOBAL_DIALOG_RESIZED = undefined
		)

	)
	on MainRollout_test moved new_pos do
	(
		format "\n"
		print "MainRollout_test.onMoved()" 
		dialog_current_state = try(cui.getDockState MainRollout_test)catch(false)
		format "% \n" dialog_current_state

	)
	
	on MainRollout_test open do
	(
		format "\n"
		print "MainRollout_test.onOpen()" 

	)
	
)



global GLOBAL_DIALOG_RESIZED

Dialog = CreateDialog MainRollout_test 


print "-------- REGISTER -------"
--cui.RegisterDialogBar	MainRollout_test style:#(#cui_dock_left,#cui_dock_right,#cui_floatable,#cui_handles,#style_resizing) minSize:[320,1024]
cui.RegisterDialogBar	MainRollout_test style:#(#cui_dock_left,#cui_dock_right,#cui_floatable,#cui_handles,#style_resizing)
--cui.RegisterDialogBar	MainRollout_test style:#(#cui_floatable,#cui_handles) 


print "-------- DOCKING -------"

cui.DockDialogBar     MainRollout_test #cui_dock_right

print "-------- DOCKED -------"