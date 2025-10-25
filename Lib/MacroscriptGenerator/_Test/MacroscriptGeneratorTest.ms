clearListener(); print("Cleared in:"+getSourceFileName())

filein( getFilenamePath(getSourceFileName()) + "/../MacroscriptGenerator.ms" ) -- "./../MacroscriptGenerator.ms"


MacroscriptGenerator = MacroscriptGenerator_v()


/*------------------------------------------------------------------------------
	TEST GENERATE .mcr FILE FROM .ini FILE
--------------------------------------------------------------------------------*/
MacroscriptGenerator.convertIniToMcr( getFilenamePath (getSourceFileName()) + "Test-Data\macroscripts.mcr.ini" )



/*------------------------------------------------------------------------------
	TEST GENERATE .mcr FILE
--------------------------------------------------------------------------------*/

/*------ FILL MACROSCRIPT OBJECT ------*/
MacroData = MacroData_v "Test macro 1" "_Test-Category" -- MacroData_v name: category:
MacroData.buttontext = "Button Text"
--MacroData.tooltip = "Runs the selected macro"
--MacroData.icon = "MyIcon.bmp"

MacroData.IsVisible = true
MacroData.IsChecked = "selection.count > 0"
--MacroData.isEnabled = true
--MacroData.isIndeterminate = false
--
MacroData.exe = "messageBox \"Macro Executed\""
MacroData.altExecute = "messageBox \"Alternate Executed\""


/* GENERATE FILE */

mcr_file = MacroscriptGenerator.generateMcrFile ( MacroData )( getFilenamePath(getSourceFileName()) + "Test-Data\generated-file.mcr" ) --file_in:#("C:\foo.mcr", "C:\bar.mcr")

format "MCR_FILE: %\n" mcr_file
