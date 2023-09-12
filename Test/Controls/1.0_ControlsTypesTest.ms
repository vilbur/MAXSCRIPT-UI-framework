clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"

/**  CONTROL TYPES: https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_E421933F_958E_42FD_80A1_D66F2A2C0A06_htm
  *
  */

/* DIALOG */
Dialog 	    = Dialog_v title:"Test" ini:(getSourceFileName())
--Dialog 	    = Dialog_v title:"Test"


/* CONTROLS */
--Controls   = Dialog.Controls group:"Main Controls"
Controls   = Dialog.Controls()

/*------ GROUPBOX ------*/
--Controls.control #Groupbox "Groupbox Test" height:64
--Controls.control #button "Button in Groupbox" params:#(#groupbox, "Groupbox Test")
--
--
--Controls.control #Groupbox "[Groupbox Hidden Label]" height:64
--Controls.control #button "Group Box without Label" params:#(#groupbox, "[Groupbox Hidden Label]") width:128 offset:[-32,0]



/* ADD CONTROL AS OBJECT */
--Controls.add (Control_v #button "THIS IS TEST")


/*------ BUTTON ------*/
--Controls.control #button "Button" id:#button_1
--Controls.control #button "Button ☑✅✓" id:#button_1


/*------ CECKBUTTON ------*/
--Controls.control #checkbutton "checkbutton"


/*------ CHECKBOX ------*/
--Controls.control #checkbox "Checkbox"


/*------ RADIOBUTTONS ------*/
--Controls.control #radioButtons "RadioButtons"	items:#("Item 1","Item 2")


/*------ DROPDOWN ------*/
--Controls.control #Dropdownlist "Dropdownlist"


/*------ EDITTEXT ------*/
Controls.control #Edittext "Edittext"


/*------ SLIDER ------*/
--Controls.control #slider "Slider"



/*------ BROWSEATH ------*/
--Controls.control #browsePath "browsePathTest"

/*------ COLORPICKER ------*/
-- Controls.control #ColorPicker "ColorPicker A" value: [ 64, 128, 0 ]	across:1
-- Controls.control #ColorPicker "ColorPicker B"  params:#(#color, ( color 255 0 128 ))	across:1
-- Controls.control #ColorPicker "ColorPicker C"  params:#(#color, [0,128,0 ] )	across:1

/*------ BITMAP ------*/
--Controls.Control #bitmap "_bitmap_test" params:#(#bitmap, "(bitmap 50 50 color:green)" )
--Controls.Control #bitmap "_bitmap_test" params:#(#bitmap, (bitmap 50 50 color:orange) )
--Controls.Control #bitmap "_bitmap_test" value: (bitmap 50 50 color:blue)




/* IMPORTANT: IF PICKER IS NOT DISPLAYED
 *
 * If picker is wider then its allocated space, then only label is shown
 *
 * SOLUTION: Set lower across parameter or wider rollout
 *
*/
-- Controls.control #ColorPicker "THERE IS NOT PICKER SHOWN" value: [ 64, 128, 0 ] across:4



/* DIALOG CREATE */
--Dialog.create()
Dialog.create   width:320
--Dialog.create   width:1024
