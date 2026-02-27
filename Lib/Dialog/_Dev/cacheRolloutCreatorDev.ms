clearListener(); print("Cleared in: "+getSourceFileName())
-- Declare globals for the main rollout and multiple child rollouts
global myMainRollout
global myChild1, myChild2, myChild3

(
    -- Define the path for the saved script definition
    --local defFilePath = (getDir #userscripts) + "\\my_baked_multislot_def.ms"
    local defFilePath = ( getFilenamePath (getSourceFileName()) ) + "\\cacheRolloutCreatorDev-DEF.ms"

    -- Close the dialog if it is already open
    try(destroyDialog myMainRollout) catch()

    if doesFileExist defFilePath then
    (
        -- 1. FILE EXISTS: Evaluate the file. 
        -- This now handles defining the rollouts AND creating/populating the UI automatically.
        fileIn defFilePath
        
        print "Success: Loaded definitions and built UI directly from the MS file."
    )
    else
    ( 
        -- 2. FILE DOES NOT EXIST: Generate everything
        
        -- --- A. Generate Child Rollouts ---
        local rc1 = rolloutCreator "myChild1" "Child 1 (Left)"
        rc1.begin(); rc1.addControl #button #b1 "Left Button A" paramStr:"width:160 height:30"; rc1.end()
        
        local rc2 = rolloutCreator "myChild2" "Child 2 (Left)"
        rc2.begin(); rc2.addControl #button #b2 "Left Button B" paramStr:"width:160 height:30"; rc2.end()
        
        local rc3 = rolloutCreator "myChild3" "Child 3 (Right)"
        rc3.begin(); rc3.addControl #button #b3 "Right Button C" paramStr:"width:160 height:30"; rc3.end()

        -- --- B. Generate Main Rollout ---
        local rciMain = rolloutCreator "myMainRollout" "Baked Multi-Slot UI"
        rciMain.begin()
        rciMain.addControl #subRollout #slotLeft "Left Slot" paramStr:"width:190 height:270 align:#left offset:[0,5] across:2"
        rciMain.addControl #subRollout #slotRight "Right Slot" paramStr:"width:190 height:270 align:#right offset:[0,5]"
        rciMain.end()
        
        -- --- C. Generate the Initialization Sequence ---
        -- This string holds the commands to physically open the dialog and link the subrollouts
        local initSequenceStr = "createDialog myMainRollout width:420 height:300\n"
        initSequenceStr += "AddSubRollout myMainRollout.slotLeft myChild1\n"
        initSequenceStr += "AddSubRollout myMainRollout.slotLeft myChild2\n"
        initSequenceStr += "AddSubRollout myMainRollout.slotRight myChild3\n"
        
        -- --- D. Save everything to the .ms file ---
        local f = createFile defFilePath
        if f != undefined do
        (
            -- Write children, then main, then the initialization sequence at the very end
            format "%\n\n%\n\n%\n\n%\n\n%" rc1.str rc2.str rc3.str rciMain.str initSequenceStr to:f
            close f
        )
        
        -- --- E. Execute the newly created file ---
        -- By running fileIn, we ensure the first run behaves identically to all subsequent runs
        fileIn defFilePath
        
        print "Success: Generated MS file with baked-in creation sequence and executed it."
    )
)