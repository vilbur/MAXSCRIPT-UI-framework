/*------------------------------------------------------------------------------
	
	ALL DATA TYPES READY TO CONVERT TO STRING

--------------------------------------------------------------------------------*/
string_is_defined_variable = 999

input_string_values =
#(
	/* EXECUTED VALUES BELLOW APPEAR AS STRING */
	"Render X",
	"classOf X",
	"string_is_defined_variable",
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
	#{1..3,5},
	
	#(),
	#(#("nested array")),
	#(1, 2 ,3, "A", "B", "C"),
	
	
	
	/*------------------------------------------------------------------------------
		
		DATATYPES WHICH CANNOT BE CONVERTED TO STRING WITH "as string" command
		
	--------------------------------------------------------------------------------*/
	
	
	/* BITMAP IS OBJECT */ 
	"bitmap 256 32",
	"bitmap 256 32 color:green",
	
	
	/* NAME */ 
	"#NAME_TEST"
)