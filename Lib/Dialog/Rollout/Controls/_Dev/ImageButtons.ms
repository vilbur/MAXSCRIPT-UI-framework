clearListener()

try(destroyDialog buttons_dialog) catch()


/** TEST OF BUTTONS ICON PARAMETERS
 * 
 * https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-63E016F3-250E-4C93-B213-2C1AB51710F7#GUID-63E016F3-250E-4C93-B213-2C1AB51710F7__GUID-CDC32876-5EE0-4BE0-8A5E-CEFFFBFFB841
 * 
 */


icon_path = "c:/GoogleDrive/Programs/CG/3DsMax/scripts/MAXSCRIPT-UI-framework/Lib/Dialog/Rollout/Controls/_Dev/icons_sprite.bmp"
--icon_path = (getFilenamePath(getSourceFileName()) + "/icons_sprite.bmp")


icon_setup = #(
	icon_path,	-- icon
	undefined,	-- icon mask
	9,	-- count of icons in sprite
	1,	-- Default image index
	2,	-- On click\checked
	3,	-- Disabled
	4	-- Disabled checked
)


rollout buttons_dialog "Testing Buttons"
(

    button	button_enabled	images:icon_setup across:3
    button	button_disbaled	images:icon_setup enabled:false
    checkbutton	checked_disbaled	images:icon_setup enabled:false checked:true

)
   
CreateDialog buttons_dialog 150 60


