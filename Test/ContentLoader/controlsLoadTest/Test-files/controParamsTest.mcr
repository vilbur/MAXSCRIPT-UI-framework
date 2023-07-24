/**
  *
  */
macroscript macrotest_parse_params
category:	"_macrotest"
buttontext:	"Params test button"
toolTip:	"Tooltip for leftclick event"
icon:	"event:#rightclick| width:128 | height : 64|border:true|Tooltip:Main tooltip for control\n"
(
	messageBox "This is test of parsing params in icon param"
)

/**
  *
  */
macroscript macrotest_parse_params
category:	"_macrotest"
buttontext:	"Params test button"
toolTip:	"Tooltip for rightclick event"
icon:	"event:#rightclick| width:128 | height : 64|border:true"
(
	messageBox "This is test of parsing params in icon param"
)



/** Test if string in parameter is not threaded as command
  *
  */
macroscript macrotest_parse_params_string_test
category:	"_macrotest"
buttontext:	"Select objects"
toolTip:	"Select objects"
icon:	"Tooltip:Select objects" -- IMPORTANT DO NOT WRAP STRING TO SIGLE QUOTES E.G.: "Tooltip:'Select objects'"
(
	select objects
)