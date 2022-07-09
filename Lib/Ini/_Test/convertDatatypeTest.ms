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

executed_string_is_variable = 999

input_values = #(
	"simpleString",
	"executed_string_is_variable",
	"'quoted_string'",
	"space in string",
	"C:\String\is\path",
	true,
	123,
	1.0,
	[1.1,2.0],
	[1,2,3.3],
	color 1 2 3,
	#{},
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
		append strings ( values[i] as string)

	strings --return
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

/** Format output
 */
function formatOutput input_val val_converted =
(
	format "\"%\" 	=> 	%	\nis classOf:% \n\n" input_val val_converted (classOf val_converted)
)

/*------------------------------------------------------------------------------
  
	TEST FUNCTIONS
	
--------------------------------------------------------------------------------*/

function convertStringToDatatype _string =
(	
	match_string  = (( dotNetClass "System.Text.RegularExpressions.RegEx" ).match _string "^'*[A-Za-z0-1_]+'*$" ( dotNetClass "System.Text.RegularExpressions.RegexOptions" ).IgnoreCase ).success
	val_converted = try((execute(_string)))catch()
	classof_val   = classOf val_converted

	if ( match_string and classof_val != BooleanClass ) or classof_val == string  or classof_val == UndefinedClass  then substituteString _string "\\" "\\\\" else val_converted
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