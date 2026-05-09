clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" )	-- "./../../../Lib/Dialog/Dialog.ms"

/* DIALOG */
Dialog 	    = Dialog_v title:"Test" width:512

_Controls	= Dialog.Controls group:"Main Controls"  DEBUG:true 


/* SETUP */

items = for i = 1 to 3 collect ("item "+ i as string )

--_Controls.Default #across 1

/*------ BUTTON ------*/
--_Controls.control #button "Button" params:#(#border, false, #tooltip, "Test Tooltip")
--_Controls.control #button "Button offset" params:#( #offset, [ 32, 128] )


/*------ CECKBUTTON ------*/
--_Controls.control #CHECKBUTTON "Orange" highlightColor:orange
--_Controls.control #CHECKBUTTON "Green" color:green


/*------ CHECKBOX ------*/
--_Controls.control #checkbox "Checkbox value" value:true
--_Controls.control #checkbox "Checkbox param" checked:true 

/*------ SPINNER ------*/

--_Spinner = _Controls.control #SPINNER "Spinner params" range:[0,10.0,3]
--_Spinner = _Controls.control #SPINNER "Spinner params" value:10.0
--_Spinner = _Controls.control #SPINNER "Spinner params" range:[0,10,0] value:3 -- value ovverides value in range


/*------ EDITTEXT ------

	EditText is aligned to right by default if across:1


*/

_Controls.control #EDITTEXT "Edit Text" fieldWidth:128
_Controls.control #EDITTEXT "Label On Top" labelOnTop:true
_Controls.control #EDITTEXT "[hidden label]" value:"Hidden Label"
_Controls.control #EDITTEXT "Only Across" across:3
_Controls.control #EDITTEXT "Width Param" width:320
_Controls.control #EDITTEXT "Field Width" fieldWidth:64
_Controls.control #EDITTEXT "Field Width LONG LABEL" fieldWidth:64
_Controls.control #EDITTEXT "ONLY WIDTH is KING if mulitple prams" width:232 fieldWidth:16 across:1




/*------ LISTBOX ------*/
--_Listbox	= _Controls.control #listbox "Listbox param" items:items value:2
--
/*------ SLIDER ------*/
--_Controls.control #slider "slider"  params:#(#type, #integer, #range,[0,10,5], #across, 1)
--_Controls.control #slider "Slider" range:[0,10,5] width:200 params:#(#type, #integer, #ticks, 20 )



/*------ RADIOBUTTONS ------*/
--_Controls.control #radioButtons "RadioButtons"	items:items columns:2
--_Controls.control #radioButtons "RadioButtons"	items:items params:#(#columns, 1)


/*------ BROWSEATH ------*/
/* Browse path parameters: "https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-D4B43A33-8342-4BC9-80AB-91460861D37C"

	#mode,	-- #getOpenFileName|#getSaveFileName|#getSavePath is default
	#caption	
	#initialDir	-- works only in getSavePath mode E.G.:  "maxFilePath|(getDir #maxroot)|..."
	#types	-- "*.txt|All|*.*"
	#filename
	#historyCategory

*/
--_Controls.control #browsePath "getSavePath" -- browse for directory is default
--
--_Controls.control #browsePath "Brwose in users dir"	params:#( #initialDir, "C:\\Users" )
--_Controls.control #browsePath "Brwose scene path"	params:#( #initialDir, "maxFilePath" )
--_Controls.control #browsePath "Brwose max root"	params:#( #initialDir, "(getDir #maxroot)" )

--_Controls.control #browsePath "get Open File Name" params:#( #mode, #getOpenFileName )



/*------ EDITTEXT ------*/
/*------ COLORPICKER ------*/


/* DIALOG CREATE */
Dialog.create()
































