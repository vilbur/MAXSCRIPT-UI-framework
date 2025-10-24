clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MacroscriptGenerator.ms" ) -- "./../MacroscriptGenerator.ms"


MacroscriptGenerator = MacroscriptGenerator_v()

ini_file = ( getFilenamePath(getSourceFileName()) + "Test-Data\macroscripts.mcr.ini" ) -- "./macroscripts.ini"

MacroscriptGenerator.convertIniToMcr( ini_file )



--(MacroscriptGenerator_v(ini_file)).convertIniToMcr()

--/* test code */
--macro_data = MacroData_v()
--macro_data.category = "My Tools"
--macro_data.buttontext = "Execute Tool"
--macro_data.tooltip = "Runs the selected macro"
--macro_data.icon = "MyIcon.bmp"
--
--macro_data.IsVisible = true
--macro_data.IsChecked = false
--macro_data.isEnabled = true
--macro_data.isIndeterminate = false
--
--macro_data.execute = (messageBox "Macro Executed")
--macro_data.altExecute = (messageBox "Alternate Execution")
