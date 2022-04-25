filein( getFilenamePath(getSourceFileName()) + "/ImagesArrayParser/ImagesArrayParser.ms" )

/** Control params parser
 */
struct ControlParamsParser_v
(
	/* required */
	path, -- path to "*.mcr" file
	
	/* properties */
	params, -- #( #(), #() ) 2D matrix
	
	/* dependency */
	ImagesArrayParser 	= ImagesArrayParser_v(),
	
	/** Parse params in "icon" param of macroscript
	  * 
	  * Each param is separated with pipe "|"
	  * 
	  * 
	  * 
	  * 
	  * @property	string	params_string	E.G.: "event: #rightclick| width:128 | height : 64|border:true|items: #('item1', 'item2')"
	  * 
	  * @return	2D matrix E.G.: #( #(param1,param2), #(value1,value2)	 )	
	 */
	function parse params_string =
	(
		--format "\n"; print "ControlParamsParser_v.parse()"
		--format "params_string	= % \n" params_string
		
		params = #( #(), #() )
		
		params_string = this._escapeSingleQuotes(params_string)

		if this._isIconArray (params_string) == false then 
		(
			key_value_pairs = filterString params_string "|" splitEmptyTokens:false
			
			for key_value in key_value_pairs do
				this._splitKeyAndValue (key_value)
		)

		params --return
	),
	
	private
	
	/** Test if icon parameter is default icon array E.G.: #("Cameras",1)
	  * 
	  * Documentation: https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-6E21C768-7256-4500-AB1F-B144F492F055#GUID-6E21C768-7256-4500-AB1F-B144F492F055__WS73099CC142F487553098682E12AC2FC2BC7-7281
	 */
	function _isIconArray params_string =
	(
		--format "\n"; print "ControlParamsParser_v.isIconArray()"
		matchPattern params_string pattern:@"#(*" --return
	),
	
	/** Split key and value
	 */
	function _splitKeyAndValue key_value =
	(
		--format "\n"; print "ControlParamsParser_v.splitKeyAndValue()"
		colon_index = findString key_value ":"
		
		key	= substring key_value 1 (colon_index-1)
		val	= substring key_value (colon_index+1)	-1
		
		
		if key != "images" then
		(
			val = this._convertDatatype( this._trimWhiteSpace(val))

			append params[1] ( this._trimWhiteSpace(key) )
			append params[2] val			
		)
		else
		(
			images = ImagesArrayParser.getIconPath(execute val)

			append params[1] ( this._trimWhiteSpace(key) )
			append params[2] images
			
			img_size = this._getSpriteSize(images[1])
			
			append params[1] "width"
			append params[2] img_size[2]
		)
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
	
	/** Remove leading and trailing white space
	 */
	function _trimWhiteSpace _string =
	(
		trimLeft ( trimRight _string ) --return
	),
	
	/** Replace "'" with "\""
	 */
	function _escapeSingleQuotes params_string =
	(
		--format "\n"; print "ControlParamsParser_v.escapeQuotes()"
		
		if matchPattern params_string pattern:"*'*" then
			params_string = substituteString params_string "'" "\""
		
		params_string --return
	),
	
	/** Format string value to valid datatype
	 */
	function _convertDatatype val =
	(		
		--print "MacroScript_Content_v._convertDatatype()"
		--format "val	= % \n" val
		if( (for pattern in #( "true", "false", "(color*", "[*,*]" ) where matchPattern val pattern:pattern collect pattern).count > 0 ) then 
			execute val
			
		else if( val as number != undefined ) then 
			val as number --return

		else
			val --return
	),
	
	/**  
	 */
	on create do
	(
	)
)