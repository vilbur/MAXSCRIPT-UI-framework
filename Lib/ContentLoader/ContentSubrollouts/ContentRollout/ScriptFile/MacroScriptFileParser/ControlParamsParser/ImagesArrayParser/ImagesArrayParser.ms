/** Set images array of button
  *
  * Only icon path is required, other values can be autofilled E.G.: "#('Icons.bmp')" >>> "#('Icons.bmp',undefined,3,1,1,1,1)"
  *
  * If button width is undefined, then HEIGHT of sprite is used as button WIDTH, it creates SQUARE image button
  *
  *		images: #(
  *			<image>,	REQUIRED
  *			<maskImage>,	-- can be UNDEFINED
  *			<count_integer>,	-- if UNDEFINED, count of icons in sprite, if undefined then: image width / image height = count of sqaure icons
  *			<enabled_out_image_index>,	-- if UNDEFINED, then 1 is used
  *			<enabled_in_image_index>,	-- if UNDEFINED, then icon index is used
  *			<disabled_out_image_index>,	-- if UNDEFINED, then icon index is used
  *			<disabled_in_image_index>,	-- if UNDEFINED, then icon index is used
  *			<invert_boolean>,	-- optionable
  *			<colortheme_boolean>	-- optionable
  *		)
  *
  *
  *
  *
  *
 */
struct ImagesArrayParser_v
(
	/* properties */
	path, -- path to "*.mcr" file
	images,

	icon_path,
	img_size,

	/** Set image parameter
	  *
	  * DOCUMENTATION:https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_63E016F3_250E_4C93_B213_2C1AB51710F7_htm#WS73099CC142F487553098682E12AC2FC2BC7-72E0
	  *
	  * @param 2Dmatrix	params from ControlParamsParser_v
	  * @param array 	images E.G.: #('/icons/sprite.bmp',undefined, 9, 1, 2, 3, 4)
	  *
	  * @return 2Dmatrix
	 */
	function setImageParameter &params images =
	(
		format "\n"; print "ImagesArrayParser_v.setImageParameter()"
		this.images	= images

		icon_path = images[1] = this._getIconPath(images[1])

		if icon_path != undefined and this._iconFileExist() then
		(
			/* PATH TO ALPHA IMAGE */ 
			images[2] = this._getIconPath(images[2])

			/* COUNT OF ICONS IN STRIP */ 
			if images[3] == undefined then images[3] = this._getIconsCountInSprite()
			
			/* ENABLED OUT INDEX */
			if images[4] == undefined then images[4] = 1
			/* ENABLED IN INDEX */
			if images[5] == undefined then images[5] = if ( next_index = images[4] + 1 ) <= images[3] then next_index else images[4] -- next index is used if strip has more then 1 image
			
			/* DISABLED OUT INDEX */
			if images[6] == undefined then images[6] = images[4] 
			/* DISABLED IN INDEX */
			if images[7] == undefined then images[7] = images[5]
			
			/* INVERT */ 
			if images[8] == undefined then images[8] = true -- INVERT alpha by defaut -- Max has inverted alpha BLACK is OPAQUE but WHITE is TRANSPARENT

			format "IMAGES: %\n" images
			params[#IMAGES] = images

			this._setButtonWidthByIcon (params)
		)
		--format "PARAMS	= % \n" params
		params --return
	),

	/** Get icon path
	  *
	  * 1) Relative path to "*.mcr" file
	  * 2) $userScripts|#userScripts|$maxroot|#maxroot...
	  * 3) Absolute path
	  *
	 */
	function _getIconPath _path =
	(
		--format "\n"; print "ImagesArrayParser_v._getIconPath()"
		format "path	= % \n" _path
		
		if _path != undefined then
		(
			/* RELATIVE PATH */ 
			if matchPattern _path pattern:"/*" then -- test if path is relative and starts with "/" E.G.: /icons
				_path = getFilenamePath(path) +"/"+ _path
	
			/* SYSTEM DIR PATH */ 
			else if matchPattern _path pattern:"$*" or matchPattern _path pattern:"#*" then -- test if path starts with "$" E.G.: $userScripts
				_path = this._replaceSystemDir( _path )
	
			this._sanitizePath( _path ) --return
		)
		
	),

	/** Replace system dir with absolute path
	  *
	  * E.G.: $maxroot
	  *
	 */
	function _replaceSystemDir icon_path =
	(
		--format "\n"; print "ImagesArrayParser_v._replaceSystemDir()"
		string_split	= filterString icon_path "/"

		system_dir_name = string_split[1]

		system_dir_pah = getDir (( substring string_split[1] 2 -1 ) as name ) + "/"

		substituteString icon_path system_dir_name system_dir_pah --return
	),

	/** Set icon count
	 */
	function _getIconsCountInSprite =
	(
		format "\n"; print "ImagesArrayParser_v._getIconsCountInSprite()"

		this._setSpriteSize()
		format "IMG_SIZE: %\n" img_size
		(img_size[1] / img_size[2]) as integer -- return
	),

	/** Set button width by icon height, if width is not defined
	  *
	  * result is square button
	 */
	function _setButtonWidthByIcon &params =
	(
		--format "\n"; print "ImagesArrayParser_v._setButtonWidthByIcon()"

		if params[#width] == undefined then 
		(
			this._setSpriteSize()

			params[#width] = (img_size[2] as integer )
		)

		params --return
	),

	/** Get size of sprite image
	 */
	function _setSpriteSize =
	(
		--format "\n"; print "ControlParamsParser_v.getSpriteSize()"
		if img_size == undefined then
		(
			img = ( dotNetClass "System.Drawing.Image").FromFile icon_path

			img_size = [ img.Width, img.Height ]

			img.Dispose()
		)

		img_size --return
	),

	/** Repalce salshes "\\" with "/"
	 */
	function _sanitizePath _path =
	(
		--format "\n"; print "ImagesArrayParser_v.sanitizePath()"
		if _path != undefined then
			( dotNetObject "System.Text.RegularExpressions.Regex" @"[\\/]+" ).Replace _path "/" --return
	),

	/** Test if icon file exist
	 */
	function _iconFileExist =
	(
		--format "\n"; print "ControlParamsParser_v._iconFileExist()"
		--format "icon_path	= % \n" icon_path
		if not doesFileExist icon_path then
		(
			format "\n\n--------------------------------------------------------------------------------\n\n	ICON FILE DOES NOT EXISTS\n\n	%\n\n--------------------------------------------------------------------------------" icon_path

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
