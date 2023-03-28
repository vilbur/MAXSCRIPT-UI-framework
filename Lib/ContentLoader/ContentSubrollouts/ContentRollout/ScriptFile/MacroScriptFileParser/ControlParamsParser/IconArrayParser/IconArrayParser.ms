/** Set button image by maxscript icon
 */
struct IconArrayParser_v
(
	/* construct */
	/* properties */
	max_color_theme = "Dark",
	--max_color_theme = "", -- for white theme

	suffixes = #("_24i.bmp", "_16i.bmp", "_i.bmp", ".ico", "png"),

	images_parameter = #( #icon_path, #maskImage, #count_integer, #enabled_out_image_index, #enabled_in_image_index, #disabled_out_image_index, #disabled_in_image_index ), -- DOCUMENTATION:https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_63E016F3_250E_4C93_B213_2C1AB51710F7_htm#WS73099CC142F487553098682E12AC2FC2BC7-72E0

	/* dependency */
	/* reference */
	/* inhered */

	/** Get icon from standard icon parameter of maxscript
	  *
	  * @param 2Dmatrix	params from ControlParamsParser_v
	  * @param array 	images E.G.: #("standard", 2)  DOCUMENTATION: https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-6E21C768-7256-4500-AB1F-B144F492F055#icons
	  *
	  * @return 2Dmatrix
	 */
	function setIconParameter &params icon_array =
	(
		--format "\n"; print "ImagesArrayParser_v.setImageParameter()"

		icon_path = this._getIconPath (icon_array[1])
		--format "icon_path	= % \n" icon_path

		if icon_path != false then
		(
			img_size = this._getSpriteSize (icon_path)

			images_parameter[1] = icon_path
			images_parameter[2] = undefined
			images_parameter[3] = (img_size[1] / img_size[2])  as integer -- Get icons count by dividing width by height
			images_parameter[4] = icon_array[2]
			images_parameter[5] = icon_array[2]
			images_parameter[6] = icon_array[2]
			images_parameter[7] = icon_array[2]

			--format "images_parameter	= % \n" images_parameter
			append params[1] #images
			append params[2] images_parameter

		)

		params --return
	),


	private


	/** Get icon path
	  *
	  * @param string icon_basename E.G.: "stadard"
	  *
	  * @return string path to icon file E.G.: "C:\Program Files\Autodesk\3ds Max 2023\UI_LN\IconsDark\Standard_24i.bmp"
	 */
	function _getIconPath icon_basename =
	(
		--format "\n"; print "IconArrayParser_v._getIconPath()"

		dir_path = 	getDir(#ui_ln) + "/Icons"+max_color_theme+"/"

		for suffix in suffixes do
			if doesFileExist (icon_path = dir_path + icon_basename + suffix) then
				return this._sanitizePath(icon_path)

		false --return
	),

	/** Get size of sprite image
	 */
	function _getSpriteSize icon_path =
	(
		--format "\n"; print "ControlParamsParser_v.getSpriteSize()"
		img = ( dotNetClass "System.Drawing.Image").FromFile icon_path

		img_size = [ img.Width, img.Height ]

		img.Dispose()

		img_size --return
	),

	/** Set button width by icon height, if width is not defined
	  *
	  * result is square button
	 */
	function _setButtonWidthByIcon &params img_size =
	(
		--format "\n"; print "ImagesArrayParser_v._setButtonWidthByIcon()"

		if findItem params[1] #width == 0 then
		(
			append params[1] #width
			append params[2] img_size[2] as integer
		)

		params --return
	),

	/** Repalce salshes "\\" with "/"
	 */
	function _sanitizePath icon_path =
	(
		--format "\n"; print "ImagesArrayParser_v.sanitizePath()"
		( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace icon_path "/" --return
	),

	/**
	 */
	on create do
	(
	)

)
