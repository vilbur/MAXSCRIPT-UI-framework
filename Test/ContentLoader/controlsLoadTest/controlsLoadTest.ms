clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/ContentLoader/ContentLoader.ms" )

current_dir	= getFilenamePath(getSourceFileName())


ContentLoader	= ContentLoader_v path:(current_dir+"/Test-files")
--ContentLoader	= ContentLoader_v path:(current_dir+"/Groupbox-Test")

ContentLoader.create width:512 height:512


--QuadMenuCreator = (QuadMenu_v("_Test Quad")).setQuad()
--format "QuadMenuCreator	= % \n" QuadMenuCreator


--QuadMenuCreator.addMenu("_quadMenuTest") 1
--format "Menu	= % \n" Menu
--QuadMenuCreator.setFlat("_quadMenuTest")

--QuadMenuCreator.setRightClick()