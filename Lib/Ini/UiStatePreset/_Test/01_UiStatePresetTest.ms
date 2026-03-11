clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../UiStatePreset.ms" )	--"./../UiStatePreset.ms"

try(destroyDialog testRollout)catch()

global testRollout = undefined
global subRollout_1 = undefined
global nestedSubRollout_1 = undefined

global UiStatePreset = UiStatePreset_v (getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini")

/*------------------------------------------------------------
  Creates rollout with all common UI control types for testing.
  Layout uses offset instead of absolute pos coordinates.
------------------------------------------------------------*/
function createTestControlsRollout =
(
	rollout testRollout "Control Types Test" width:256 --height:1280
	(
		/*------------------------------------------------------------------------------
			CONTROLS FOR SAVE\LOAD PRESET
		--------------------------------------------------------------------------------*/
		button btn_preset_save "SAVE DIALOG STATE" offset:[-10, 10] width:80 height:48 across:3 align:#LEFT
		on btn_preset_save pressed do UiStatePreset.save (testRollout)
		
		button btn_preset_load "LOAD DIALOG STATE" offset:[0,10] width:80 height:48 across:3 align:#CENTER
		on btn_preset_load pressed do UiStatePreset.load (testRollout)

		button btn_open_ini "OPEN INI" offset:[ 10, 10] width:80 height:48 across:3 align:#RIGHT
		on btn_open_ini pressed do UiStatePreset.open ()

		
		
		
		/*------------------------------------------------------------------------------
		
			TEST CONTROLS
		
		--------------------------------------------------------------------------------*/
		
		/* Checkbox */
		checkbox chk "Checkbox" offset:[0,20]
		
		/* Spinner */
		spinner spn "Spinner: " offset:[0,10] width:150 height:16 range:[0,100,25] align:#LEFT
		
		/* DropdownList */
		dropdownlist ddl "Dropdown: " offset:[0, 10] width:150 items:#("Red","Green","Blue")
		
		
		/* ComboBox */
		combobox cmb "Combo: " offset:[0,20] width:150 items:#("Item1","Item2","Item3") height:4
		
		/* ListBox */
		listbox lb "ListBox" offset:[0,10] width:150 height:3 items:#("One","Two","Three")
		
		/* MultiListBox */
		multilistbox mlb "MultiListBox" offset:[0,10] width:150 items:#("A","B","C") height:3 
		
		/* RadioButtons */
		radiobuttons rb "RadioButtons" offset:[ 64,10] labels:#("Option1","Option2","Option3") default:1 columns:1 align:#LEFT
		
		
		/* Slider */
		slider sld "Slider" offset:[0,20] range:[0,100,50] width:200
			
		/* EditText */
		edittext edt "EditText: " offset:[0,10] width:200 height:18 text:"text"
		
				
		
		/* ColorPicker */
		colorpicker cp "ColorPicker" offset:[0,20] width:150 height:25 color:(color 255 0 0)
		
		--/* Angle controls */
		angle ang3 "Angle 3" diameter:128 range:[0,360,120] startdegrees:270 dir:#cw color:blue align:#LEFT

		
		/* MaterialButton */
		materialbutton matbtn "Material" offset:[0,20] width:72 height:24 across:2
		
		/* MapButton */
		mapbutton mapbtn "Map" offset:[0,20] width:72 height:24 across:2
		
		/*==============================================================================
		
			CURRENTLY UNSUPPORT SAVE CONTROL VALUES
		
		================================================================================*/

		/* CurveControl */
		--curvecontrol curve "CurveControl" offset:[ 0, 0] width:248 height:120

		
		/*==============================================================================
			
			POROBLEMATIC CONTROL TYPES TO GET THEIR VALUE
			
			WORKAROUND NEEDED  --"./../../_Dev/GET_bitmap.filename_PROPERTY_PROBLEM.ms"

		================================================================================*/
		

		/* imgTag --"./../../_Dev/GET_bitmap.filename_PROPERTY_PROBLEM.ms" */
		imgTag img_tag bitmap:(bitmap 64 64 color:green) offset:[ 0, 20 ] width:64 height:64 across:2
		
		/* Bitmap --"./../../_Dev/GET_bitmap.filename_PROPERTY_PROBLEM.ms" */
		bitmap bmp bitmap:(bitmap 64 64 color:blue) offset:[ 0, 20 ] width:64 height:64 across:2
				
		--/* Hyperlink -- UNABLE TO GET PROPERTY hyperlink_ctrl.address */
		hyperlink hyperlink_ctrl "Hyperlink" offset:[0,20] width:150 height:16 address:"https://www.autodesk.com"


		/*============================================================================== 
            NON-EDITABLE CONTROLS
		================================================================================*/	

		--/* Label */
		--label lbl "Label Control" offset:[20,20] width:200 height:16
		--
		--/* Button */
		--button btn "Button" offset:[0,10] width:120 height:24
		--/* CheckButton */
		--checkbutton chkbtn "CheckButton" offset:[0,10] width:120 height:24
		--
		--/* PickButton */
		--pickbutton pick "Pick Object" offset:[0,10] width:120 height:24
		


		/*------------------------------------------------------------------------------
		
			SUBROLLOUTS
		
		--------------------------------------------------------------------------------*/
		subRollout subrollouts_slot "subrollouts slot" width:232 height:256
		
		
	)

	/* CREATE DIALOG */ 
	createDialog testRollout style:#(#style_titlebar,#style_sysmenu,#style_resizing)
	
	
	
	/*==============================================================================
		SUBROLLOURS
	================================================================================*/

	rollout subRollout_1 "Sub Rollout 1"
	(
		edittext edt_subrollout "EditText: " offset:[0,10] height:18 text:"Subrollout text"

		subRollout nested_subrollouts_slot "subrollouts slot" width:200 height:128
	)
	
	rollout subRollout_2 "Sub Rollout 2"
	(
	)
	
	rollout subRollout_3 "Sub Rollout 3"
	(
	)
	
	rollout nestedSubRollout_1 "Nested Rollout 1"
	(
		edittext edt_nestedsubrollout "EditText: " offset:[0,10] height:18 text:"Nested subrollout text"
	)
	rollout nestedSubRollout_2 "Nested Rollout 2"
	(
	)
	
    AddSubRollout testRollout.subrollouts_slot subRollout_1
    AddSubRollout testRollout.subrollouts_slot subRollout_2
    AddSubRollout testRollout.subrollouts_slot subRollout_3
	
    AddSubRollout subRollout_1.nested_subrollouts_slot nestedSubRollout_1
    AddSubRollout subRollout_1.nested_subrollouts_slot nestedSubRollout_2
	
	testRollout --return
)

/*------------------------------------------------------------
  Change editable values of all supported controls in rollout.
  Used for testing control value updates.
------------------------------------------------------------*/
function changeValuesOfControls =
(
	if testRollout == undefined then return false

	--bitmap_file = (getDir #ui) + "Icons\\" + "MaxStart.bmp"
	--bitmap_file = (getDir #ui) + "Icons\\" + "AddPreset_16i.bmp"
	bitmap_file = (getDir #maxSysIcons) + "\\AddPreset_16i.bmp"
	
	
	bit_map = openBitmap (bitmap_file)
	
	--bit_map = bitmap 64 64 filename:bitmap_file


	
	try( testRollout.edt.text = "changed" )catch()
	try( testRollout.spn.value = 75 )catch()
	try( testRollout.chk.checked = not testRollout.chk.checked )catch()
	try( testRollout.chkbtn.checked = not testRollout.chkbtn.checked )catch()
	try( testRollout.sld.value = 80 )catch()
	try( testRollout.cp.color = (color 0 200 255) )catch()
	try( testRollout.ddl.selection = 2 )catch()
	try( testRollout.cmb.selection = 3 )catch()
	try( testRollout.lb.selection = 2 )catch()
	try( testRollout.mlb.selection = #(1,3) )catch()
	try( testRollout.rb.state = 2 )catch()
	try( testRollout.ang3.degrees = 45 )catch()
	
	
	try( testRollout.matbtn.material = meditMaterials[1] )catch()
	try( testRollout.mapbtn.map = bitmap_file )catch()
	
	
	
	try( testRollout.img_tag.bitmap = bit_map )catch()
	try( testRollout.bmp.bitmap = bit_map )catch()
	 
	
	/*------------------------------------------------------------------------------
		SUBROLOUTS
	--------------------------------------------------------------------------------*/
	subrollout_2 = testRollout.subrollouts_slot.rollouts[2]
	--format "subrollout_2: %\n" subrollout_2
	--try( subRollout_2.edt_nestedsubrollout.text = "SUBROLLOUT TEXT CHANGED" )catch()
	
	/* CHANGE ORDER OF SUBROLOUTS */
	RemoveSubRollout testRollout.subrollouts_slot subRollout_2
	AddSubRollout testRollout.subrollouts_slot subRollout_2
	
	/* EDIT CONTROL AFTER REORDER */ 
	nestedSubRollout_1.edt_nestedsubrollout.text = "TEXT CHANGED"
)

/*==============================================================================

	TEST

================================================================================*/

/*------------------------------------------------------------------------------
	SAVE UI STATE
--------------------------------------------------------------------------------*/

/* CREATE FRESH DIALOG */ 
createTestControlsRollout()

/* EDIT VALUES OF CONTROL */ 
--changeValuesOfControls()

--format "TESTROLLOUT: %\n" testRollout
/* SAVE UI STATE */
--UiStatePreset.save (rollout_param)


/*------------------------------------------------------------------------------
	LOAD UI STATE
--------------------------------------------------------------------------------*/

/* CREATE FRESH DIALOG */ 
--createTestControlsRollout()

/* LOAD UI STATE */ 
--UiStatePreset.load (testRollout)

/* OPEN INI FILE */ 
--UiStatePreset.open()





