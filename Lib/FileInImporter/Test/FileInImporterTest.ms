clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../StartUpScriptImporter.ms" )	--"./../StartUpScriptImporter.ms"


files = #(
	"scripts-to-import\scriptFileToImport.ms",	-- RELATIVE path
	getFilenamePath(getSourceFileName()) + "/scripts-to-import/scriptFileToImport.ms",	-- ABSOLUTE path
	"\scripts-to-import\this-file-not-exists.ms"	-- TEST NOT EXISTING FILE
)

/*------------------------------------------------------------------------------
	CREATE INSTANCE
--------------------------------------------------------------------------------*/
FileInImporter = FileInImporter_v(getSourceFileName())

/* SET ROOT PATH FOR RELATIVE PATHS IN FILES ARRAY */ 
FileInImporter.root = getFilenamePath(getSourceFileName())

/* ADD FILES TO IMPORT */ 
FileInImporter.files = files



/*------------------------------------------------------------------------------
	CREATE IMPORT STD SCRIPTS FILE
--------------------------------------------------------------------------------*/
FileInImporter.createStartUpFile()


/*------------------------------------------------------------------------------
	DELETE FILE
--------------------------------------------------------------------------------*/
--FileInImporter.delete()