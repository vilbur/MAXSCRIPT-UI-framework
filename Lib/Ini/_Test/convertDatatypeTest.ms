clearListener()

/*------------------------------------------------------------------------------
	
	
	
		TEST OF CONVERTING STRINGS TO CORRECT DATATYPE
	
	
	
--------------------------------------------------------------------------------*/

--strings_for_comparssion = #(
--	"string",
--	"Also string",
--	"C:\This\is\path",
--	"true",
--	"123",
--	"1.0",
--	"[1.1,2.0]",
--	"[1,2,3.3]",
--	"color 1 2 3",
--	"#{}",
--	"#()",
--	"#(#())"
--)

string_is_defined_variable = 999

input_values = #(
	
	/* executed strings bellow manifest as string */ 
	"string_is_defined_variable",
	"simpleString",
	"'single_quoted'",
	"\"double_quoted\"",
	"space in string",
	"C:\String\is\path",
	true,
	false,
	undefined,
	unsupplied,
	0,
	123,
	
	/* executed strings bellow manifest correctly */ 
	1.0,
	[1.1, 2.0],
	[1, 2, 3.3],
	color 128 64 0,
	#{},
	#{1..3},
	#(),
	#(#())
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
	format "classOf = % \n" (classOf val_converted)
	format "output  = % \n" val_converted
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

		formatOutput (_string) (correct_datatype)
	)
)

/** Join strings to string array
 */
function joinToStringArray strings =
(
	--format "\n"; print ".joinToStringArray()"
	delimeter = ","
	_string = ""

	for i=1 to strings.count do
		_string += (if classOf strings[i] == string then "\"" +strings[i]+ "\""  else strings[i] as string ) + delimeter

	_string = trimRight _string delimeter

	"#("+_string+")" --return
)


/*------------------------------------------------------------------------------
  
	TEST FUNCTIONS
	
--------------------------------------------------------------------------------*/

function convertStringToDatatype _string =
(
	--format "is_string     = % \n" is_string
	format "\nInput:"; print _string

	rx	= dotNetClass "System.Text.RegularExpressions.RegEx"
	rx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"
	
	known_class  = (rx.match _string "^\s*(\d+|true|false|undefined|unsupplied|\(\s*color\s+\d+\s+\d+\s+\d+\s*\))\s*$" rx_options.IgnoreCase ).success
	
	if known_class == false and (is_string = ( rx.match _string "(^'*[A-Za-z0-1_]+'*$)|[\s\\\/]" rx_options.IgnoreCase ).success ) then _string else try((execute(_string)))catch()
	
)


/** Test string array
 */
function testStringArray =
(
	print "STRING ARRAY TEST"
	format "\n"

	this_is_string = joinToStringArray(input_values)
	this_is_array = convertStringToDatatype(this_is_string)
	format "this_is_string = % \n\n" this_is_string
	format "this_is_array  = % \n\n" this_is_array

	for item in this_is_array do
		format " 	item: %	is classOf:% \n\n"  item (classOf item)
)


/*------------------------------------------------------------------------------

					RUN TEST

--------------------------------------------------------------------------------*/

convertStringsToDatatypes()

--testStringArray()