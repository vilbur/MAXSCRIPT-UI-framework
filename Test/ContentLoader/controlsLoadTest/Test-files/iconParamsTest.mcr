/** RELATIVE PATH to current .mcr file
  *
  */
macroscript macrotest_parse_icon_params_relative_path
category:	"_macrotest"
buttontext:	"Relative icon path"

icon:	"images:#('icons/icons_sprite.bmp',undefined,9,1,2,3,4)"
(
)



/** SYSTEM PATH to icon file starts with "$" E.G.: $userScripts
  *
  *	System dirs: https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_F7577416_051E_478C_BB5D_81243BAAC8EC_htm
  */
macroscript macrotest_parse_icon_params_system_path
category:	"_macrotest"
buttontext:	"System dir icon path"

icon:	"images:#('$userScripts/MAXSCRIPT-UI-framework/Test/ContentLoader/controlsLoadTest/Test-files/icons/icons_sprite.bmp',undefined,9,2,3,3,4)"
(
)



/** ABSOLUTE PATH to icon file
  *
  */
macroscript macrotest_parse_icon_params_absolute_path
category:	"_macrotest"
buttontext:	"Absolute icon path"

icon:	"images:#(@'c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Test\ContentLoader\controlsLoadTest\Test-files\icons\icons_sprite.bmp',undefined,9,3,4,3,4)"
(
)
