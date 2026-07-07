clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../../../MAXSCRIPT-MenuBuilder/include-QuadMenuManager.ms" )	--"./../../../../MAXSCRIPT-MenuBuilder/include-QuadMenuManager.ms"

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/ContentLoader/ContentLoader.ms" ) -- "./../../../Lib/ContentLoader/ContentLoader.ms"


--DEBUG = false
DEBUG = true


/* LOAD CONTENT FROM FOLDERS */
ContentLoader	= ContentLoader_v path:( getFilenamePath(getSourceFileName()) + "\\macros-for-menu" ) --ini:( getSourceFileName()) DEBUG:DEBUG


/* CREATE UI */
ContentLoader.create width:512



MENU_MANAGER_GLOBAL.createMenus()