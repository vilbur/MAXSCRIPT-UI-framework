clearListener(); print("Cleared in: "+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MarkdownGenerator.ms" )	--"./../MarkdownGenerator.ms"


/** Get test data
 */
function getTestData =
(
	--format "\n"; print ".getTestData()"
	test_dict   = Dictionary #STRING
	ordered_list = Dictionary #INTEGER
	
	test_dict["Header"] = "Text"
	
	arr = #("A","B","C")
	test_dict["List"] = arr
	
	ordered_list[1] = "First"
	ordered_list[2] = "Second"
	
	test_dict["Steps"] = ordered_list
	
	test_dict --return
)

/*------------------------------------------------------------------------------
	PREPARE TEST
--------------------------------------------------------------------------------*/
md_file_path = getDir #TEMP + "/md-generator-test.md"

test_data = getTestData()

/*------------------------------------------------------------------------------
	RUN TEST
--------------------------------------------------------------------------------*/
MarkdownGenerator = MarkdownGenerator_v(md_file_path)

MarkdownGenerator.generate test_data


/*------------------------------------------------------------------------------
	OUTPUT
--------------------------------------------------------------------------------*/

DOSCommand ("\""+md_file_path+"\"")

DOSCommand ("notepad++ \""+md_file_path+"\"")