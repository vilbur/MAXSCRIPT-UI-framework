

/*------------------------------------------------------------------------------
	
	GROUPBOX created by control itself
	
------------------------------------------------------------------------------*/
/* GROUPBOX LEFT COLUMN
*/ 
macroscript macroFileTest_group_box_control_1
	category:	"MacroFileTest"
	buttontext:	"First Control"
	icon:	"type:Groupbox|id:test_groupbox_x|across:2|height:32|tooltip:Selfmade Groupbox"
	icon:	"Groupbox:Defined by control|across:2|height:32|tooltip:Selfmade Groupbox"
	icon:	"Groupbox:Defined by control|across:2"
	icon:	"Groupbox:Defined by control"
(
)
	

macroscript MacroFileTest_groupbox_test1
	category:	"MacroFileTest"
	--buttontext:	"This control \nCREATED\nthis groupbox"
	buttontext:	"Thisgroupbox"
	icon:	"Groupbox:Selfmade Groupbox|across:2|width:128|height:48"
(
)
	
macroscript macroFileTest_group_box_control_2
	category:	"MacroFileTest"
	buttontext:	"Second Control"
	--icon:	"Groupbox:Defined by control|width:128"
	icon:	"Groupbox:Defined by control"
(
)


/*------------------------------------------------------------------------------
	
	GROUPBOX defined as control
	
------------------------------------------------------------------------------*/

/* GROUPBOX RIGHT COLUMN
*/ 
macroscript macroFileTest_group_box
	category:	"MacroFileTest"
	buttontext:	"This is groupbox"
	--tooltip:	"This groupbox define height of previous"
	icon:	"control:Groupbox|id:test_groupbox_x|across:2|height:32"
(
)
	
/* button 2 */ 
macroscript MacroFileTest_groupbox_test2
	category:	"MacroFileTest"
	buttontext:	"Groupbox member"
	icon:	"Groupbox:test_groupbox_x"
(
)

macroscript MacroFileTest_groupbox_test2
	category:	"MacroFileTest"
	buttontext:	"IN GROUPBOX 3"
	icon:	"Groupbox:TEST|type:dropdownlist|items:#( 'item 1', 'item 2', '3' )|across:4"
(
	format "EventFired	= % \n" EventFired

)


/*------------------------------------------------------------------------------
  
  VERTICAL ALIGN IN GROUPBOX
  
--------------------------------------------------------------------------*/	


/* LISTBOX RIGHT COLUMN
*/ 
macroscript MacroFileTest_groupbox_test
	category:	"MacroFileTest"
	buttontext:	"Listbox groupbox"
	icon:	"type:listbox|across:2|height:5"
(
)



