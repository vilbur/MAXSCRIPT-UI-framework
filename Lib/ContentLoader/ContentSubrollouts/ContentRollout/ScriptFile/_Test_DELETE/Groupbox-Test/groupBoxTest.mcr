

/*------------------------------------------------------------------------------
	
	GROUPBOX created by control itself
	
--------------------------------------------------------------------------------*/
/* GROUPBOX LEFT COLUMN
*/ 
macroscript macroFileTest_group_box
	category:	"MacroFileTest"
	buttontext:	"Selfmade Groupbox"
	icon:	"type:Groupbox|id:test_groupbox_x|across:2|height:32"
(
)
	
--
--macroscript MacroFileTest_groupbox_test1
--	category:	"MacroFileTest"
--	--buttontext:	"This control \nCREATED\nthis groupbox"
--	buttontext:	"Thisgroupbox"
--	icon:	"Groupbox:Selfmade Groupbox|across:2|width:128|height:48"
--(
--)
	
macroscript MacroFileTest_groupbox_test2
	category:	"MacroFileTest"
	buttontext:	"Next control"
	icon:	"Groupbox:Selfmade Groupbox|width:128"
(
)	
	

/*------------------------------------------------------------------------------
	
	GROUPBOX defined as control
	
--------------------------------------------------------------------------------*/

/* GROUPBOX LEFT COLUMN
*/ 
macroscript macroFileTest_group_box
	category:	"MacroFileTest"
	buttontext:	"This groupbox define height of previous"
	icon:	"type:Groupbox|id:test_groupbox_x|across:2|height:32"
(
)
	
	
--	
--/* button 2 */ 
--macroscript MacroFileTest_groupbox_test2
--	category:	"MacroFileTest"
--	buttontext:	"Groupbox member"
--	icon:	"Groupbox:test_groupbox_x"
--(
--)

--macroscript MacroFileTest_groupbox_test2
--	category:	"MacroFileTest"
--	buttontext:	"IN GROUPBOX 3"
--	icon:	"Groupbox:TEST|type:dropdownlist|items:#( 'item 1', 'item 2', '3' )|across:4"
--(
--	format "EventFired	= % \n" EventFired
--
--)
/*------------------------------------------------------------------------------
  
  VERTICAL ALIGN IN GROUPBOX
  
----------------------------------------------------------------------------*/	


--/* LISTBOX RIGHT COLUMN
--*/ 
--macroscript MacroFileTest_groupbox_test
--	category:	"MacroFileTest"
--	buttontext:	"Listbox groupbox"
--	icon:	"type:listbox|across:2|height:5"
--(
--)



