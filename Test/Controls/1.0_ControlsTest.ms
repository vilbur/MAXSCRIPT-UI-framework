clearListener()

-- filein( getFilenamePath(getSourceFileName()) + "/../../../UI/Lib/Dialog/Dialog.ms" )
filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

--try( destroyDialog ROLLOUT_test )catch()


/* DIALOG */ 
-- Dialog 	    = Dialog_v title:"Test"  ini:(getSourceFileName())
Dialog 	    = Dialog_v title:"Test"  ini:(getSourceFileName())


_Controls	= Dialog.Controls group:"Main Controls"

--_Button	= _Controls.control #button "Button" id:#button_1

_Checkbox	= _Controls.control #checkbox "Checkbox value" value:true
_Checkbox	= _Controls.control #checkbox "Checkbox param" params:#(#checked, true)


/* DIALOG CREATE */ 
Dialog.create()