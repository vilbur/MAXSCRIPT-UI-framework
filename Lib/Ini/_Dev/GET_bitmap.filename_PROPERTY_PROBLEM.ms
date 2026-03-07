clearListener(); print("Cleared in:\n"+getSourceFileName())


try(destroyDialog testImgTagRollout)catch()

rollout testImgTagRollout "ImgTag Workaround"
(
    /* 1. Declare a local variable to safely store the bitmap in memory */
    local currentBitmap 
    
    imgTag ui_displayImage width:256 height:256 align:#center
    button btn_checkBitmap "Read Bitmap Value" width:200 height:30 margin:[0,10,0,0]
    
    on testImgTagRollout open do
    (
        /* 2. Create/load the bitmap and assign it to the VARIABLE first */

		currentBitmap = openBitmap ( (getDir #maxSysIcons) + "\\AddPreset_16i.bmp" )
        --currentBitmap = bitmap 256 256 filename:( (getDir #maxSysIcons) + "\\AddPreset_16i.bmp" )

        
        /* 3. Update the UI control using the variable */
        ui_displayImage.bitmap = currentBitmap
    )
    
    on btn_checkBitmap pressed do
    (
        /* 4. When you need to read the value, query the VARIABLE, not the UI control */
        if currentBitmap != undefined then
        (
            local w = currentBitmap.width as string
            local h = currentBitmap.height as string

			format "currentBitmap.filename: %\n" currentBitmap.filename 
        )
        else
        (
            messageBox "The bitmap is undefined!" title:"Error"
        )
        
        /* NOTE: Attempting to read 'ui_displayImage.bitmap' here is what usually fails. */
    )
)

createDialog testImgTagRollout width:300 height:350