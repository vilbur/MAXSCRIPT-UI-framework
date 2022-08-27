clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

/** Add sub rollouts
 */
function addSubRolloutSlots _Rollouts number_of_slots: number_of_rollouts: =
(
	Subollout_slots = #()

	for r = 1 to _Rollouts.count do 
	(
		_Rollout = _Rollouts[r]

		for s = 1 to number_of_slots do 
		(
			slot = ("Slot_"+ s as string )
		
			Subollout_slot = _Rollout.Rollouts slot:slot
		
			append Subollout_slots Subollout_slot
		)
	)

	Subollout_slots --return
)

/** Add subrollouts
 */
function addSubrollouts Subollout_slots number_of_rollouts: level: =
(
	SubRollouts = #()

	for s = 1 to Subollout_slots.count collect 
	(
		Subollout_slot = Subollout_slots[s]

		for r = 1 to number_of_rollouts do 
		(

			title = ("Level: " + level as string +" "+ Subollout_slot.slot as string + " Rollout:"+ r as string )
			--title = ( Subollout_slot.slot as string  + " Level:" + level as string )
	
			_SubRollout = Subollout_slot.Roll title
	
			_Controls    = _SubRollout.Controls group:"Subrollout Controls"

			for i = 1 to 5 do 
				_Controls.control #button ( Subollout_slot.slot as string +" "+ i as string ) across:1

	
			append SubRollouts _SubRollout
		)

	)

	SubRollouts --return
)

/* DIALOG */

/** Create dialog
 */
function createDialogWithSubrollouts number_of_slots: nested_level: slot_height: =
(
	--format "\n"; print ".createDialog()"
	Dialog 	= Dialog_v title:(getFilenameFile(getSourceFileName())) width:512 height:1024 
	--Dialog 	= Dialog_v title:("Subrollouts Mass Test height " + height as string ) width:512 height:height

	--_Rollouts = #(Dialog.RolloutMain)
	_Rollout = Dialog

	Subollout_slots	= addSubRolloutSlots #(_Rollout) number_of_slots:1 
	SubRollouts	= addSubrollouts Subollout_slots number_of_rollouts:1 level:1
	
	Subollout_slots	= addSubRolloutSlots SubRollouts number_of_slots:1 
	SubRollouts	= addSubrollouts Subollout_slots number_of_rollouts:2 level:2

	Subollout_slots	= addSubRolloutSlots SubRollouts number_of_slots:number_of_slots 
	SubRollouts	= addSubrollouts Subollout_slots number_of_rollouts:1 level:3
	
	/* CREATE DIALOG */ 
	Dialog.create()
)

--createDialogWithSubrollouts number_of_slots:2 slot_height:512
--createDialogWithSubrollouts number_of_slots:1 nested_level:3
createDialogWithSubrollouts number_of_slots:2 nested_level:2