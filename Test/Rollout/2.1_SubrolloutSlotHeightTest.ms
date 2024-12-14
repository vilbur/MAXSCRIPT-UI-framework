clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" ) -- "./../../Lib/Dialog/Dialog.ms"


/** Add item controls
 */
function addControls _Rollout count:10 =
(
	Controls = _Rollout.Controls()
	
	for i = 1 to count do 
		Controls.control #BUTTON ( "BUTTON" + i as string ) across:1
)


/** Dialog and slot height by biggest subrollout
 */
function dialogAndSlotHeightByBiggestSubrollout =
(
	--format "\n"; print ".dialogAndSlotHeightByBiggestSubrollout()"
	/* INIT DIALOG */
	Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) width:320
	
	
	/* ROLLOUTS A */
	_Rollouts_A = Dialog.Rollouts slot:#Rollouts_A
	_Rollout_A1 = _Rollouts_A.Roll ("Rollout A1") --height:256
	
	/* Set properties of subrollouts */
	--_Rollouts_A_set_props	= Dialog.get (#rollouts_A)
	
	
	/* ROLLOUTS A NESTED */
	_Rollouts_A_nested = _Rollout_A1.Rollouts slot:#Rollouts_A_nested
	_Rollout_A1_nested = _Rollouts_A_nested.Roll ("Rollout A1 nested") --height:128
	_Rollout_A2_nested = _Rollouts_A_nested.Roll ("Rollout A2 nested") --height:128
	_Rollout_A3_nested = _Rollouts_A_nested.Roll ("Rollout A3 nested") --height:128
	
	
	addControls(_Rollout_A1_nested) count:30
	addControls(_Rollout_A2_nested) count:10
	
	
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




dialogAndSlotHeightByBiggestSubrollout()