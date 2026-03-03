function createDialogFromCacheFile width height pos bgcolor fgcolor bitmap bmpstyle style modal autoLayoutOnResize escapeEnable lockHeight lockWidth parent =
(

try( destroyDialog DIALOG_test )catch()


rollout Rollout_B1 "R O L L O U T   B 1 "
(
	on Rollout_B1 rolledUp val do
(
	if val then
	(
		if keyboard.controlPressed then
		rollUpOtherRolloutsCallback ( #DIALOG_test) ( #Rollouts_B) ( #Rollout_B1)
else
		autoRollUpRolloutCallback ( #DIALOG_test) ( #Rollouts_B) ( #Rollout_B1)
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
		rollUpOtherRolloutsCallback ( #DIALOG_test) ( #Subrollouts_1) ( #ROLLOUT_main_rollout)
else
		autoRollUpRolloutCallback ( #DIALOG_test) ( #Subrollouts_1) ( #ROLLOUT_main_rollout)
)
)
)
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
rollout DIALOG_test "Test"
(
	subRollout Subrollouts_1 "Subrollouts_1" height:121 offset:[-12,0] width:254
	subRollout Rollouts_B "Rollouts_B" height:288 offset:[-12,0] width:254
	on DIALOG_test open do
(
	GROUPBOXCREATOR.sortControlsToGroupBoxes( DIALOG_test )
)
	on DIALOG_test resized val do
(
	waitForResizingEndsTimer(#DIALOG_test)
)
	on DIALOG_test okToClose do
(
	(IniSaver_v ini_file:"C:/Users/vilbur/AppData/Local/Autodesk/3dsMax/2023 - 64bit/ENU/scripts/MAXSCRIPT-UI-framework/Test/Cache/01_DialogCacheTest.ini").saveRollout("DIALOG_test")

	true -- IMPORTANT - #oktoclose MUST RETURN BOOLEAN
)
)

CreateDialog DIALOG_test width:width height:height pos:pos bgcolor:bgcolor fgcolor:fgcolor bitmap:bitmap bmpstyle:bmpstyle style:style modal:modal autoLayoutOnResize:autoLayoutOnResize escapeEnable:escapeEnable lockHeight:lockHeight lockWidth:lockWidth parent:parent 

try(

	AddSubRollout DIALOG_test.Subrollouts_1 ROLLOUT_main_rollout rolledUp:false --1

	AddSubRollout DIALOG_test.Rollouts_B Rollout_B1 rolledUp:false --1

		AddSubRollout ROLLOUT_main_rollout.Subrollouts ROLLOUT_sub_rollout rolledUp:false --2

			AddSubRollout ROLLOUT_sub_rollout.Subrollouts ROLLOUT_nested_sub_rollout rolledUp:false --3
)catch()


DIALOG_test-- return
)