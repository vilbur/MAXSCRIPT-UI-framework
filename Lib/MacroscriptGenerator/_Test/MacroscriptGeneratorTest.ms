clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MacroscriptGenerator.ms" ) -- "./../MacroscriptGenerator.ms"



ini_file = ( getFilenamePath(getSourceFileName()) + "Test-Data\macroscripts.mcr.ini" ) -- "./macroscripts.ini"
	(MacroscriptGenerator_v(ini_file)).convertIniToMcr()
