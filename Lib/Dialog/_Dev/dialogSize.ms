clearListener()


try(cui.UnRegisterDialogBar	MainRollout)catch()
try(DestroyDialog 		MainRollout)catch()

try(cui.UnRegisterDialogBar	MainRollout_2)catch()
try(DestroyDialog 		MainRollout_2)catch()

rollout MainRollout "Main Rollout"
(
	label label1 "minimal size is 256"
)

rollout MainRollout_2 "Main Rollout 2"
(	
	label label1 "minimal size is 256"
)


style = #( #style_titlebar, #style_sysmenu, #style_resizing )

CreateDialog MainRollout	style:style width:256 height:256	-- width, height is MINIMAL SIZE OF RESIZABLE DIALOG
CreateDialog MainRollout_2	style:style lockWidth:true lockHeight:true	-- lockWidth & lockHeight HAS NO EFFECT ON REGISTERED DIALOG



cui.RegisterDialogBar	MainRollout style:#(  #cui_dock_all )	minSize:[256,256] -- minSize & maxSize works the same way if they only one of them is presented, maxSize is deprecated

cui.RegisterDialogBar	MainRollout_2 style:#(  #cui_dock_all )	minSize:[256,256] maxSize:[512,512] -- maxSize doesn't work

--cui.DockDialogBar     MainRollout_2 #cui_dock_right