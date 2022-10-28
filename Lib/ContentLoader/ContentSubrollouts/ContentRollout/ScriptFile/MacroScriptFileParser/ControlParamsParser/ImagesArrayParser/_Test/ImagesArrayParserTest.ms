clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ImagesArrayParser.ms" )

icon_path = ( getFilenamePath(getSourceFileName()) + "/icon_test.bmp" )

ImagesArrayParser 	= ImagesArrayParser_v()

full_path = ImagesArrayParser.getIconPath #(icon_path)

format "full_path	= % \n" full_path
