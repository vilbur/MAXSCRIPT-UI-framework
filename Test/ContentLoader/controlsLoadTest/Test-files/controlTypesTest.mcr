
/*------------------------------------------------------------------------------
	BUTTON
----------------------------------------------------------------------*/
macroscript MacroFileTest_A
	category:	"MacroFileTest"
	buttontext:	"MacroFileTest A"
	toolTip:	"Tooltip with Colon:\nand new line"
	--icon:	"#(path, index)"
(
	print "Button MacroFileTest A #pressed"
	--format "EventFired	= % \n" EventFired
)


/*------------------------------------------------------------------------------
  CHECKBOX
------------------------------------------------------------------------------*/	


/*  
*/ 
macroscript macroFileTest_checkbox
	category:	"MacroFileTest"
	buttontext:	"Checkbox Test"
	toolTip:	"Changed event tooltip"
	icon:	"control:#checkbox|checked:true|border:false"
(
	print "checkbox #changed"
	format "EventFired	= % \n" EventFired
)
--
--/*
--*/
--macroscript macroFileTest_checkbox_right
--	category:	"MacroFileTest"
--	buttontext:	"Checkbox HERE IS BUG"
--	toolTip:	"Right click tooltip"
--	icon:	"control:#checkbox" 
--
--(
--	print "checkbox #rightclick"
--	format "EventFired	= % \n" EventFired
--)
--


/*------------------------------------------------------------------------------
  SPINNER
--------------------------------------------------------------------------*/	

/*  
*/ 
macroscript macroFileTest_spinner
	category:	"MacroFileTest"
	buttontext:	"Spinner Test"
	toolTip:	"Spinner tooltip"
	icon:	"control:spinner"
(
	print "Spinner test"
	format " EventFired = % \n"  EventFired
)

/*------------------------------------------------------------------------------
  EDITTEXT
----------------------------------------------------------------------------*/	

/*  
*/ 
macroscript macroFileTest_edittext
	category:	"MacroFileTest"
	buttontext:	"EditText"
	toolTip:	"EditText tooltip"
	icon:	"control:EditText|width:256"
	icon:	"control:EditText"
(
	print "BrowsePath test"
	format " EventFired = % \n"  EventFired
)


/*------------------------------------------------------------------------------
  BROWSE PATH
----------------------------------------------------------------------------*/	

/*  
*/ 
macroscript macroFileTest_browsepath
	category:	"MacroFileTest"
	buttontext:	"BrowsePath"
	toolTip:	"BrowsePath tooltip"
	icon:	"control:BrowsePath|width:256 "
	icon:	"control:BrowsePath"
(
	print "BrowsePath test"
	format "EventFired	= % \n" EventFired
	format " EventFired.value = % \n"  EventFired.value
)


/*------------------------------------------------------------------------------
  CHECKBUTTON
------------------------------------------------------------------------------*/	

/*  
*/ 
macroscript macroFileTest_checkbutton
	category:	"MacroFileTest"
	buttontext:	"Checkbutton"
	toolTip:	"Checkbutton tooltip"
	icon:	"control:checkbutton"
	icon:	"control:checkbutton|highlightColor:(color 50 150 30)"
(
	print "Checkbutton #test"
	format "EventFired = % \n" EventFired
)



/*------------------------------------------------------------------------------
  LISTBOX
------------------------------------------------------------------------------*/	

/* On item selected
*/ 
macroscript macroFileTest_Listbox
	category:	"MacroFileTest"
	buttontext:	"Listbox test"
	toolTip:	"Listbox on selected"
	icon:	"control:Listbox|items:#( 'item 1', 'item 2', '3' )|selection:2"
(
	print "Item selected"
	format "EventFired	= % \n" EventFired
)


/* On item doubleclick
*/ 
macroscript macroFileTest_Listbox_rightclick
	category:	"MacroFileTest"
	buttontext:	"Listbox test"
	toolTip:	"Listbox on rightclick"
	icon:	"control:Listbox"
(
	print "Item doubleclicked"
	format "EventFired	= % \n" EventFired
)



/*------------------------------------------------------------------------------
  MULTILISTBOX
--------------------------------------------------------------------------------*/	

/* On item selected
*/ 
macroscript macroFileTest_Listbox
	category:	"MacroFileTest"
	buttontext:	"Multilistbox test"
	toolTip:	"Multilistbox on selected"
	icon:	"control:Multilistbox|items:#( 'item 1', 'item 2', '3' )|selection:2"
(
	print "Item selected"
	format "EventFired	= % \n" EventFired
)


/* On item doubleclick
*/ 
macroscript macroFileTest_Listbox_rightclick
	category:	"MacroFileTest"
	buttontext:	"Multilistbox test"
	toolTip:	"Multilistbox on rightclick"
	icon:	"control:Multilistbox"
(
	print "Item doubleclicked"
	format "EventFired	= % \n" EventFired
)
	
/*------------------------------------------------------------------------------
  DROPDOWN
----------------------------------------------------------------------------*/	


/*  
*/ 
macroscript macroFileTest_checkbox
	category:	"MacroFileTest"
	buttontext:	"Drop down test"
	toolTip:	"Changed event tooltip"
	icon:	"control:dropdownlist|items:#( 'item 1', 'item 2', '3' )"
(
	print "checkbox #changed"
	format "EventFired	= % \n" EventFired
)


/*------------------------------------------------------------------------------
	RADIOBUTTONS
------------------------------------------------------------------------------*/

/*
*	
*/	
macroscript	modifiers_activate_modifier
category:	"_Modifiers"  
buttonText:	"Radio test"
tooltip:	"Radiobutton test"
--icon:	"items:#( 1,  2,  3 )"

icon:	"control:RadioButtons|items:#('Edit Poly', 'Unwrap', 'Last Modifier')|unselect:true|default:3|align:#left"
(
	format "EventFired	= % \n" EventFired
	--if( EventFired.val ) then
	--(
	--	--activateFirstEditPoly()
	--	
	--	onModPanelChanged ("activateFirstEditPoly")
	--)
	--else
	--	onModPanelChangedKill ("activateFirstEditPoly")
)

