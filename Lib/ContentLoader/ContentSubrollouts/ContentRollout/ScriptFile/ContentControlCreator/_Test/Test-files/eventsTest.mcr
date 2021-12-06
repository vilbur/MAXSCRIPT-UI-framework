/*------------------------------------------------------------------------------
  LEFT RIGHT CLICK TEST
--------------------------------------------------------------------------------*/	

/*
*/
macroscript macroFileTest_cotrol_button
	category:	"MacroFileTest"
	buttontext:	"Button Left\Right Click"
	toolTip:	"Left click tooltip"
	icon:	"border:false"
(
	print "Button #pressed"
)

/*
*/
macroscript macroFileTest_cotrol_button_right
	category:	"MacroFileTest"
	buttontext:	"Button Left\Right Click"
	toolTip:	"Right click tooltip"
(
	print "Button #rightclick"
)

/*------------------------------------------------------------------------------
	BUTTON - SET EVENT DIRECTLY
----------------------------------------------------------------------------*/
macroscript MacroFileTest_button_Rightclick
	category:	"MacroFileTest"
	buttontext:	"Rightclick test"
	toolTip:	"Tooltip with Colon:\nand new line"
	icon:	"event:rightClick"
(
	print "Button Rightclick #rightclick"

)

