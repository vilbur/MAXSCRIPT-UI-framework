/*------------------------------------------------------------------------------
  
  VERTICAL ALIGN IN GROUPBOX
  
----------------------------------------------------------------------------*/	

/* GROUPBOX LEFT COLUMN
*/ 
macroscript macroFileTest_group_box
	category:	"MacroFileTest"
	--buttontext:	"[TEST]"
	buttontext:	"TEST"
	icon:	"type:Groupbox|across:2"
(
	--format "EventFired	= % \n" EventFired
	--print "Item selected" 
)

/* LISTBOX RIGHT COLUMN
*/ 
macroscript MacroFileTest_groupbox_test
	category:	"MacroFileTest"
	buttontext:	"Listbox groupbox"
	icon:	"type:listbox|across:2|height:5"
(
)



/*------------------------------------------------------------------------------
	
	CONTROLS IN GROUPBOX
	
--------------------------------------------------------------------------------*/
	
macroscript MacroFileTest_groupbox_test2
	category:	"MacroFileTest"
	buttontext:	"IN GROUPBOX 3"
	icon:	"Groupbox:TEST|type:dropdownlist|items:#( 'item 1', 'item 2', '3' )|across:4"
(
	format "EventFired	= % \n" EventFired

)

macroscript MacroFileTest_groupbox_test1
	category:	"MacroFileTest"
	buttontext:	"IN GROUPBOX A1"
	icon:	"Groupbox:TEST"
(
	format "EventFired	= % \n" EventFired

)
	
macroscript MacroFileTest_groupbox_test2
	category:	"MacroFileTest"
	buttontext:	"IN GROUPBOX B2"
	icon:	"Groupbox:TEST"
(
	format "EventFired	= % \n" EventFired

)