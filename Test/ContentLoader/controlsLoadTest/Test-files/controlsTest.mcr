

/*------------------------------------------------------------------------------
	BUTTON
--------------------------------------------------------------------*/
macroscript macroFileTest_button_leftclick
	category:	"MacroFileTest"
	buttontext:	"Button"
	tooltip:	"Tooltip of leftclick"
	icon:	"Tooltip:Tooltip of control"
(
	print "Button #pressed"
	format "EventFired	= % \n" EventFired
)


macroscript macroFileTest_button_rightclick
	category:	"MacroFileTest"
	buttontext:	"Button"
	tooltip:	"Tooltip of rightclick"
(
	print "Button #rightclick"
	format "EventFired	= % \n" EventFired
)


--/*------------------------------------------------------------------------------
--  CHECKBUTTON
--------------------------------------------------------------------------------*/
--macroscript MacroFileTest_A_custom_id
--	category:	"MacroFileTest"
--	buttontext:	"Checkbutton"
--	--tooltip:	"Tooltip with Colon:\nand new line"
--	icon:	"control:checkbutton"
--(
--	format "EventFired	= % \n" EventFired
--
--	if EventFired.val then
--		print "Checkbutton pressed"
--
--	else
--		print "Checkbutton unpressed"
--)
--
--
--/*------------------------------------------------------------------------------
--  CHECKBOX
--------------------------------------------------------------------------------*/
--
--
--/*
--*/
--macroscript macroFileTest_checkbox
--	category:	"MacroFileTest"
--	buttontext:	"Checkbox Test"
--	tooltip:	"Changed event tooltip"
--	icon:	"control:#checkbox|checked:true|border:false"
--(
--	print "checkbox #changed"
--	format "EventFired	= % \n" EventFired
--)
--
--/*
--*/
--macroscript macroFileTest_checkbox_right
--	category:	"MacroFileTest"
--	buttontext:	"Checkbox HERE IS BUG"
--	tooltip:	"Right click tooltip"
--	icon:	"control:#checkbox"
--
--(
--	print "checkbox #rightclick"
--	format "EventFired	= % \n" EventFired
--)
--
--
--
/*------------------------------------------------------------------------------
  SPINNER
--------------------------------------------------------------------------*/

