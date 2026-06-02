clearListener(); print("Cleared in: "+getSourceFileName())

/**
 * menu.ms
 * * Defines the menu_v struct for 3ds Max 2025+
 * * Uses the new CuiMenuMgr and #cuiRegisterMenus callback system.
 */

struct menu_v
(
    menuId = "CustomMenu_ID",
    menuTitle = "Custom Menu",
    
    -- Array to hold our queued actions before the callback fires
    actions = #(),
    
    -- 1. Initialize the struct
    fn create id title =
    (
        menuId = id
        menuTitle = title
        actions = #()
    ),

    -- 2. Queue an action item
    fn addAction actionName actionCategory actionId:unsupplied =
    (
        -- The 2025 API requires GUIDs. If you don't supply one, we generate a fresh .NET GUID.
        if actionId == unsupplied do 
            actionId = ((dotnetclass "System.Guid").NewGuid()).ToString()
            
        append actions #(actionName, actionCategory, actionId, #action)
    ),

    -- 3. Queue a separator
    fn addSeparator sepId:unsupplied =
    (
        if sepId == unsupplied do 
            sepId = (( dotNetClass "System.Guid").NewGuid()).ToString()
            
        append actions #("", "", sepId, #separator)
    ),

    -- 4. Register the menu to the 2025 Callback System
	
	
    fn build =
    (
        -- We construct the callback as a string so it evaluates within the exact 
        -- scope 3ds Max expects when it broadcasts #cuiRegisterMenus.
        local cbString = ""
        cbString += "try(\n"
        cbString += "  local menuMgr = callbacks.notificationParam()\n"
        cbString += "  if menuMgr != undefined do (\n"
        cbString += "    local mainMenuBar = menuMgr.mainMenuBar\n"
        cbString += "    local myMenu = mainMenuBar.CreateSubMenu \"" + menuId + "\" \"" + menuTitle + "\"\n"
        
        for item in actions do
        (
            if item[4] == #action then
            (
                -- MacroScript Action Table ID is statically 647394 in 3ds Max
                -- The persistentId must be formatted as "MacroName`MacroCategory"
                local persistentId = item[1] + "`" + item[2]
                cbString += "    myMenu.CreateAction \"" + item[3] + "\" 647394 \"" + persistentId + "\"\n"
            )
            else if item[4] == #separator then
            (
                cbString += "    myMenu.CreateSeparator \"" + item[3] + "\"\n"
            )
        )
        cbString += "  )\n"
        cbString += ")catch()\n"
        
        -- Register the callback string to the system
        local cbID = (menuId as name)
        callbacks.removeScripts id:cbID
        callbacks.addScript #cuiRegisterMenus cbString id:cbID
        
        format "Menu '%' registered. It will appear on next UI reload or Max startup.\n" menuTitle
    )
)


-- 1. Load the script (if it's in an external file)
-- fileIn "menu.ms"

-- 2. Instantiate the struct
myMenuManager = menu_v()

-- 3. Define the internal ID and the UI Label
myMenuManager.create "MyStudioTools_ID" "Studio Tools"

-- 4. Add Action Items (Arguments: "MacroScriptName" "MacroCategory")
myMenuManager.addAction "ExportModel" "StudioTools"
myMenuManager.addSeparator()
myMenuManager.addAction "Settings" "StudioTools"

-- 5. Build and inject into the Main Menu Bar
myMenuManager.build()