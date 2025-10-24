/* 
Struct holds macro related data from given arrays.
*/
struct MacroData_v
(
    /* category and ui params */
    category,
    buttontext,
    tooltip,
    icon,

    /* ui state filters */
    IsVisible,
    IsChecked,
    isEnabled,
    isIndeterminate,

    /* code handlers */
    --execute,
    exe,
    altExecute,

    /* 
    on create initializes all properties as undefined 
    */
    on create do
    (
        --category          = undefined
        --buttontext        = undefined
        --tooltip           = undefined
        --icon              = undefined
        --
        --IsVisible         = undefined
        --IsChecked         = undefined
        --isEnabled         = undefined
        --isIndeterminate   = undefined
        --
        --execute           = undefined
        --altExecute        = undefined
    )
)

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
