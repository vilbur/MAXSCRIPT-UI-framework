/** STANDARD ICON PARAMETER
  *
  */
macroscript macrotest_parse_icon_param
category:	"_macrotest"
buttontext:	"Stardard con path"
icon:	#("standard", 2)
(
)



/** RELATIVE PATH to current .mcr file
  *
  * Button will has AUTO WIDTH by height of sprite, it crates SQUARE image button
  */
macroscript macrotest_parse_icon_params_relative_path
category:	"_macrotest"
buttontext:	"Relative icon path"

icon:	"images:#('/icons/icons_sprite.bmp',undefined,9,2,2,3,4)"
(
)



/** RELATIVE PATH to current .mcr file
  *
  * Button will has auto width by height of sprite, it crates SQUARE image button
  */
macroscript macrotest_parse_icon_params_custom_height
category:	"_macrotest"
buttontext:	"Custom image button height"

icon:	"width:128|images:#('/icons/icons_sprite.bmp',undefined,9,3,2,3,4)"
(
)



/** SYSTEM PATH to icon file starts with "$" E.G.: $userScripts
  *
  *	System dirs: https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_F7577416_051E_478C_BB5D_81243BAAC8EC_htm
  */
macroscript macrotest_parse_icon_params_system_path
category:	"_macrotest"
buttontext:	"System dir icon path"

icon:	"images:#('$userScripts/MAXSCRIPT-UI-framework/Test/ContentLoader/controlsLoadTest/Test-files/icons/icons_sprite.bmp',undefined,9,4,3,3,4)"
(
)



/** ABSOLUTE PATH to icon file
  *
  */
macroscript macrotest_parse_icon_params_absolute_path
category:	"_macrotest"
buttontext:	"Absolute icon path"

icon:	"images:#(@'c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Test\ContentLoader\controlsLoadTest\Test-files\icons\icons_sprite.bmp',undefined,9,5,4,3,4)"
(
)



/** ICON with another PARAMETERS
  *
  */
macroscript macrotest_parse_icon_params_with_another_params
category:	"_macrotest"
buttontext:	"Relative icon path with params"

icon:	"width:256|height:256|images:#('/icons/icons_sprite.bmp',undefined,9,6,2,3,4)"
(
)
