/** ImagesArrayParser
 */
struct ImagesArrayParser_v
(
	/* properties */
	path, -- path to "*.mcr" file


	/** Set image parameter
	  *
	  * @param 2Dmatrix	params from ControlParamsParser_v
	  * @param array 	images E.G.: #('/icons/sprite.bmp',undefined,9,1,2,3,4) DOCUMENTATION:https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_E03EED5F_E21F_4C2F_AFA9_BA16A6602ACA_htm
	  *
	  * @return 2Dmatrix
	 */
	function setImageParameter &params images =
	(
		--format "\n"; print "ImagesArrayParser_v.setImageParameter()"

		icon_path = images[1] = this._getIconPath (images[1])

		if this._iconFileExist(icon_path) then
		(
			append params[1] #images
			append params[2] images

			this._setButtonWidthByIcon (params) (icon_path)
		)

		params --return
	),

	/** Get icon path
	  *
	  * 1) Relative path to "*.mcr" file
	  * 2) $userScripts
	  * 3) Absolute path
	  *
	 */
	function _getIconPath icon_path =
	(
		--format "\n"; print "ImagesArrayParser_v._getIconPath()"
		--format "path	= % \n" path

		if matchPattern icon_path pattern:"$*" then
			icon_path = this._replaceSystemDir(icon_path)

		else if matchPattern icon_path pattern:"/*" then
			icon_path = getFilenamePath(path) +"/"+ icon_path --return

		this._sanitizePath(icon_path) --return
	),

	/** Replace system dir
	 */
	function _replaceSystemDir icon_path =
	(
		--format "\n"; print "ImagesArrayParser_v._replaceSystemDir()"
		--format "icon_path	= % \n" icon_path

		string_split	= filterString icon_path "/"

		system_dir = string_split[1]

		system_dir_pah = getDir (( substring string_split[1] 2 -1 ) as name ) + "/"

		substituteString icon_path system_dir system_dir_pah --return
	),

	/** Set button width by icon height, if width is not defined
	  *
	  * result is square button
	 */
	function _setButtonWidthByIcon  &params icon_path =
	(
		--format "\n"; print "ImagesArrayParser_v._setButtonWidthByIcon()"

		if findItem params[1] #width == 0 then
		(
			img_size = this._getSpriteSize(icon_path)

			append params[1] #width
			append params[2] img_size[2]
		)

		params --return
	),


	/** Get size of sprite image
	 */
	function _getSpriteSize icon_path =
	(
		--format "\n"; print "ControlParamsParser_v.getSpriteSize()"
		--format "icon_path	= % \n" icon_path
		--format "icon_path.count	= % \n" icon_path.count
		img = ( dotNetClass "System.Drawing.Image").FromFile icon_path

		--imgSize = [img.Height / img.VerticalResolution, img.Width / img.HorizontalResolution]
		imgSize = [ img.Width,img.Height ]
		img.Dispose()
		imgSize --return
	),

	/** Repalce salshes "\\" with "/"
	 */
	function _sanitizePath icon_path =
	(
		--format "\n"; print "ImagesArrayParser_v.sanitizePath()"
		( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace icon_path "/" --return
	),

	/** Test if icon file exist
	 */
	function _iconFileExist icon_path =
	(
		--format "\n"; print "ControlParamsParser_v._iconFileExist()"
		--format "icon_path	= % \n" icon_path
		if not doesFileExist icon_path then
		(
			format "\n\n--------------------------------------------------------------------------------\n\n	ICON FILE DOES NOT EXISTS\n\n%\n\n--------------------------------------------------------------------------------" icon_path

			false --return
		) else
			true --return
	),

	/**
	 */
	on create do
	(
	)
)
