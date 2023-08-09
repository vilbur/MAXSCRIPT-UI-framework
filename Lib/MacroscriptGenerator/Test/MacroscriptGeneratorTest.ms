clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MacroscriptGenerator.ms" ) -- "./../MacroscriptGenerator.ms"



ini_file = ( getFilenamePath(getSourceFileName()) + "\\macroscripts.ini" ) -- "./macroscripts.ini"
	MacroscriptGenerator_v(ini_file)
