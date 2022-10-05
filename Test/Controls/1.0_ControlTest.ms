clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

/* DIALOG */ 
Dialog 	    = Dialog_v title:"Test"  --ini:(getSourceFileName())

_Controls   = Dialog.Controls group:"Main Controls"


--_Controls.control #button "Button" id:#button_1

--_Controls.control #checkbox "Checkbox"

--_Controls.control #Dropdownlist "Dropdownlist"

--_Controls.control #Edittext "Edittext"

--_Controls.control #browsePath "browsePath"

--_Controls.control #ColorPicker "ColorPicker" value: [0,128,0 ]
--_Controls.control #ColorPicker "ColorPicker"  params:#(#color, ( color 255 0 128 ))
--_Controls.control #ColorPicker "ColorPicker"  params:#(#color, [0,128,0 ] )

--/* DIALOG CREATE */ 
Dialog.create()

--rollout change_wirecolor "Object Color Changer"
--(
--  colorpicker theColor "Wireframe color:" color:[0,0,255] modal:false
--  --on theColor changed new_col do selection.wirecolor = new_col
--)
--createDialog change_wirecolor

 