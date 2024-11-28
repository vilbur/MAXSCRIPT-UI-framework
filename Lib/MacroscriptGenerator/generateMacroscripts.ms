filein( getFilenamePath(getSourceFileName()) + "/MacroscriptGenerator.ms" )	--"./MacroscriptGenerator.ms"


/** Mass generate .mcr files from .ini files
  *
  * 1) Loop *.mcr.ini in subfolders
  * 2) convert them to *.mcr files
  * 3) filein them
  *
 */
function generateMacroscripts dir =
(
	--format "\n"; print ".generateMacroscripts()"
	for ini_file in getFiles ( dir + "\\*.mcr.ini") recurse:true do
	(
		mcr_file = (MacroscriptGenerator_v(ini_file)).generateMacroscriptFile()
	
		--format "mcr.ini Converted:	% \n" (mcr_file)
	
		filein  mcr_file
	)
)