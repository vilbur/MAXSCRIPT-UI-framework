clearListener()

filein( "$userscripts\Library\MAXSCRIPT-UI-framework\Lib\Dialog\Dialog.ms" )

/* DIALOG */ 

Dialog 	    = Dialog_v title:"Test"  ini:(getSourceFileName())

_Controls   = Dialog.Controls group:"Main Controls"


/* SETUP */ 

-- Dialog.Ini.delete() -- delte ini file for next run of test

items = for i = 1 to 3 collect ("item "+ i as string )


/** CREATE CONTROLS and set ini value
  *	
  *	There are 2 ways how to set value
  *		1) via value:   - shared for all control types
  *		2) via params:  - name of parameter is depending on control type
  *	
  */
-- _Controls.control #checkbox "Checkbox value" value:true
-- _Controls.control #checkbox "Checkbox param" params:#(#checked, true)

-- _Controls.control #listbox "Listbox"	items:items value:2
-- _Controls.control #MultiListbox "MultiListbox"	items:items params:#(#selection, 3)

-- _Controls.control #dropdownList "dropdownList"	items:items value:2

 --_Controls.control #radioButtons "RadioButtons value"	items:items value:2
 --_Controls.control #radioButtons "RadioButtons param"	params:#(#items,items, #default, 3)


-- /* Range controls */ 
-- _Controls.control #slider "Slider range in params" params:#(#range,[0,10,5],	#type, #integer)
-- _Controls.control #slider "Slider range and value" params:#(#range,[0,10,0],	#orient, #vertical) value:3.5
-- _Controls.control #slider "Slider value" value:7.5

-- _Controls.control #spinner "Spinner params" rparams:#(#type, #integer, #range,[0,10,3])
-- _Controls.control #spinner "Spinner value" value:7.5

-- _Controls.control #Angle "Angle value" value:7.5
-- _Controls.control #Angle "Angle params" params:#(#range,[0,180,45])

-- _Controls.control #Hyperlink "Hyperlink" value:"http://luborcerny.com/"





/* DIALOG CREATE */ 
Dialog.create()