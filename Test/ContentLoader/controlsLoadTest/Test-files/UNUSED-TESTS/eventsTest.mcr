
/*------------------------------------------------------------------------------
	AUTORUN EVENT

	Macros of controls with CHECKED parameter can be executed on Dialog is created

	Control must be in checked state to run event

	PARAMETER AUTORUN MSUT BE USED:
		"autorun:true"

--------------------------------------------------------------------------------*/

macroscript macroFileTest_autorun_event
	category:	"MacroFileTest"
	buttontext:	"Autorun Event"
	toolTip:	"This event is fired when ui is created"
	icon:	"control:checkbutton|autorun:true|#checked:true"
(
	print "\n\n--------- AUTOEXECUTED EVENT ---------\n\n"
)

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
--
--macroscript MacroFileTest_button_Rightclick
--	category:	"MacroFileTest"
--	buttontext:	"Only Rightclick"
--	toolTip:	"Tooltip with\nnew line"
--	icon:	"event:#rightClick"
--(
--	print "Button Rightclick #rightclick"
--)
--


/*------------------------------------------------------------------------------
  CHECKBOX
----------------------------------------------------------------------------*/


--/*
--*/
--macroscript macroFileTest_checkbox
--	category:	"MacroFileTest"
--	buttontext:	"Checkbox"
--	toolTip:	"Changed event tooltip"
--	icon:	"control:checkbox|checked:true|border:false|columns:12"
--(
--	print "checkbox #changed"
--	format "EventFired	= % \n" EventFired
--)
--
--/*
--*/
--macroscript macroFileTest_checkbox_right
--	category:	"MacroFileTest"
--	buttontext:	"Checkbox"
--	toolTip:	"Right click tooltip"
--	icon:	"control:#checkbox"
--
--(
--	print "checkbox #rightclick"
--	format "EventFired	= % \n" EventFired
--)

/*------------------------------------------------------------------------------
  SPINNER
--------------------------------------------------------------------------*/

--/*
--*/
--macroscript macroFileTest_spinner_rightclick
--	category:	"MacroFileTest"
--	buttontext:	"Spinner Test"
--	tooltip:	"Spinner tooltip"
--	icon:	"control:spinner"
--(
--	print "Spinner test changed"
--	format " EventFired = % \n"  EventFired
--)

--/*
--*/
--macroscript macroFileTest_spinner
--	category:	"MacroFileTest"
--	buttontext:	"Spinner Test"
--	tooltip:	"Spinner tooltip"
--	icon:	"control:spinner|event:#entered|range:[ 1, 10, 0.05 ]|scale:0.01"
--(
--	format " EventFired = % \n"  EventFired
--	--format " EventFired = % \n"  EventFired.Control.range
--
--	if EventFired.inSpin and EventFired.Control.value == EventFired.Control.range[1] then
--		print "\nSpinner test #rightclick or spinner RESETED\n\n3Ds Max BUG ?\n\nArgument inCancel DOESN'T WORK"
--	else
--		print "Spinner test #entered"
--)


/*------------------------------------------------------------------------------
  MULTILISTBOX
----------------------------------------------------------------------------*/

--macroscript	macroFileTest_multilistbox_event
--category:	"MacroFileTest"
--buttontext:	"Test List"
--toolTip:	"Nodes to export"
--icon:	"control:multilistbox|across:2|items:#('first', 'second', 'third')"
--(
--	format "EventFired	= % \n" EventFired
--
--)
--
--macroscript	macroFileTest_multilistbox_event_secondary
--category:	"MacroFileTest"
--buttontext:	"Test List"
--toolTip:	"Nodes to export"
--icon:	"control:multilistbox|event:#selected"
--(
--	format "EventFired	Secondary = % \n" EventFired
--
--)
