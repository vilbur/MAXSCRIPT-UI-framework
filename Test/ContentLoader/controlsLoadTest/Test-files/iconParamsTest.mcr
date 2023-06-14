--/** STANDARD ICON PARAMETER
--  *
--  */
--macroscript macrotest_parse_icon_param
--category:	"_macrotest"
--buttontext:	"Stardard con path"
--icon:	#("standard", 5)
--(
--)
--
--
--
--/** RELATIVE PATH to current .mcr file
--  *
--  * Only icon path is required, other values can be autofilled E.G.: "#('Icons.bmp')" >>> "#('Icons.bmp',undefined,3,1,1,1,1)"
--  *
--  * If button width is undefined, then HEIGHT of sprite is used as button WIDTH, it creates SQUARE image button
--  *
--  *		images: #(
--  *			<image>,	REQUIRED
--  *			<maskImage>,	-- if UNDEFINED
--  *			<count_integer>,	-- if UNDEFINED, count of icons in sprite, if undefined then: image width / image height = count of sqaure icons
--  *			<enabled_out_image_index>,	-- if UNDEFINED, then 1 is used
--  *			<enabled_in_image_index>,	-- if UNDEFINED, then icon index is used
--  *			<disabled_out_image_index>,	-- if UNDEFINED, then icon index is used
--  *			<disabled_in_image_index>,	-- if UNDEFINED, then icon index is used
--  *			<invert_boolean>,	-- optionable
--  *			<colortheme_boolean>	-- optionable
--  *		)
--  *
--  */
--macroscript macrotest_parse_icon_params_relative_path
--category:	"_macrotest"
--buttontext:	"Relative icon path"
--
--icon:	"images:#('/icons/icons_sprite.bmp')"
--(
--)
--
--
--
--/** RELATIVE PATH to current .mcr file
--  *
--  */
--macroscript macrotest_parse_icon_params_custom_height
--category:	"_macrotest"
--buttontext:	"Custom image button height"
--
--icon:	"images:#('/icons/icons_sprite.bmp', undefined, 9, 2, 3 )"
--(
--)
--
--
--
--/** SYSTEM PATH to icon file starts with "$" E.G.: $userScripts
--  *
--  *	LIST OF SYSTEM DIRS: https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_F7577416_051E_478C_BB5D_81243BAAC8EC_htm
--  */
--macroscript macrotest_parse_icon_params_system_path
--category:	"_macrotest"
--buttontext:	"System dir icon path"
--
--icon:	"images:#('$userScripts/MAXSCRIPT-UI-framework/Test/ContentLoader/controlsLoadTest/Test-files/icons/icons_sprite.bmp', undefined, 9, 4)"
--(
--)


/** SYSTEM PATH MAX ROOT
  *
  *
  */
macroscript macrotest_parse_icon_params_system_path
category:	"_macrotest"
buttontext:	"System dir icon path"

icon:	"images:#('$maxroot/UI_ln/Icons/Maintoolbar_24i.bmp', undefined, undefined, 4 )"
(
)


--/** ABSOLUTE PATH to icon file
--  *
--  */
--macroscript macrotest_parse_icon_params_absolute_path
--category:	"_macrotest"
--buttontext:	"Absolute icon path"
--
--icon:	"images:#(@'c:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Test\ContentLoader\controlsLoadTest\Test-files\icons\icons_sprite.bmp', undefined, 9, 5)"
--(
--)
--
--
--
--/** ICON with another PARAMETERS
--  *
--  */
--macroscript macrotest_parse_icon_params_with_another_params
--category:	"_macrotest"
--buttontext:	"Relative icon path with params"
--
--icon:	"width:256|height:256|images:#('/icons/icons_sprite.bmp', undefined, 9, 6 )"
--(
--)



/*------------------------------------------------------------------------------

	TEST NON EXISTING ICON

------------------------------------------------------------------------------*/
--
--/** STANDARD ICON DOES NOT EXISTS
--  *
--  */
--macroscript macrotest_parse_icon_param
--category:	"_macrotest"
--buttontext:	"Stardard con path"
--icon:	#("/this_icon_not_exists", 2)
--(
--)
--
--/** IMAGES FILE DOES NOT EXISTS
--  *
--  */
--macroscript macrotest_parse_icon_params_system_path
--category:	"_macrotest"
--buttontext:	"System dir icon path"
--
--icon:	"images:#('/this_icon_not_exists.bmp',undefined, 9, 4, 3, 3, 4)"
--(
--)