
macroscript macro_left_click_test
category:	"_macrotest"
buttontext:	"Left\Right click"
toolTip:	"Tooltip button pressed"
--icon:	"#(path, index)"
(
	messageBox "\"buttontext\" property is control id\n\nNext occurrence will be added as next event type"
)

macroscript macro_right_click_test
category:	"_macrotest"
buttontext:	"Left\Right click"
toolTip:	"Tooltip button rightclick"
--icon:	"#(path, index)"
(
	messageBox "Right click on button"
)

/** Event type is defined manually in params array 
  *	
  */
macroscript macro_right_click_only_test
category:	"_macrotest"
buttontext:	"Right click"
--toolTip:	"Tooltip button rightclick"
icon:	"event: #rightclick|width:128"
icon:	"event: #rightclick"
(
	messageBox "Right click on button"
)