clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../../../ContentLoader.ms" )

current_dir	= getFilenamePath(getSourceFileName())

ContentLoader	= ContentLoader_v path:(current_dir+"/Test-files")

ContentLoader.create()


