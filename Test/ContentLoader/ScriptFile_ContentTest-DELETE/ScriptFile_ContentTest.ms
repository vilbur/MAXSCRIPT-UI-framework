
filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/ContentLoader/ContentSubrollouts/ContentRollout/ScriptFile/ScriptFile.ms" ) -- "./../../../Lib/ContentLoader/ContentSubrollouts/ContentRollout/ScriptFile/ScriptFile.ms"

--all_macro_files = getFiles ( getFilenamePath(getSourceFileName()) + "/VilTools/rollouts-Tools/*.mcr" ) recurse:true  -- "./../../slot_properties.ini"

--clearSelection()


macro_path =   ( getFilenamePath(getSourceFileName()) + "\\ScriptFile_ContentTest.mcr" ) -- "./controlSimpleTest.mcr"


file_exists = doesFileExist macro_path

format "file_exists = % \n" file_exists

(ScriptFile_Content_v(macro_path)).importMacroscripts()
