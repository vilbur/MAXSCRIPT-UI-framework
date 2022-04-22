clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../ImagesArrayParser.ms" )


ImagesArrayParser 	= ImagesArrayParser_v()

full_path = ImagesArrayParser.getIconPath #("$userScripts/icons_sprite.bmp")

format "full_path	= % \n" full_path
