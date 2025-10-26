clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../Ini.ms" )	--"./../Ini.ms"

/*------------------------------------------------------------------------------
	
	
	
		TEST OF CONVERTING STRINGS TO CORRECT DATATYPE
	
	
	
--------------------------------------------------------------------------------*/

string_is_defined_variable_also = 999

input_values =
#(
	/* EXECUTED VALUES BELLOW APPEAR AS STRING */
	"Render X",
	"classOf X",
	"string_is_defined_variable_also",
	"simpleString",
	"'single_quoted'",
	"\"escaped_quotes\"",
	"space in string",
	@"C:\not escaped\path",
	"C:/forward/slash/path",
	
	true,
	false,
	undefined,
	unsupplied,
	
	0,
	123,
	1e9,
	
	1.0,
	
	[1.1, 2.0],
	[1, 2, 3.3],
	
	color 128 64 0,
	( color 128 32 256),
	
	#{},
	#{1..3},
	
	#(),
	#(#()),
	#(1, 2 ,3, "A", "B", "C"),
	
	
	/* BITMAP IS OBJECT - CANNOT BE CONVERTED TO STRING WITH "as string" command  */ 
	"bitmap 256 32 color:green",
	
	
	/* LAST ITEM IN ARRAY */ 
	#END_OF_ARRAY -- prevent last item comma error when testing
)

/*------------------------------------------------------------------------------
	TEST FUNCTIONS
--------------------------------------------------------------------------------*/

/** Test ini save and loadIni
 */
function testIniSaveAndLoad =
(
	format "\n--------------------- testIniSaveAndLoad ---------------------\n"
	format "\n"; print ".testIniSaveAndLoad()"
	
	
	Ini = Ini_v(getSourceFileName())
	
	--loaded_values = #()
	
	for i = 1 to input_values.count do
	(
		Ini.save "section" i input_values[i] 
		
		loaded_value = Ini.load "section" i
		
		format "RESULT: %	% 	%\n" (classOf input_values[i] == classOf loaded_value) (classOf input_values[i]) input_values[i] 
		
	)

	
)

/*------------------------------------------------------------------------------

			RUN  TEST

--------------------------------------------------------------------------------*/

testIniSaveAndLoad()


