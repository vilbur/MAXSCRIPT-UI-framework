clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/ContentLoader/ContentLoader.ms" ) -- "./../../../Lib/ContentLoader/ContentLoader.ms"
filein( getFilenamePath(getSourceFileName()) + "/../../Lib/StdScriptImporter/StdScriptImporter.ms" )	--"./../../Lib/StdScriptImporter/StdScriptImporter.ms"

--DEBUG = false
DEBUG = true

--try( destroyDialog Groupbox_test )catch()
--
--current_dir	= getFilenamePath(getSourceFileName())
--
--
--/* LOAD CONTENT FROM FOLDERS */
--ContentLoader	= ContentLoader_v path:(current_dir+"/Test-files") ini:( getSourceFileName()) DEBUG:DEBUG
----ContentLoader	= ContentLoader_v path:(current_dir+"/Groupbox-Test")
--
--
--/* CREATE UI */
--ContentLoader.create width:512


/*------------------------------------------------------------------------------
	IMPORT STD SCRIPTS
--------------------------------------------------------------------------------*/



/*------------------------------------------------------------------------------
	LOAD CONTENT FROM FILES
--------------------------------------------------------------------------------*/


/*------------------------------------------------------------------------------
	CREATE DIALOG
--------------------------------------------------------------------------------*/
