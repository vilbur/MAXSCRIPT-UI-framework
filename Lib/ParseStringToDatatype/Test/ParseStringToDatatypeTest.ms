clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../ParseStringToDatatype.ms" )	--"./../ParseStringToDatatype.ms"


/*------------------------------------------------------------------------------
	DEFINE TEST VALUES
--------------------------------------------------------------------------------*/

filein( getFilenamePath(getSourceFileName()) + "/input_string_values.ms" )	--"./input_string_values.ms"


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
	
	for i = 1 to input_string_values.count do
	(
		--format "\n"
		--format "classOf input_string_values[i]: %\n" (classOf input_string_values[i] )
		output_value = parseStringToDatatype ( input_string_values[i] as string )
		--format "output_value: %\n" output_value
		
		--Ini.save "section" i input_string_values[i] 
		
		--loaded_value = Ini.load "section" i
		
		format "\nRESULT: % 	% 	> 	%\n" (classOf input_string_values[i] == classOf output_value) (input_string_values[i]) (classOf output_value )
		
	)

	
)

/*------------------------------------------------------------------------------

			RUN  TEST

--------------------------------------------------------------------------------*/

testIniSaveAndLoad()

