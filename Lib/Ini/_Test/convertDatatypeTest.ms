clearListener()

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
	
	/* EXECUTED VALUES BELLOW ARE CORRECT */
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
	"END OF ARRAY" -- prevent last item comma error when testing
)

/*------------------------------------------------------------------------------
	HELP FUNCTIONS
--------------------------------------------------------------------------------*/
/** Convert values to strings
 */
function convertValuesToStrings values =
(
	----format "\n"; print ".convertValuesToStrings()"
	strings = #()

	for i=1 to values.count do
		append strings ( values[i] as string )

	strings --return
)
/** Format output
 */
function formatOutput input_val val_converted =
(
	format "\nInput:"; print input_val
	format "output  = % \n" val_converted
	format "classOf = % \n" (classOf val_converted)
)


/** Join strings to string array
 */
function joinToStringArray strings =
(
	--format "\n"; print ".joinToStringArray()"
	delimeter = ","
	_string = ""

	for i=1 to strings.count do
	(
		string_input =
		
		if classOf strings[i] == string and matchPattern strings[i] pattern:"\"*" == false then
			_string += "\"" +strings[i]+ "\"" 
			
		else
			_string +=  strings[i] as string
		
		_string += delimeter
		
	)

	_string = trimRight _string delimeter

	"#("+_string+")" --return
)


/*------------------------------------------------------------------------------
  
	TEST FUNCTIONS
	
--------------------------------------------------------------------------------*/

function convertStringToDatatype _string =
(
	format "\n"; print "convertStringToDatatype()"
	
	rx	= dotNetClass "System.Text.RegularExpressions.RegEx"
	rx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"
	
	--is_variable = (rx.match _string "^\s*(\d+|true|false|undefined|unsupplied|\(\s*color\s+\d+\s+\d+\s+\d+\s*\))\s*$" rx_options.IgnoreCase ).success
	is_variable = (rx.match _string "^\s*(\d+|true|false|undefined|unsupplied|\(*\s*color\s+\d+\s+\d+\s+\d+\s*\)*|\(*\s*bitmap\s+\d+\s+\d+)\s*$" rx_options.IgnoreCase ).success

	if is_variable and (is_string = ( rx.match _string "(^'*[A-Za-z0-1_\s]+'*$)" rx_options.IgnoreCase ).success ) then
	(
		try((execute(_string)))catch(_string) -- IS VARIABLE
	)
	else
	(
		@"" + _string -- IS STRING
	)
)


/** Convert strings to datatypes
 */
function convertStringsToDatatypes =
(
	--format "\n"; print ".convertStringsToDatatypes()"
	strings = convertValuesToStrings(input_values)

	for _string in strings do
	(
		correct_datatype = convertStringToDatatype(_string)
		--format "correct_datatype	= % \n" correct_datatype
		--format "classof correct_datatype	= % \n" (classof correct_datatype)
		formatOutput (_string) (correct_datatype)
	)
)

/** Test string array
 */
function testStringArray =
(
	print "STRING ARRAY TEST"
	format "\n"

	this_is_string = joinToStringArray(input_values)
	--format "this_is_string = % \n\n" this_is_string
	
	for item in (convertStringToDatatype(this_is_string)) do
		format "item:    %\nclassOf: % \n\n"  item (classOf item)
)



/*------------------------------------------------------------------------------

			RUN SINGLE TESTS

--------------------------------------------------------------------------------*/

--escaped_quotes = convertStringToDatatype("\"escaped_quotes\"")
--format "escaped_quotes	= % \n" escaped_quotes
--
--not_escaped_path = convertStringToDatatype(@"C:\not escaped\path")
--format "not_escaped_path	= % \n" not_escaped_path

--string_array = convertStringToDatatype( "#(\"escaped_quotes\")" )
--format "string_array	= % \n" string_array
--format "classof string_array	= % \n" (classof string_array)


/*------------------------------------------------------------------------------

			RUN MASS TESTS

--------------------------------------------------------------------------------*/

convertStringsToDatatypes()

--testStringArray()




