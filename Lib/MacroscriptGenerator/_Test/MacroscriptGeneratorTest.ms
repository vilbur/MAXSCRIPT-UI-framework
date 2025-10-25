clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MacroscriptGenerator.ms" ) -- "./../MacroscriptGenerator.ms"


MacroscriptGenerator = MacroscriptGenerator_v()


/* GENERATE .mcr FILE FROM .ini FILE */ 
MacroscriptGenerator.convertIniToMcr( getFilenamePath(getSourceFileName()) + "Test-Data\macroscripts.mcr.ini" )




/* test code */
MacroData = MacroData_v "Test macro 1" "_Test-Category" -- MacroData_v name: category:
--MacroData.buttontext = "Execute Tool"
--MacroData.tooltip = "Runs the selected macro"
--MacroData.icon = "MyIcon.bmp"
--
--MacroData.IsVisible = true
--MacroData.IsChecked = false
--MacroData.isEnabled = true
--MacroData.isIndeterminate = false
--
--MacroData.execute = (messageBox "Macro Executed")
--MacroData.altExecute = (messageBox "Alternate Execution")


--MacroscriptGenerator.generateMcrFile ( MacroData )( getFilenamePath(getSourceFileName()) + "Test-Data\generated.mcr" )