clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/ContentLoader/ContentLoader.ms" ) -- "./../../../Lib/ContentLoader/ContentLoader.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Menus/QuadMenuManager/QuadMenuManager.ms" )	--"./../../../Lib/Menus/QuadMenuManager/QuadMenuManager.ms"

--DEBUG = false
DEBUG = true


/* LOAD CONTENT FROM FOLDERS */
ContentLoader	= ContentLoader_v path:( getFilenamePath(getSourceFileName()) + "\\macros-for-menu" ) --ini:( getSourceFileName()) DEBUG:DEBUG


/* CREATE UI */
ContentLoader.create width:512