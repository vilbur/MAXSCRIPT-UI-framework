clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/ContentLoader/ContentLoader.ms" ) -- "./../../../Lib/ContentLoader/ContentLoader.ms"

try( destroyDialog Groupbox_test )catch()

current_dir	= getFilenamePath(getSourceFileName())


/* LOAD CONTENT FROM FOLDERS */
ContentLoader	= ContentLoader_v path:(current_dir+"/Test-files")   ini:( getSourceFileName())
--ContentLoader	= ContentLoader_v path:(current_dir+"/Groupbox-Test")


/* CREATE UI */
ContentLoader.create width:512