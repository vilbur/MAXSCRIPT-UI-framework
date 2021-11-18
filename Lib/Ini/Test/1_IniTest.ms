clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../Ini.ms" )


Ini = Ini_v()

ini_path_to_file = (getFilenamePath(getSourceFileName()) + getFilenameFile(getSourceFileName()) + ".ini")
ini_path_to_this = (getSourceFileName())


/* NOT VALID PATH */ 
Ini.setIni("C:\Not valid path")


/* PATH TO *.ini file */ 
Ini.setIni(ini_path_to_file)
format "ini_path_to_file	= % \n" Ini._path


/* PATH TO *.ms file */ 
Ini.setIni(ini_path_to_this)
format "ini_path_to_this	= % \n" Ini._path


Ini.save #section #key_1 #value

Ini.save "section" "key_2" "parameters as string"

print ( "key_2 = " + Ini.load #section #key_2 )