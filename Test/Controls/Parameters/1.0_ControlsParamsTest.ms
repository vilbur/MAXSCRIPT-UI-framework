clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../../../Lib/Dialog/Dialog.ms" )	-- "./../../../Lib/Dialog/Dialog.ms"

/* DIALOG */

Dialog 	    = Dialog_v title:"Test"

_Controls	= Dialog.Controls group:"Main Controls"


/* SETUP */

items = for i = 1 to 3 collect ("item "+ i as string )


/** CREATE CONTROLS
--  */
--_Button	= _Controls.control #button "Button" params:#(#border, false, #tooltip, "Test Tooltip")
--_Button	= _Controls.control #button "Button offset" params:#( #offset, [ 32, 128] )
--
--_Checkbox	= _Controls.control #checkbox "Checkbox value" value:true
--_Checkbox	= _Controls.control #checkbox "Checkbox param" params:#(#checked, true)
--
--_Listbox	= _Controls.control #listbox "Listbox param" items:items value:2
--
--_Controls.control #slider "slider"  params:#(#type, #integer, #range,[0,10,5], #across, 1)

/*------ RADIOBUTTONS ------*/
--_Controls.control #radioButtons "RadioButtons"	items:items params:#(#columns, 1)

/*------ SLIDER ------*/
_Controls.control #slider "Slider" range:[0,10,5] width:200 params:#(#type, #integer, #ticks, 20 )


/* Browse path parameters: "https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-D4B43A33-8342-4BC9-80AB-91460861D37C"
						--"./../../../Lib/RolloutCreator/ControlsCreator/ControlTypes/BrowsePath/BrowsePath.ms"

	#mode,	-- #getOpenFileName|#getSaveFileName|#getSavePath is default
	#caption
	#initialDir -- works only in getSavePath mode E.G.:  "maxFilePath|(getDir #maxroot)|..."
	#types
	#filename
	#historyCategory

*/
--_Controls.control #browsePath "getSavePath" -- browse for directory is default
--
--_Controls.control #browsePath "Brwose in users dir"	params:#( #initialDir, "C:\\Users" )
--_Controls.control #browsePath "Brwose scene path"	params:#( #initialDir, "maxFilePath" )
--_Controls.control #browsePath "Brwose max root"	params:#( #initialDir, "(getDir #maxroot)" )
--
--_Controls.control #browsePath "OpenFileName" params:#( #mode, #getOpenFileName )



/* DIALOG CREATE */
Dialog.create width:256 height:256