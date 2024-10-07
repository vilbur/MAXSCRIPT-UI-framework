clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../Lib/Dialog/Dialog.ms" )	-- "./../../Lib/Dialog/Dialog.ms"

/**  CONTROL TYPES: https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_E421933F_958E_42FD_80A1_D66F2A2C0A06_htm
  *
  */

/* DIALOG */
--Dialog 	    = Dialog_v title:"Test" ini:(getSourceFileName())
Dialog 	    = Dialog_v title:"Test"	--WITHOUT INI FILE


/* CONTROLS */
--_Controls   = Dialog.Controls group:"Main _Controls"
_Controls   = Dialog.Controls()

/*------ GROUPBOX ------*/
_Controls.control #Groupbox "Groupbox Test" height:64
_Controls.control #button "Button in Groupbox" params:#(#groupbox, "Groupbox Test")


_Controls.control #Groupbox "[Groupbox Hidden Label]" height:64
_Controls.control #button "Group Box without Label" params:#(#groupbox, "[Groupbox Hidden Label]") width:128 offset:[-32,0]



/* ADD CONTROL AS OBJECT */
_Controls.add (Control_v #button "By struct")


/*------ BUTTON ------*/
_Controls.control #BUTTON "Button" id:#button_1
_Controls.control #BUTTON "Button ☑✅✓" id:#button_2


/*------ CECKBUTTON ------*/
_Controls.control #CHECKBUTTON "checkbutton"


/*------ CHECKBOX ------*/
_Controls.control #CHECKBOX "Checkbox"


/*------ RADIOBUTTONS ------*/
_Controls.control #radioButtons "RadioButtons" items:#("Item 1","Item 2") columns:2
--_Controls.control #RADIOBUTTONS "RadioButtons 2" items:#("Item 1","Item 2") params:#( #UNSELECT, true ) default:2


/*------ DROPDOWN ------*/
_Controls.control #DROPDOWNLIST "Dropdownlist"


/*------ EDITTEXT ------*/
_Controls.control #EDITTEXT "Edittext"


/*------ SLIDER ------*/
_Slider = _Controls.control #SLIDER "Slider" ticks:3 width:256 range:[0,50,0] ticks:5 type:#integer

/*------ SPINNER ------*/
_Controls.control #SPINNER "Spinner"
--_Controls.control #SPINNER "Spinner 2" width:96 scale:0.01 range:[0,100,0.01]


/*------ LISTBOX ------*/
/*------ MULTILISTBOX ------*/
_multilistbox =  _Controls.control #MULTILISTBOX "Multilistbox" items:#("Item 1","Item 2", "It/*e*/m 3")


/*------ BROWSEATH ------*/
_Controls.control #BROWSEPATH "browsePathTest"


/*------ COLORPICKER ------*/
_Controls.control #COLORPICKER "ColorPicker A" value: [ 64, 128, 0 ]	across:1
_Controls.control #COLORPICKER "ColorPicker B"  params:#(#color, ( color 255 0 128 ))	across:1
_Controls.control #COLORPICKER "ColorPicker C"  params:#(#color, [0,128,0 ] )	across:1

--/*------ BITMAP ------*/
--_Controls.Control #BITMAP "_bitmap_test" params:#(#bitmap, "(bitmap 50 50 color:green)" )
--_Controls.Control #BITMAP "_bitmap_test" params:#(#bitmap, (bitmap 50 50 color:orange) )
--_Controls.Control #BITMAP "_bitmap_test" value: (bitmap 50 50 color:blue)
--



/* IMPORTANT: IF PICKER IS NOT DISPLAYED
 *
 * If picker is wider then its allocated space, then only label is shown
 *
 * SOLUTION: Set lower across parameter or wider rollout
 *
*/
-- _Controls.control #ColorPicker "THERE IS NOT PICKER SHOWN" value: [ 64, 128, 0 ] across:4



/* DIALOG CREATE */
--Dialog.create()
Dialog.create   width:320
--Dialog.create   width:1024
