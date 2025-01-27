--
--/*------------------------------------------------------------------------------
--  LEFT RIGHT CLICK TEST
--------------------------------------------------------------------------------*/	
--
--/*
--*/
--macroscript macroFileTest_cotrol_button
--	category:	"MacroFileTest"
--	buttontext:	"Button Left\Right Click"
--	toolTip:	"Left click tooltip"
--	icon:	"border:false"
--(
--	print "Button #pressed"
--)
--
--/*
--*/
--macroscript macroFileTest_cotrol_button_right
--	category:	"MacroFileTest"
--	buttontext:	"Button Left\Right Click"
--	toolTip:	"Right click tooltip"
--(
--	print "Button #rightclick"
--)
--
--
--/*------------------------------------------------------------------------------
--	BUTTON - SET EVENT DIRECTLY
------------------------------------------------------------------------------*/
--macroscript MacroFileTest_button_Rightclick
--	category:	"MacroFileTest"
--	buttontext:	"Only Rightclick"
--	toolTip:	"Tooltip with\nnew line"
--	icon:	"event:#rightClick"
--(
--	print "Button Rightclick #rightclick"
--)



/*------------------------------------------------------------------------------
  CHECKBOX
------------------------------------------------------------------------------*/	


/*  
*/ 
macroscript macroFileTest_checkbox
	category:	"MacroFileTest"
	buttontext:	"Checkbox"
	toolTip:	"Changed event tooltip"
	icon:	"control:checkbox|checked:true|border:false|columns:12"
(
	print "checkbox #changed"
	format "EventFired	= % \n" EventFired
)

/*
*/
macroscript macroFileTest_checkbox_right
	category:	"MacroFileTest"
	buttontext:	"Checkbox"
	toolTip:	"Right click tooltip"
	icon:	"control:#checkbox" 

(
	print "checkbox #rightclick"
	format "EventFired	= % \n" EventFired
)
