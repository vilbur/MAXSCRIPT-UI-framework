clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/ContentLoader/ContentLoader.ms" ) -- "./../../../Lib/ContentLoader/ContentLoader.ms"


DEBUG = true
DEBUG = false

--try( destroyDialog Groupbox_test )catch()

current_dir	= getFilenamePath(getSourceFileName())


/* LOAD CONTENT FROM FOLDERS */
ContentLoader	= ContentLoader_v path:(current_dir+"/Test-content") --ini:( getSourceFileName()) DEBUG:DEBUG
--ContentLoader	= ContentLoader_v path:(current_dir+"/Groupbox-Test")


/* CREATE UI */
--ContentLoader.create cache:true
ContentLoader.create cache:false



--format "ContentLoader.Dialog.Dialog: %\n" ContentLoader.Dialog.Dialog.TEST_VARIABLE.keys
