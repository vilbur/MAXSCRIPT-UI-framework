clearListener()

-- filein( getFilenamePath(getSourceFileName()) + "/../../../UI/Lib/Dialog/Dialog.ms" )
filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

--try( destroyDialog ROLLOUT_test )catch()


/* DIALOG */ 
-- Dialog 	    = Dialog_v title:"Test"  ini:(getSourceFileName())
Dialog 	    = Dialog_v title:"Test"


_Controls	= Dialog.Controls group:"Main Controls"

items = for i = 1 to 3 collect ("item "+ i as string )


_Button	= _Controls.control #button "Button" id:#button_1

_Checkbox	= _Controls.control #checkbox "Checkbox value" value:true
_Checkbox	= _Controls.control #checkbox "Checkbox param" params:#(#checked, true)

_Listbox	= _Controls.control #listbox "Listbox param" items:items value:2


/* DIALOG CREATE */ 
Dialog.create()