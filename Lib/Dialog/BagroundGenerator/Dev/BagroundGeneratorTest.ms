clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../BagroundGenerator.ms" )

global test_dialog
global generateBackground

/** Generate background
 */
function generateBackground bg_dialog =
(
	format "\n"; print "generateBackground()"
	format "bg_dialog	= % \n" bg_dialog
	format "bg_dialog.subrollots_slot.rollouts	= % \n" bg_dialog.subrollots_slot.rollouts

	subrollouts_data = #()

	--subrollots_slot_pos = bg_dialog.subrollots_slot.pos.y
	subrollots_slot_pos = bg_dialog.subrollots_slot.pos.y as integer 
	format "subrollots_slot_pos	= % \n" subrollots_slot_pos

	colors = #(red, green, blue)
	
	for i = 1 to bg_dialog.subrollots_slot.rollouts.count do 
	(
		_subrollout = bg_dialog.subrollots_slot.rollouts[i]

		rollout_position	= subrollots_slot_pos - _subrollout.scrollPos

		--rollout_height	= if _subrollout.open then _subrollout.height +22  else 22
		rollout_height	= if _subrollout.open then _subrollout.height +22  else 22
		rollout_color	= colors[i]

		subrollots_slot_pos += rollout_height

		append subrollouts_data #(rollout_position, rollout_height, rollout_color)
	)

	format "subrollouts_data	= % \n" subrollouts_data

	BagroundGenerator 	= BagroundGenerator_v()

	try( close background_bitmap )catch()

	background_bitmap = BagroundGenerator.createBackground (subrollouts_data)

	--display background_bitmap

	format "background_bitmap	= % \n" background_bitmap
	SetDialogBitmap bg_dialog background_bitmap

	completeRedraw
	--format "\n"; print ".generateBackground()"
)

/** Crate test dialog
 */
function crateTestDialog =
(
	try( destroyDialog test_dialog )catch()

	rollout test_dialog "TEST DIALOG" height:256
	(
		subRollout subrollots_slot "subrollots_slot"  height:128
	  --subrollout test2 "test2"
	  
		--on test_dialog create do
			--generateBackground(test_dialog)
	)
	rollout  subrollout_a "subrollout_a"
	(
	  --spinner subrolloutas "subrolloutas"
		on subrollout_a rolledUp val do generateBackground(test_dialog)
	  
	)
	rollout subrollout_b "subrollout_b"
	(
		spinner spinner_b1 "spinner_b1"
		spinner spinner_b2 "spinner_b2"
		spinner spinner_b3 "spinner_b3"
		
		on subrollout_b rolledUp val do generateBackground(test_dialog)

	)

	rollout subrollout_c "subrollout_c"
	(
		spinner spinner_c1 "spinner_c1"
		--spinner spinner_c2 "spinner_c2"
		--spinner spinner_c3 "spinner_c3"
		on subrollout_c rolledUp val do generateBackground(test_dialog)
	)


	--bit_map_A = openBitMap  "c:/GoogleDrive/Programs/CG/3DsMax/scripts/vilTools3/bg_test_A.bmp"
	--bit_map_B = openBitMap  "c:/GoogleDrive/Programs/CG/3DsMax/scripts/vilTools3/bg_test_B.bmp"

	--display bit_map
	--test_dialog.bitmap.bit_map_B
	--CreateDialog test_dialog bitmap:bit_map_A height:256
	CreateDialog test_dialog height:256 width:256

	AddSubRollout test_dialog.subrollots_slot subrollout_a
	AddSubRollout test_dialog.subrollots_slot subrollout_b
	AddSubRollout test_dialog.subrollots_slot subrollout_c

)

crateTestDialog()

