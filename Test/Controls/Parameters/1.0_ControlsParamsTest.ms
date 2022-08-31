clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )


/* DIALOG */ 

Dialog 	    = Dialog_v title:"Test"

_Controls	= Dialog.Controls group:"Main Controls"


/* SETUP */ 

items = for i = 1 to 3 collect ("item "+ i as string )


/** CREATE CONTROLS
  */
_Button	= _Controls.control #button "Button" params:#(#border, false, #tooltip, "Test Tooltip")
_Button	= _Controls.control #button "Button offset" params:#( #offset, [ 32, 128] )

_Checkbox	= _Controls.control #checkbox "Checkbox value" value:true
_Checkbox	= _Controls.control #checkbox "Checkbox param" params:#(#checked, true)

_Listbox	= _Controls.control #listbox "Listbox param" items:items value:2

_Controls.control #slider "slider"  params:#(#type, #integer, #range,[0,10,5], #across, 1)


/* DIALOG CREATE */ 
Dialog.create width:256