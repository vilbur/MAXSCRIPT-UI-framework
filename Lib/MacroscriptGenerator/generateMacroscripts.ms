

filein( getFilenamePath(getSourceFileName()) + "/MacroscriptGenerator.ms" )	--"./MacroscriptGenerator.ms"



/** Mass generate .mcr files from .ini files
  *
  * 1) Search for *.mcr.ini in subfolders
  * 2) Convert them to *.mcr files
  * 3) filein them
  *
 */
function generateMacroscripts source_path =
(
	--format "\n"; print ".generateMacroscripts()"


	if doesFileExist source_path and not doesDirectoryExist source_path then
		source_path = getFilenamePath(source_path)

	for ini_file in getFiles ( source_path +"\\*.mcr.ini" )  recurse:true do
	(
		mcr_file = (MacroscriptGenerator_v(ini_file)).generateMacroscriptFile()

		format "mcr.ini Converted:	% \n" (mcr_file)

		filein  mcr_file
	)


)
