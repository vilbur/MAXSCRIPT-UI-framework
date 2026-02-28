try( destroyDialog DIALOG_test )catch()


rollout ROLLOUT_nested_sub_rollout "NESTED SUB ROLLOUT"
(
	on ROLLOUT_nested_sub_rollout rolledUp val do
(
	if val then
	(
		if keyboard.controlPressed then
		rollUpOtherRolloutsCallback ( #ROLLOUT_sub_rollout) ( #Subrollouts) ( #ROLLOUT_nested_sub_rollout)
else
		autoRollUpRolloutCallback ( #ROLLOUT_sub_rollout) ( #Subrollouts) ( #ROLLOUT_nested_sub_rollout)
)
)
)

rollout ROLLOUT_sub_rollout "SUB ROLLOUT"
(
	subRollout Subrollouts "Dictionary #name AUTOROLLUP:1 " height:37 offset:[-12,0] width:226
	on ROLLOUT_sub_rollout rolledUp val do
(
	if val then
	(
		if keyboard.controlPressed then
		rollUpOtherRolloutsCallback ( #ROLLOUT_main_rollout) ( #Subrollouts) ( #ROLLOUT_sub_rollout)
else
		autoRollUpRolloutCallback ( #ROLLOUT_main_rollout) ( #Subrollouts) ( #ROLLOUT_sub_rollout)
)
)
)

rollout ROLLOUT_main_rollout "M A I N   R O L L O U T "
(
	subRollout Subrollouts "Dictionary #name AUTOROLLUP:1 " height:79 offset:[-12,0] width:240
	on ROLLOUT_main_rollout rolledUp val do
(
	if val then
	(
		if keyboard.controlPressed then
		rollUpOtherRolloutsCallback ( #DIALOG_test) ( #Subrollouts) ( #ROLLOUT_main_rollout)
else
		autoRollUpRolloutCallback ( #DIALOG_test) ( #Subrollouts) ( #ROLLOUT_main_rollout)
)
)
)

rollout DIALOG_test "Test"
(
	local ROLLEDUP_INITILAZIED = false
	subRollout Subrollouts "Subrollouts" height:168 offset:[-12,0] width:254
	on DIALOG_test open do
(
	GROUPBOXCREATOR.sortControlsToGroupBoxes( DIALOG_test )
	dialogRolloutCallbackParam("#OPEN")
)
	on DIALOG_test close do
(
	dialogRolloutCallbackParam("#CLOSE")
)
	on DIALOG_test moved val do
(
	dialogRolloutCallbackParam("#MOVED")
)
	on DIALOG_test resized val do
(
	waitForResizingEndsTimer(#DIALOG_test)( #resized )
)
	on DIALOG_test okToClose do
(
	(IniSaver_v ini_file:"C:/Users/vilbur/AppData/Local/Autodesk/3dsMax/2023 - 64bit/ENU/scripts/MAXSCRIPT-UI-framework/Test/Cache/01_DialogCacheTest.ini").saveRollout("DIALOG_test")
	dialogRolloutCallbackParam("#okToClose")

	true -- IMPORTANT - #oktoclose MUST RETURN BOOLEAN
)
	on DIALOG_test rbuttondown val do
(
	dialogRolloutCallbackParam("#RBUTTONDOWN")
)
	on DIALOG_test DOCKED val do
(
	dialogRolloutCallbackParam("#DOCKED")
)
	on DIALOG_test UNDOCKED val do
(
	dialogRolloutCallbackParam("#UNDOCKED")
)
)


CreateDialog DIALOG_test width: 256.0 height: 387.0

try(

	AddSubRollout DIALOG_test.Subrollouts ROLLOUT_main_rollout rolledUp:false
		AddSubRollout ROLLOUT_main_rollout.Subrollouts ROLLOUT_sub_rollout rolledUp:false
			AddSubRollout ROLLOUT_sub_rollout.Subrollouts ROLLOUT_nested_sub_rollout rolledUp:false
)catch()


