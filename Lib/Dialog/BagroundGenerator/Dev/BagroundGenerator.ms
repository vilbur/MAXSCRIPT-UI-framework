clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../BagroundGenerator.ms" )

global test_dialog
/** Crate test dialog
 */
function crateTestDialog =
(
	try( destroyDialog test_dialog )catch()

	rollout test_dialog "test_dialog" height:256
	(
		subRollout slot_1 "slot_1"  height:242
	  --subrollout test2 "test2"
	)
	rollout  subrollouta "subrollouta"
	(
	  --spinner subrolloutas "subrolloutas"
	)
	rollout subrolloutb "subrolloutb"
	(
	  --spinner test1bs "test1bs"
	)
	
	--bit_map_A = openBitMap  "c:/GoogleDrive/Programs/CG/3DsMax/scripts/vilTools3/bg_test_A.bmp"
	--bit_map_B = openBitMap  "c:/GoogleDrive/Programs/CG/3DsMax/scripts/vilTools3/bg_test_B.bmp"
	
	--display bit_map
	--test_dialog.bitmap.bit_map_B
	--CreateDialog test_dialog bitmap:bit_map_A height:256
	CreateDialog test_dialog height:256
	
	AddSubRollout test_dialog.slot_1 subrollouta
	AddSubRollout test_dialog.slot_1 subrolloutb

)


--crateTestDialog()


BagroundGenerator 	= BagroundGenerator_v()

background_bitmap = BagroundGenerator.createBackground #( 32, 64)

format "background_bitmap	= % \n" background_bitmap
SetDialogBitmap test_dialog background_bitmap

--close background_bitmap