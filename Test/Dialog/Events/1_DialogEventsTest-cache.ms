function createDialogFromCacheFile width height =
(

try( destroyDialog DIALOG_test )catch()


rollout DIALOG_test "Test"
(
	local ROLLEDUP_INITILAZIED = false
	on DIALOG_test open do
(
	GROUPBOXCREATOR.sortControlsToGroupBoxes( DIALOG_test )
	print("Custom dialog event #open")
)
	on DIALOG_test close do
(
	print("Custom dialog event #close")
)
	on DIALOG_test moved val do
(
	print("Custom dialog event #moved")
)
	on DIALOG_test resized val do
(
	waitForResizingEndsTimer(#DIALOG_test)( #resized )
)
	on DIALOG_test okToClose do
(
	(IniSaver_v ini_file:"C:/Users/vilbur/AppData/Local/Autodesk/3dsMax/2023 - 64bit/ENU/scripts/MAXSCRIPT-UI-framework/Test/Dialog/Events/1_DialogEventsTest.ini").saveRollout("DIALOG_test")

	true -- IMPORTANT - #oktoclose MUST RETURN BOOLEAN
)
	on DIALOG_test help do
(
	print("Custom dialog event #help")
)
	on DIALOG_test lbuttondown val do
(
	print("Custom dialog event #lbuttondown")
)
	on DIALOG_test lbuttonup val do
(
	print("Custom dialog event #lbuttonup")
)
	on DIALOG_test lbuttondblclk val do
(
	print("Custom dialog event #lbuttondblclk")
)
	on DIALOG_test mbuttondown val do
(
	print("Custom dialog event #mbuttondown")
)
	on DIALOG_test mbuttonup val do
(
	print("Custom dialog event #mbuttonup")
)
	on DIALOG_test mbuttondblclk val do
(
	print("Custom dialog event #mbuttondblclk")
)
	on DIALOG_test rbuttondown val do
(
	print("Custom dialog event #rbuttondown")
)
	on DIALOG_test rbuttonup val do
(
	print("Custom dialog event #rbuttonup")
)
	on DIALOG_test rbuttondblclk val do
(
	print("Custom dialog event #rbuttondblclk")
)
	on DIALOG_test DOCKED val do
(
	print("Custom dialog event #DOCKED")
)
	on DIALOG_test UNDOCKED val do
(
	print("Custom dialog event #UNDOCKED")
)
)

CreateDialog DIALOG_test width:width height:height 

try(
)catch()


DIALOG_test-- return
)