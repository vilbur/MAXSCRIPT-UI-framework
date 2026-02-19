clearListener(); print("Cleared in: "+getSourceFileName())

/*==============================================================================

	TEST AND PROOF DIFFERNET DATATYPES OF LCOAL VARIABLE IN ROLLOUT\DIALOG

================================================================================*/

win_width = 160
win_pos	  = getMAXWindowPos() + [512,512]

try( destroyDialog rollout_test )catch()
try( destroyDialog rollout_rci )catch()


/*==============================================================================
	
	FRAMEWORK VERSION
	
	"./../../../Test/Dialog/02_DialogLocalVariableTest.ms"
	
================================================================================*/


/*==============================================================================
	STANDARD VERSION
================================================================================*/

rollout rollout_test "Standard Rollout Test"
(
	/* --- 1. Local Variable Definitions --- */
	-- In a standard rollout, you declare these at the top level of the struct
	local prop_string = "Hello World"
	local prop_name = #NAME_TEST
	local prop_number = 12
	local prop_array  = #("Item A", "Item B", 3)
	local prop_color  = (color 0 120 255)
	local prop_p3     = [10.5, 20.0, 0.0]
	local prop_bool   = true

	/* --- 2. UI Controls --- */
	button btn_str  "Test String" width:140
	button btn_name "Test Name" width:140
	button btn_num  "Test Number" width:140
	button btn_arr  "Test Array"  width:140
	button btn_col  "Test Color"  width:140
	button btn_p3   "Test Point3" width:140
	button btn_bool "Test Boolean"   width:140

	/* --- 3. Event Handlers --- */
	
	on btn_str pressed do
		messageBox prop_string title:"String Property"
		
	on btn_name pressed do
		messageBox ( ( classOf prop_name) as string ) title:"Name Property"

	on btn_num pressed do
		messageBox ( ( classOf prop_number) as string ) title:"Number Property"

	on btn_arr pressed do
		messageBox ( ( classOf prop_array) as string ) title:"Array Property"

	on btn_col pressed do
		messageBox ( ( classOf prop_color) as string ) title:"Color Property"

	on btn_p3 pressed do
		messageBox ( ( classOf prop_p3) as string ) title:"Point3 Property"

	on btn_bool pressed do
		messageBox ( ( classOf prop_bool) as string ) title:"Boolean Property"
)


-- Create the dialog from the definition above
CreateDialog rollout_test width:win_width pos:win_pos


/*==============================================================================
	RCI VERSION
================================================================================*/


rci = rolloutCreator "rollout_rci" "RCI Rollout"
rci.begin()


/* --- String Example --- */
rci.addLocal "prop_string" init:"\"String value\""
rci.addControl #button #btn_prop_string "Test String"
rci.addHandler #btn_prop_string #pressed codeStr:"messageBox ( (classOf rollout_rci.btn_prop_string ) as string )"

/* --- Name Example --- */
rci.addLocal "prop_name" init:"#NAME_TEST"
rci.addControl #button #btn_prop_name "Test Name"
rci.addHandler #btn_prop_name #pressed codeStr:"messageBox ( (classOf rollout_rci.prop_name ) as string )"


/* --- Number Example --- */
rci.addLocal "prop_number" init:12
rci.addControl #button #btn_prop_number "Test Number"
-- Note: Numbers are automatically converted in some contexts, but 'as string' is safer
rci.addHandler #btn_prop_number #pressed codeStr:"messageBox ( (classOf rollout_rci.prop_number ) as string )"

/* --- NEW: Array --- */
-- arrays must be passed as a string representation of the array
rci.addLocal "prop_array" init:"#(\"Item A\", \"Item B\", 3)" 
rci.addControl #button #btn_prop_array "Test Array"
rci.addHandler #btn_prop_array #pressed codeStr:"messageBox ( (classOf rollout_rci.prop_array ) as string )"

/* --- NEW: Color --- */
-- color literals allow you to define RGB e.g., (color 255 0 0)
rci.addLocal "prop_color" init:"(color 0 120 255)" 
rci.addControl #button #btn_prop_color "Test Color"
rci.addHandler #btn_prop_color #pressed codeStr:"messageBox ( (classOf rollout_rci.prop_color ) as string )"

/* --- NEW: Point3 (Vector) --- */
-- Point3 is used for coordinates [x,y,z]
rci.addLocal "prop_p3" init:"[10.5, 20.0, 0.0]" 
rci.addControl #button #btn_prop_p3 "Test Point3"
rci.addHandler #btn_prop_p3 #pressed codeStr:"messageBox ( (classOf rollout_rci.prop_p3 ) as string )"

/* --- NEW: Boolean --- */
-- True or False
rci.addLocal "prop_bool" init:"true" 
rci.addControl #button #btn_prop_bool "Test Boolean"
rci.addHandler #btn_prop_bool #pressed codeStr:"messageBox ( (classOf rollout_rci.prop_bool ) as string )"


CreateDialog (rci.end()) pos:[ win_pos.x + win_width, win_pos.y ]
