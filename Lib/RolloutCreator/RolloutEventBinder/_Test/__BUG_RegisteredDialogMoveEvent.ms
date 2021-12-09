clearListener()


/*------------------------------------------------------------------------------
	
	PROBLEM:
		#moved event is not fired on registered Dialog
	
	
	
	
--------------------------------------------------------------------------------*/

/** UNREGISTERD 
  *	
  */
try(DestroyDialog           rollout_unregistred)catch() --try to unregister if already registered

rollout rollout_unregistred "Un Registred" width:325 height:200
(	
	on rollout_unregistred moved new_pos do
	(
		format "\n Unregistered #moved = % \n" new_pos
	)
)

CreateDialog rollout_unregistred style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing) 



/** REGISTERD 
  *	
  */
try(cui.UnRegisterDialogBar rollout_registred)catch() --try to unregister if already registered
try(DestroyDialog           rollout_registred)catch() --try to unregister if already registered

rollout rollout_registred "Registred" width:325 height:200
(	
	on rollout_registred resized new_size do
	(
		format "\n Registered #resized = % \n" new_size
	)
	on rollout_registred moved new_pos do
	(
		format "\n MOVED EVENT is NOT FIRED REGISTERED ROLLOUT"
	)
)

CreateDialog rollout_registred style:#(#style_titlebar, #style_border, #style_sysmenu, #style_resizing) 

cui.RegisterDialogBar	rollout_registred  style:#(#cui_dock_left,#cui_dock_right,#cui_floatable,#cui_handles)