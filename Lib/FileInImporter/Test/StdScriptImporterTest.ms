clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../StdScriptImporter.ms" )	--"./../StdScriptImporter.ms"


files = #(
	"\scripts-to-import\StdScriptImportedX.ms",	-- RELATIVE path
	"scripts-to-import\StdScriptImported.ms",	-- RELATIVE path
	getFilenamePath(getSourceFileName()) + "/scripts-to-import/StdScriptImported.ms"	-- ABSOLUTE path
)

/*------------------------------------------------------------------------------
	CREATE INSTANCE
--------------------------------------------------------------------------------*/
StdScriptImporter 	= StdScriptImporter_v(getSourceFileName())

StdScriptImporter.files = files

/*------------------------------------------------------------------------------
	CREATE IMPORT STD SCRIPTS FILE
--------------------------------------------------------------------------------*/
StdScriptImporter.createStartUpFile()


/*------------------------------------------------------------------------------
	COMMENT
--------------------------------------------------------------------------------*/
--StdScriptImporter.delete()