
/*------------------------------------------------------------------------------
  
  
	PROPAGATED PARAMETERS:
	
	These parameters of controls are propagated downnstream through macroscripts
	
	inherit_params	= #( #width, #height, #across, #border )
	
	
	
	DEFINED IN: --"./../../../../Lib/ContentLoader/ContentSubrollouts/ContentRollout/ScriptFile/ScriptFile.ms"
	
	PROPERTY: ScriptFile_Content_v.inherit_params
	
	
	
--------------------------------------------------------------------------------*/


/** TEST parse of "icon" parameter
  *
  */
macroscript macrotest_parse_params
category:	"_macrotest"
buttontext:	"Params test button"
toolTip:	"Tooltip for leftclick event"
icon:	"event:#pressed| width:128 | height : 64|border:false|Tooltip:Main tooltip for control\n"
(
	messageBox "This is test of parsing params in icon param"
)



/** Test if string in parameter is not threaded as command
  */
macroscript macrotest_parse_params_string_test
category:	"_macrotest"
buttontext:	"Select objects"
buttontext:	"Select objects"
/*  IMPORTANT DO NOT WRAP STRING TO SIGLE QUOTES E.G.: "Tooltip:'Select objects'" */
icon:	"tooltip:Select objects"
(
	select objects
)