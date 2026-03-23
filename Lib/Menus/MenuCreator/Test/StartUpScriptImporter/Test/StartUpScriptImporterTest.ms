clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../StartUpScriptImporter.ms" )	--"./../StartUpScriptImporter.ms"


files = #(
	"scripts-to-import\StdScriptImported.ms",	-- RELATIVE path
	getFilenamePath(getSourceFileName()) + "/scripts-to-import/StdScriptImported.ms",	-- ABSOLUTE path
	"\scripts-to-import\this-file-not-exists.ms"	-- TEST NOT EXISTING FILE
)

/*------------------------------------------------------------------------------
	CREATE INSTANCE
--------------------------------------------------------------------------------*/
StartUpScriptImporter 	= StartUpScriptImporter_v(getSourceFileName())

/* SET ROOT PATH FOR RELATIVE PATHS IN FILES ARRAY */ 
StartUpScriptImporter.root = getFilenamePath(getSourceFileName())

/* ADD FILES TO IMPORT */ 
StartUpScriptImporter.files = files



/*------------------------------------------------------------------------------
	CREATE IMPORT STD SCRIPTS FILE
--------------------------------------------------------------------------------*/
StartUpScriptImporter.createStartUpFile()


/*------------------------------------------------------------------------------
	DELETE FILE
--------------------------------------------------------------------------------*/
--StartUpScriptImporter.delete()