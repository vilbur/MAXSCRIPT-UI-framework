
/*------------------------------------------------------------------------------
	BUTTON
--------------------------------------------------------------------------*/
macroscript MacroFileTest_A
	category:	"MacroFileTest"
	buttontext:	"MacroFileTest A"
	toolTip:	"Tooltip with Colon:\nand new line"
	icon:	"#(path, index)"
(
	print "Button MacroFileTest A #pressed"

)


--/*------------------------------------------------------------------------------
--  CHECKBOX
----------------------------------------------------------------------------------*/	
--
--
--/*  
--*/ 
--macroscript macroFileTest_checkbox
--	category:	"MacroFileTest"
--	buttontext:	"Checkbox HERE IS BUG"
--	toolTip:	"Changed event tooltip"
--	icon:	"type:checkbox|checked:true|border:false|columns:12"
--(
--	print "checkbox #changed"
--)
--
--/*
--*/
--macroscript macroFileTest_checkbox_right
--	category:	"MacroFileTest"
--	buttontext:	"Checkbox HERE IS BUG"
--	toolTip:	"Right click tooltip"
--	icon:	"type:checkbox" 
--
--(
--	print "checkbox #rightclick"
--)
--	
--/*------------------------------------------------------------------------------
--  EditText
--------------------------------------------------------------------------------*/	

--/*  
--*/ 
--macroscript macroFileTest_edittext
--	category:	"MacroFileTest"
--	buttontext:	"EditText"
--	toolTip:	"EditText tooltip"
--	--icon:	"type:EditText|width:256"
--	icon:	"type:EditText"
--(
--	print "BrowsePath test"
--	format " EventFired.value = % \n"  EventFired.value
--)


--/*------------------------------------------------------------------------------
--  BROWSE PATH
--------------------------------------------------------------------------------*/	
--
--/*  
--*/ 
--macroscript macroFileTest_browsepath
--	category:	"MacroFileTest"
--	buttontext:	"BrowsePath"
--	toolTip:	"BrowsePath tooltip"
--	--icon:	"type:BrowsePath|width:256 "
--	icon:	"type:BrowsePath"
--(
--	print "BrowsePath test"
--	format " EventFired.value = % \n"  EventFired.value
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
--	toolTip:	"Checkbutton tooltip"
--	icon:	"type:checkbutton|highlightColor:(color 50 150 30)"
--(
--	print "Checkbutton #test"
--	format "EventFired = % \n" EventFired.type
--)
--
--
--
--/*------------------------------------------------------------------------------
--  LISTBOX
----------------------------------------------------------------------------------*/	
--
--/* On item selected
--*/ 
--macroscript macroFileTest_Listbox
--	category:	"MacroFileTest"
--	buttontext:	"Listbox test"
--	toolTip:	"Listbox on selected"
--	icon:	"type:Listbox|items:#( 'item 1', 'item 2', '3' )|selection:2"
--(
--	format "EventFired	= % \n" EventFired
--	print "Item selected"
--)
--
--
--/* On item doubleclick
--*/ 
--macroscript macroFileTest_Listbox_rightclick
--	category:	"MacroFileTest"
--	buttontext:	"Listbox test"
--	toolTip:	"Listbox on rightclick"
--	icon:	"type:Listbox"
--(
--	format "EventFired	= % \n" EventFired
--	print "Item doubleclicked"
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
--	toolTip:	"Multilistbox on selected"
--	icon:	"type:Multilistbox|items:#( 'item 1', 'item 2', '3' )|selection:2"
--(
--	format "EventFired	= % \n" EventFired
--	print "Item selected"
--)
--
--
--/* On item doubleclick
--*/ 
--macroscript macroFileTest_Listbox_rightclick
--	category:	"MacroFileTest"
--	buttontext:	"Multilistbox test"
--	toolTip:	"Multilistbox on rightclick"
--	icon:	"type:Multilistbox"
--(
--	format "EventFired	= % \n" EventFired
--	print "Item doubleclicked"
--)
--
