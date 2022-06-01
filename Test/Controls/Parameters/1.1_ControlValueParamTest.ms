clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

/* DIALOG */ 
Dialog 	    = Dialog_v title:"Test"  ini:(getSourceFileName())

_Controls   = Dialog.Controls group:"Main Controls"


/* SETUP */ 
--Dialog.Ini.delete() -- delte ini file for next run of test

items = for i = 1 to 3 collect ("item "+ i as string )


/** CREATE CONTROLS and set ini value
  *	
  *	There are 2 ways how to set value
  *		1) via value:   - shared for all control types
  *		2) via params:  - name of parameter is depending on control type
  *	
  */
_Controls.control #checkbox "Checkbox value" value:true
_Controls.control #checkbox "Checkbox param" params:#(#checked, true)

_Controls.control #listbox "Listbox"	items:items value:2
_Controls.control #MultiListbox "MultiListbox"	items:items params:#(#selection, 3)
--
_Controls.control #dropdownList "dropdownList"	items:items value:2

_Controls.control #radioButtons "RadioButtons value"	items:items value:2
_Controls.control #radioButtons "RadioButtons param"	params:#(#items,items, #default, 3)


/* DIALOG CREATE */ 
Dialog.create()