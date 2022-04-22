--/**
--  *	
--  */
--macroscript macrotest_parse_params
--category:	"_macrotest"
--buttontext:	"Props test button"
--toolTip:	"Tooltip button rightclick"
--icon:	"event: #rightclick| width:128 | height : 64|border:true"
----icon:	"#(path, index)" -- !!!! TODO: icon param
--(
--	messageBox "This is test of parsing params in icon param"
--)

/**
  *	
  */
macroscript macrotest_parse_params_icon_array
category:	"_macrotest"
buttontext:	"Image button"
toolTip:	"Tooltip button rightclick"
--icon:	"event: #rightclick| width:128 | height : 64|border:true"

icon:	"images:#('/icons_sprite.bmp',undefined,9,1,2,3,4)"
--icon:	"images:#('/icons_sprite_40.bmp',undefined,9,1,2,3,4)"
--icon:	"images:#('$userScripts/Library/MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentSubrollouts/ContentRollout/ScriptFile/_Test/Test-files/icons_sprite.bmp',undefined,9,1,2,3,4)"

--icon:	"images:#('C:/GoogleDrive/Programs/CG/3DsMax/scripts/Library/MAXSCRIPT-UI-framework/Lib/ContentLoader/ContentSubrollouts/ContentRollout/ScriptFile/_Test/Test-files/icons_sprite.bmp',undefined,9,1,2,3,4)"
--icon:	#("Cameras",1)
--icon: "string_to_escape:'fooBar'"
(
	messageBox "This is test of parsing params in icon param"
)