--/*
--*/
--macroscript macroFileTest_spinner
--	category:	"MacroFileTest"
--	buttontext:	"Spinner Test"
--	tooltip:	"Spinner tooltip"
--	icon:	"control:spinner|range:[ 1, 10, 0.05 ]|scale:0.01"
--(
--	print "Spinner test"
--	format " EventFired = % \n"  EventFired
--)
--
--/*------------------------------------------------------------------------------
--  EDITTEXT
------------------------------------------------------------------------------*/
--
--/*
--*/
--macroscript macroFileTest_edittext
--	category:	"MacroFileTest"
--	buttontext:	"EditText"
--	tooltip:	"EditText tooltip"
--	icon:	"control:EditText|width:256"
--	icon:	"control:EditText"
--(
--	print "BrowsePath test"
--	format " EventFired = % \n"  EventFired
--)
--
--
--/*------------------------------------------------------------------------------
--  BROWSE PATH
----------------------------------------------------------------------------*/
--
--/*
--*/
--macroscript macroFileTest_browsepath
--	category:	"MacroFileTest"
--	buttontext:	"BrowsePath"
--	tooltip:	"BrowsePath tooltip"
--	icon:	"control:BrowsePath|width:256"
--(
--	print "BrowsePath test"
--	format "EventFired	= % \n" EventFired
--	format " EventFired.val = % \n"  EventFired.val
--)
--
--
--/*------------------------------------------------------------------------------
--  CHECKBUTTON
--------------------------------------------------------------------------------*/
--
--/*
--*/
--macroscript macroFileTest_checkbutton
--	category:	"MacroFileTest"
--	buttontext:	"Checkbutton"
--	tooltip:	"Checkbutton tooltip"
--	icon:	"control:checkbutton"
--	icon:	"control:checkbutton|highlightColor:(color 50 150 30)"
--(
--	print "Checkbutton #test"
--	format "EventFired = % \n" EventFired
--)
--
--
--
--/*------------------------------------------------------------------------------
--  LISTBOX
--------------------------------------------------------------------------------*/
--
--/* On item selected
--*/
--macroscript macroFileTest_Listbox
--	category:	"MacroFileTest"
--	buttontext:	"Listbox test"
--	tooltip:	"Listbox on selected"
--	icon:	"control:Listbox|items:#( 'item 1', 'item 2', '3' )|selection:2"
--(
--	print "Item selected"
--	format "EventFired	= % \n" EventFired
--)
--
--
--/* On item doubleclick
--*/
--macroscript macroFileTest_Listbox_rightclick
--	category:	"MacroFileTest"
--	buttontext:	"Listbox test"
--	tooltip:	"Listbox on rightclick"
--	icon:	"control:Listbox"
--(
--	print "Item doubleclicked"
--	format "EventFired	= % \n" EventFired
--)
--
--
--
--/*------------------------------------------------------------------------------
--  MULTILISTBOX
----------------------------------------------------------------------------------*/
--
--/* On item selected
--*/
--macroscript macroFileTest_Listbox
--	category:	"MacroFileTest"
--	buttontext:	"Multilistbox test"
--	tooltip:	"Multilistbox on selected"
--	icon:	"control:Multilistbox|items:#( 'item 1', 'item 2', '3' )|selection:2"
--(
--	print "Item selected"
--	format "EventFired	= % \n" EventFired
--)
--
--
--/* On item doubleclick
--*/
--macroscript macroFileTest_Listbox_rightclick
--	category:	"MacroFileTest"
--	buttontext:	"Multilistbox test"
--	tooltip:	"Multilistbox on rightclick"
--	icon:	"control:Multilistbox"
--(
--	print "Item doubleclicked"
--	format "EventFired	= % \n" EventFired
--)
--
--/*------------------------------------------------------------------------------
--  DROPDOWN
------------------------------------------------------------------------------*/
--
--
--/*
--*/
--macroscript macroFileTest_checkbox
--	category:	"MacroFileTest"
--	buttontext:	"Drop down test"
--	tooltip:	"Changed event tooltip"
--	icon:	"control:dropdownlist|items:#( 'item 1', 'item 2', '3' )"
--(
--	print "checkbox #changed"
--	format "EventFired	= % \n" EventFired
--)
--
--
--/*------------------------------------------------------------------------------
--	RADIOBUTTONS
------------------------------------------------------------------------------*/
--
--/*
--*
--*/
--macroscript	macroFileTest_radiobuttons
--category:	"MacroFileTest"
--buttonText:	"Radio test"
--tooltip:	"Radiobutton test"
--icon:	"control:RadioButtons|items:#('Edit Poly', 'Unwrap', 'Last Modifier')|unselect:true|default:3|align:#left"
--(
--	format "EventFired	= % \n" EventFired
--	if( EventFired.val ) then
--	(
--		--activateFirstEditPoly()
--
--		onModPanelChanged ("activateFirstEditPoly")
--	)
--	else
--		onModPanelChangedKill ("activateFirstEditPoly")
--)
--
--
--/*------------------------------------------------------------------------------
--	SLIDER
----------------------------------------------------------------------*/
--macroscript macroFileTest_slider
--	category:	"MacroFileTest"
--	buttontext:	"Slider"
--	tooltip:	""
--	icon:	"control:#slider|orient:#vertical|across:1"
--
--(
--	print "Button #pressed"
--	format "EventFired	= % \n" EventFired
--)
--
--
--/*------------------------------------------------------------------------------
--	COLORPICKER
----------------------------------------------------------------------------*/
--
--/*
--*
--*/
--macroscript	macroFileTest_colorpicker
--category:	"MacroFileTest"
--buttonText:	"Color test"
--tooltip:	"Colorpicker test"
--icon:	"control:colorpicker|value: [0,128,0 ]"
--(
--	format "EventFired	= % \n" EventFired
--
--)


/*------------------------------------------------------------------------------
	TIMER
--------------------------------------------------------------------------------*/
--/*
--*
--*/
--macroscript	macroFileTest_timer
--category:	"MacroFileTest"
--buttonText:	"Timer Test"
--tooltip:	"Colorpicker test"
--icon:	"control:timer|interval:500|active:true"
--(
--	format "EventFired	= % \n" EventFired
--
--)

