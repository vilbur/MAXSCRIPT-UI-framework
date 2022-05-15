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

input_values = #(
	"test",
	"space in string",
	"C:\This\is\path",
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
	CONVERT DATA TYPE
--------------------------------------------------------------------------------*/

function convertStringToDatatype _string =
(
	if classOf (val_converted = try((execute(_string)))catch()) == UndefinedClass then val_converted = substituteString _string "\\" "\\\\"

	val_converted --return
)

/*------------------------------------------------------------------------------
	TEST FUNCTIONS
--------------------------------------------------------------------------------*/

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
/*------------------------------------------------------------------------------
	HELP FUNCTIONS
--------------------------------------------------------------------------------*/

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

/*------------------------------------------------------------------------------

					RUN TEST

--------------------------------------------------------------------------------*/

convertStringsToDatatypes()

--testStringArray()