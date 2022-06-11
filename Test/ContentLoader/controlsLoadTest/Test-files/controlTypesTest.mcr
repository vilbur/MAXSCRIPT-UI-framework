--
--/*------------------------------------------------------------------------------
--	BUTTON
------------------------------------------------------------------------*/
--macroscript MacroFileTest_A
--	category:	"MacroFileTest"
--	buttontext:	"MacroFileTest A"
--	toolTip:	"Tooltip with Colon:\nand new line"
--	--icon:	"#(path, index)"
--(
--	print "Button MacroFileTest A #pressed"
--	--format "EventFired	= % \n" EventFired
--)
--
--
----/*------------------------------------------------------------------------------
----  CHECKBOX
----------------------------------------------------------------------------------*/	
--
--
--/*  
--*/ 
--macroscript macroFileTest_checkbox
--	category:	"MacroFileTest"
--	buttontext:	"Checkbox"
--	toolTip:	"Changed event tooltip"
--	icon:	"type:#checkbox|checked:true|border:false"
--(
--	print "checkbox #changed"
--	format "EventFired	= % \n" EventFired
--)
----
----/*
----*/
----macroscript macroFileTest_checkbox_right
----	category:	"MacroFileTest"
----	buttontext:	"Checkbox HERE IS BUG"
----	toolTip:	"Right click tooltip"
----	icon:	"type:#checkbox" 
----
----(
----	print "checkbox #rightclick"
----	format "EventFired	= % \n" EventFired
----)
--
--/*------------------------------------------------------------------------------
--  EditText
------------------------------------------------------------------------------*/	
--
----/*  
----*/ 
----macroscript macroFileTest_edittext
----	category:	"MacroFileTest"
----	buttontext:	"EditText"
----	toolTip:	"EditText tooltip"
----	icon:	"type:EditText|width:256"
----	icon:	"type:EditText"
----(
----	print "BrowsePath test"
----	format " EventFired = % \n"  EventFired
----)
--
----
----/*------------------------------------------------------------------------------
----  BROWSE PATH
--------------------------------------------------------------------------------*/	
----
----/*  
----*/ 
----macroscript macroFileTest_browsepath
----	category:	"MacroFileTest"
----	buttontext:	"BrowsePath"
----	toolTip:	"BrowsePath tooltip"
----	icon:	"type:BrowsePath|width:256 "
----	icon:	"type:BrowsePath"
----(
----	print "BrowsePath test"
----	format "EventFired	= % \n" EventFired
----	format " EventFired.value = % \n"  EventFired.value
----)
----
----
----/*------------------------------------------------------------------------------
----  CHECKBUTTON
----------------------------------------------------------------------------------*/	
----
----/*  
----*/ 
----macroscript macroFileTest_checkbutton
----	category:	"MacroFileTest"
----	buttontext:	"Checkbutton"
----	toolTip:	"Checkbutton tooltip"
----	icon:	"type:checkbutton"
----	icon:	"type:checkbutton|highlightColor:(color 50 150 30)"
----(
----	print "Checkbutton #test"
----	format "EventFired = % \n" EventFired
----)
----
----
----
----/*------------------------------------------------------------------------------
----  LISTBOX
----------------------------------------------------------------------------------*/	
----
----/* On item selected
----*/ 
----macroscript macroFileTest_Listbox
----	category:	"MacroFileTest"
----	buttontext:	"Listbox test"
----	toolTip:	"Listbox on selected"
----	icon:	"type:Listbox|items:#( 'item 1', 'item 2', '3' )|selection:2"
----(
----	print "Item selected"
----	format "EventFired	= % \n" EventFired
----)
----
----
----/* On item doubleclick
----*/ 
----macroscript macroFileTest_Listbox_rightclick
----	category:	"MacroFileTest"
----	buttontext:	"Listbox test"
----	toolTip:	"Listbox on rightclick"
----	icon:	"type:Listbox"
----(
----	print "Item doubleclicked"
----	format "EventFired	= % \n" EventFired
----)
----
----
----
----/*------------------------------------------------------------------------------
----  MULTILISTBOX
------------------------------------------------------------------------------------*/	
----
----/* On item selected
----*/ 
----macroscript macroFileTest_Listbox
----	category:	"MacroFileTest"
----	buttontext:	"Multilistbox test"
----	toolTip:	"Multilistbox on selected"
----	icon:	"type:Multilistbox|items:#( 'item 1', 'item 2', '3' )|selection:2"
----(
----	print "Item selected"
----	format "EventFired	= % \n" EventFired
----)
----
----
----/* On item doubleclick
----*/ 
----macroscript macroFileTest_Listbox_rightclick
----	category:	"MacroFileTest"
----	buttontext:	"Multilistbox test"
----	toolTip:	"Multilistbox on rightclick"
----	icon:	"type:Multilistbox"
----(
----	print "Item doubleclicked"
----	format "EventFired	= % \n" EventFired
----)
----	
--/*------------------------------------------------------------------------------
--  DROPDOWN
--------------------------------------------------------------------------------*/	
--
--
----/*  
----*/ 
----macroscript macroFileTest_checkbox
----	category:	"MacroFileTest"
----	buttontext:	""
----	toolTip:	"Changed event tooltip"
----	icon:	"type:dropdownlist|items:#( 'item 1', 'item 2', '3' )"
----(
----	print "checkbox #changed"
----	format "EventFired	= % \n" EventFired
----)
----

/*------------------------------------------------------------------------------
	RADIOBUTTONS
--------------------------------------------------------------------------------*/

/*
*	
*/	
macroscript	modifiers_activate_modifier
category:	"_Modifiers"  
buttonText:	"Radio test"
--tooltip:	"Keep active first Edit Poly modifier"
icon:	"type:RadioButtons|items:#('item 1', 'item 2', 'item 3')|unselect:true|default:3|align:#left"
--icon:	"type:RadioButtons|items:#('Edit Poly', 'Unwrap', 'Last Modifier')|unselect:true|align:#left"
--icon:	"type:RadioButtons|items:#('Edit Poly', 'Unwrap', 'Last Modifier')|default:3|align:#left"
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

