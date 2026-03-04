clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../Ini.ms" )	--"./../Ini.ms"


/*------------------------------------------------------------------------------
	DEFINE TEST VALUES
--------------------------------------------------------------------------------*/

filein( getFilenamePath(getSourceFileName()) + "/../../ParseStringToDatatype/Test/input_string_values.ms" )	--"./../../ParseStringToDatatype/Test/input_string_values.ms"

/*------------------------------------------------------------------------------
	TEST FUNCTIONS
--------------------------------------------------------------------------------*/

/** Test ini save and loadIni
 */
function testIniSaveAndLoadDataTypes =
(
	format "\n--------------------- testIniSaveAndLoadDataTypes ---------------------\n"
	format "\n"; print ".testIniSaveAndLoadDataTypes()"
	
	
	Ini = Ini_v(getSourceFileName())
	
	--loaded_values = #()
	
	for i = 1 to input_values.count do
	(
		Ini.save "section" i input_values[i] 
		
		loaded_value = Ini.load "section" i
		
		format "RESULT: %	% 	%\n" (classOf input_values[i] == classOf loaded_value) (classOf input_values[i]) input_values[i] 
		
	)

	Ini --return
)

/*------------------------------------------------------------------------------

			RUN  TEST

--------------------------------------------------------------------------------*/

Ini = testIniSaveAndLoadDataTypes()



/* OPEN INI FILE */ 
Ini.open()


