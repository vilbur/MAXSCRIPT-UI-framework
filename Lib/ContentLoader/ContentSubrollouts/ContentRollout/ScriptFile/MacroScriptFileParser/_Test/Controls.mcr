
/**
  *	
  */
macroscript macrotest_parse_properties
category:	"_macrotest"
buttontext:	"Props test button"
toolTip:	"Tooltip button rightclick"
icon:	"event: #rightclick, width:128 | height : 64|border:true"
--icon:	"#(path, index)" -- !!!! TODO: icon param
(
	messageBox "This is test of parsing params in icon param"
)