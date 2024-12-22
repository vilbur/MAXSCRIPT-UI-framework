clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"

global DIALOG_POS = [0,0]

/** Get dialog pos
 */
function getDialogPosTest =
(
	--format "\n"; print ".getDialogPosTest()"
	DIALOG_POS.x += 256
	
	DIALOG_POS --return
)

/** Add item controls
 */
function addControls _Rollout count:10 =
(
	Controls = _Rollout.Controls()
	
	for i = 1 to count do 
		Controls.control #BUTTON ( "BUTTON" + i as string ) across:1
)


/*------------------------------------------------------------------------------
	
	TEST METHODS
	
--------------------------------------------------------------------------------*/

/** Height Is Defined
  *	
  */
function heightIsDefined title rollout_height: slot_height: =
(
	--format "\n"; print ".heightIsDefined()"

	/* INIT DIALOG */
	Dialog 	= Dialog_v title:title --width:320
	
	/* ROLLOUTS A */
	_Rollouts_A = Dialog.Rollouts slot:#Rollouts_A height:slot_height
	_Rollout_A1 = _Rollouts_A.Roll ("Rollout A1") 

	addControls(_Rollout_A1) --count:5
	
	/* CREATE DIALOG */
	Dialog.create pos:(getDialogPosTest()) height:rollout_height
	--Dialog.create height:256 
)

/** Subollout slot height
 */
function subolloutSlotHeight =
(
	--format "\n"; print ".subolloutSlotHeight()"
	
	/* INIT DIALOG */
	Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) --width:320
	
	
	/* ROLLOUTS A */
	_Rollouts_A = Dialog.Rollouts slot:#Rollouts_A
	_Rollout_A1 = _Rollouts_A.Roll ("Rollout A1") --height:512
	_Rollout_A2 = _Rollouts_A.Roll ("Rollout A2") --height:256
	
	/* ROLLOUTS B */
	_Rollouts_B = Dialog.Rollouts slot:#Rollouts_B
	_Rollout_B1 = _Rollouts_B.Roll ("SECOND SLOT") --height:512
	
	/* Set properties of subrollouts */
	--_Rollouts_A_set_props	= Dialog.get (#rollouts_A)
	
	
	/* ROLLOUTS A NESTED */
	_Rollouts_A1_nested = _Rollout_A1.Rollouts slot:#Rollouts_A1_nested
	
	_Rollouts_A1_nested_1 = _Rollouts_A1_nested.Roll ("Rollout A1 nested 1") --height:128
	_Rollouts_A1_nested_2 = _Rollouts_A1_nested.Roll ("Rollout A1 nested 2") --height:128
	--_Rollouts_A1_nested_3 = _Rollouts_A1_nested.Roll ("Rollout A1 nested 3") --height:128
	
	--_Rollouts_A2_nested = _Rollout_A2.Rollouts slot:#Rollouts_A2_nested
	--_Rollouts_A2_nested_1 = _Rollouts_A2_nested.Roll ("Rollout A2 nested 1") --height:128
	--_Rollouts_A2_nested_2 = _Rollouts_A2_nested.Roll ("Rollout A2 nested 2") --height:128
	--_Rollouts_A2_nested_3 = _Rollouts_A2_nested.Roll ("Rollout A2 nested 3") --height:128
	
	addControls(Dialog) count:1
	
	addControls(_Rollouts_A1_nested_1) count:15
	addControls(_Rollouts_A1_nested_2) count:5
	--addControls(_Rollout_A2) count:5
	
	
	--/* ROLLOUTS A SUB NESTED */
	--_Rollouts_A_subnested = _Rollout_A1_nested.Rollouts slot:#Rollouts_A_subnested
	--_Rollout_A1_subnested = _Rollouts_A_subnested.Roll ("Rollout A1 sub nested")
	--
	--
	--/* ROLLOUTS B */
	--_Rollouts_B = Dialog.Rollouts slot:#Rollouts_B	height:128
	--_Rollout_B1 = _Rollouts_B.Roll ("Rollout B1")	height:96
	--
	
	
	/* CREATE DIALOG */
	Dialog.create()
	--Dialog.create height:512
	
)


/*------------------------------------------------------------------------------
	SLOT HEIGHT
--------------------------------------------------------------------------------*/
--heightIsDefined "Slot Height" slot_height:256

/*------------------------------------------------------------------------------
	ROLLOUT HEIGHT
--------------------------------------------------------------------------------*/
--heightIsDefined "Rollout Height" rollout_height:256


subolloutSlotHeight()

--
----format "\n"; print ".dialogAndSlotHeightByBiggestSubrollout()"
--/* INIT DIALOG */
--Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) --width:320
--
--
--/* ROLLOUTS A */
--_Rollouts_A = Dialog.Rollouts slot:#Rollouts_A
--_Rollout_A1 = _Rollouts_A.Roll ("Rollout A1") --height:256
--_Rollout_A2 = _Rollouts_A.Roll ("Rollout A2") --height:256
--
--/* Set properties of subrollouts */
----_Rollouts_A_set_props	= Dialog.get (#rollouts_A)
--
--
--/* ROLLOUTS A NESTED */
--_Rollouts_A1_nested = _Rollout_A1.Rollouts slot:#Rollouts_A1_nested
--
--_Rollouts_A1_nested_1 = _Rollouts_A1_nested.Roll ("Rollout A1 nested 1") --height:128
--_Rollouts_A1_nested_2 = _Rollouts_A1_nested.Roll ("Rollout A1 nested 2") --height:128
----_Rollouts_A1_nested_3 = _Rollouts_A1_nested.Roll ("Rollout A1 nested 3") --height:128
--
----_Rollouts_A2_nested = _Rollout_A2.Rollouts slot:#Rollouts_A2_nested
----_Rollouts_A2_nested_1 = _Rollouts_A2_nested.Roll ("Rollout A2 nested 1") --height:128
----_Rollouts_A2_nested_2 = _Rollouts_A2_nested.Roll ("Rollout A2 nested 2") --height:128
----_Rollouts_A2_nested_3 = _Rollouts_A2_nested.Roll ("Rollout A2 nested 3") --height:128
--
--
--
--addControls(_Rollouts_A1_nested_1) count:15
--addControls(_Rollouts_A1_nested_2) count:5
--addControls(_Rollout_A2) count:5
--
--
----/* ROLLOUTS A SUB NESTED */
----_Rollouts_A_subnested = _Rollout_A1_nested.Rollouts slot:#Rollouts_A_subnested
----_Rollout_A1_subnested = _Rollouts_A_subnested.Roll ("Rollout A1 sub nested")
----
----
----/* ROLLOUTS B */
----_Rollouts_B = Dialog.Rollouts slot:#Rollouts_B	height:128
----_Rollout_B1 = _Rollouts_B.Roll ("Rollout B1")	height:96
----
--
--
--/* CREATE DIALOG */
--Dialog.create()
----Dialog.create height:512
--
--
