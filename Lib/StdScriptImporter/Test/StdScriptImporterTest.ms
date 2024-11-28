clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../StdScriptImporter.ms" )	--"./../StdScriptImporter.ms"


files = #(
	"\scripts-to-import\StdScriptImported.msX",	-- RELATIVE path
	"scripts-to-import\StdScriptImported.ms",	-- RELATIVE path
	getFilenamePath(getSourceFileName()) + "/scripts-to-import/StdScriptImported.ms"	-- ABSOLUTE path
)


StdScriptImporter 	= StdScriptImporter_v(getSourceFileName())




StdScriptImporter.files = files


StdScriptImporter.import()