clearListener(); print("Cleared in:\n"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../../include-menus.ms" )	--"./../../include-menus.ms"

QuadMenu 	= QuadMenu_v ( "_Test Quad" )

format "QuadMenu: %\n" QuadMenu
