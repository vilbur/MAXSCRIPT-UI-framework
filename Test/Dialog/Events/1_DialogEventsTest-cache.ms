rollout DIALOG_test "Test"
(
	local ROLLEDUP_INITILAZIED = false
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
	(IniSaver_v ini_file:"C:/Users/vilbur/AppData/Local/Autodesk/3dsMax/2023 - 64bit/ENU/scripts/MAXSCRIPT-UI-framework/Test/Dialog/Events/1_DialogEventsTest.ini").saveRollout("DIALOG_test")
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

CreateDialog DIALOG_test width: 256 height: 256

