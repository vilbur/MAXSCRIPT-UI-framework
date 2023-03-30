clearListener()

filein( "$userscripts\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )
import_browse

/**  CONTROL TYPES: https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_E421933F_958E_42FD_80A1_D66F2A2C0A06_htm
  *
  */

/* DIALOG */
Dialog 	    = Dialog_v title:"Test" ini:(getSourceFileName())
--Dialog 	    = Dialog_v title:"Test"

Controls   = Dialog.Controls group:"Main Controls"


--Controls.control #button "Button" id:#button_1

--Controls.control #checkbox "Checkbox"

--Controls.control #Dropdownlist "Dropdownlist"

--Controls.control #Edittext "Edittext"

--Controls.control #browsePath "browsePath"

--Controls.Control #bitmap "_bitmap_test" params:#(#bitmap, "(bitmap 50 50 color:green)" )
--Controls.Control #bitmap "_bitmap_test" params:#(#bitmap, (bitmap 50 50 color:orange) )
--Controls.Control #bitmap "_bitmap_test" value: (bitmap 50 50 color:blue)


Controls.control #ColorPicker "ColorPicker A" value: [ 64, 128, 0 ]	across:1
Controls.control #ColorPicker "ColorPicker B"  params:#(#color, ( color 255 0 128 ))	across:1
Controls.control #ColorPicker "ColorPicker C"  params:#(#color, [0,128,0 ] )	across:1



/* IMPORTANT: IF PICKER IS NOT DISPLAYED
 *
 * If picker is wider then its allocated space, then only label is shown
 *
 * SOLUTION: Set lower across parameter or wider rollout
 *
*/
Controls.control #ColorPicker "THERE IS NOT PICKER SHOWN" value: [ 64, 128, 0 ] across:4



/* DIALOG CREATE */
--Dialog.create()
Dialog.create   width:256
--Dialog.create   width:1024
