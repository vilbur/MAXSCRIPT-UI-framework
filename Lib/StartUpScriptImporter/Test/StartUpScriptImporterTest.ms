clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../StartUpScriptImporter.ms" )	--"./../StartUpScriptImporter.ms"


files = #(
	"\scripts-to-import\StdScriptImportedX.ms",	-- RELATIVE path
	"scripts-to-import\StdScriptImported.ms",	-- RELATIVE path
	getFilenamePath(getSourceFileName()) + "/scripts-to-import/StdScriptImported.ms"	-- ABSOLUTE path
)

/*------------------------------------------------------------------------------
	CREATE INSTANCE
--------------------------------------------------------------------------------*/
StartUpScriptImporter 	= StartUpScriptImporter_v(getSourceFileName())

StartUpScriptImporter.files = files

/*------------------------------------------------------------------------------
	CREATE IMPORT STD SCRIPTS FILE
--------------------------------------------------------------------------------*/
StartUpScriptImporter.createStartUpFile()


/*------------------------------------------------------------------------------
	COMMENT
--------------------------------------------------------------------------------*/
--StartUpScriptImporter.delete()