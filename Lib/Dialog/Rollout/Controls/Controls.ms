filein( getFilenamePath(getSourceFileName()) + "/Control/Control.ms" )	-- "./Control/Control.ms"
filein( getFilenamePath(getSourceFileName()) + "/DefaultParameters/DefaultParameters.ms" )	-- "./DefaultParameters/DefaultParameters.ms"
filein( getFilenamePath(getSourceFileName()) + "/GroupBoxes/GroupBoxes.ms" )	-- "./GroupBoxes/GroupBoxes.ms"


/** Controls
 */
struct Controls_v
(
	/* properties */
	group,

	List = #(),

	/* dependency */
	DefaultParameters = DefaultParameters_v(),

	GroupBoxes 	= GroupBoxes_v(),

	rollout_id,

	/** Create new control
	  *
	  * @property	name	type	Type of control
	  * @property	string	caption	Caption of control, caption is hidden if it`s wrapped into brackets "[]" E.G.: "[Browse Path]"
	  * @property	name	id	Id of control
	  * @property	array	params	Params for control #( #key1, "value1", #key2, "value2",... )
	  * @property	boolean	ini	Enable Disable save control value to ini
	  *
	  *
	  * CONTROLS GROUP: https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-5DFECB42-C452-457B-BAD4-B07767AE8C9E
	  *
	  * SLIDER: https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_B674277E_596E_4469_BA45_2AE8F071D975_htm
	  * @property	#integer	ticks	Slider ticks
	  * @property	#vertical	type	Slider type: #vertical|#horizontal
	  *
	  * SPINNER:https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_411DB273_7B74_4FD7_89E9_B74B9CED102B_htm
	  * @property	#float	scale	Spinner scale
	  *
	  *
	  *
	  * @return Object _Control	"./Control/Control.ms"
	 */
	function Control control_type caption id:undefined params:#() pos: width: height: across: offset: align: tooltip: ini:true add_to_controls:true \ -- common params for all types
		range:	ticks: orient:	\ -- slider
		default:	unselect:	\ -- radiobutton
		items:	columns:	\ -- radiobutton, lisbox, mutlilistbox
		type:	scale:	\ -- spinner
		value:		\ -- current value of nost of all
		color:		\ -- colorpicker, bitmap -- alias for "value" E.G.: color:green >>> value:(bitmap 256 32 color:green)
		checked:		\ -- checkbox, checkbutton
		highlightColor:		\ -- checkbutton
		border:		\
		bitmap:		\ -- bitmap, imgTag
		groupbox:		\ -- add control to groupbox 
		visible:		=
	(
		--format "\n"; print "Controls_v.Control()"

		/* PROCESS FUNCTION PARAMETERS */ 	
		_param_names  = #( #pos, #checked, #width, #height, #offset, #align, #items, #range, #type, #ticks, #orient, #scale, #controller, #default, #unselect, #value, #color, #bitmap, #ini, #tooltip, #across, #columns,	#visible, #border, #groupbox, #highlightColor)
		_param_values = #(  pos,  checked,  width,  height,  offset,  align,  items,  range,  type,  ticks,  orient,  scale,  controller,  default,  unselect,  value,  color,  bitmap,  ini,   tooltip,  across,  columns,  visible,   border,  groupbox,  highlightColor)


		/* SET CONTROL ID BY VALUE IN PARAMS */ 
		if ( index = findItem params #id ) > 0 then
			id = params[index +1]

		
			
		/*------------------------------------------------------------------------------
			CREATE NEW CONTROL
		--------------------------------------------------------------------------------*/
		_Control = Control_v type:control_type caption:caption id:id rollout_id:rollout_id /*add_locals:locals */

		

		/* PASS FUNCTION PARAMETERS TO CONTROL */ 
		for i = 1 to _param_values.count where _param_values[i] != unsupplied do
			_Control.Param (_param_names[i]) (_param_values[i])

		/* SET CONTROL PARAMETERS FROM PARAMS ARRAY */ 
		this._setParamsToControl(_Control)(params)

		

		/* ADD CONTROL TO GROUPBOX */ 
		if _Control.type == #Groupbox  then
			GroupBoxes.addGroupbox(this)(_Control)
		else
			GroupBoxes.addControlToGroupbox (this)(_Control)
			
			
			
		/* ADD CONTROL TO CONTROLS */ 
		if( add_to_controls ) then
			this.add _Control

		
		_Control --return
	),

	/** Add
	 */
	function add _Control =
	(
		append List _Control
	),

	/** Get
	 */
	function get control_id =
	(
		(for _Control in List where _Control.id == control_id collect _Control)[1]
	),

	/** Set controls Default params
	  *
	  * if type match control type, then be applied as default
	  *
	  * @param	#name	type is mask and must match control type E.G.: match #listbox|#multilistbox|#dropdownlist if type==#List
	  *
	 */
	function Default key val type:#global =
	(
		--print ("Controls_v.Default("+Key as string +", "+val as string +", type:#"+type as string+")")
		 DefaultParameters.setDefaultParam key val type:type
	),

	/** Wrapper of method this.Default() for mass assignment params in array
	  *
	  * @param	#array keys_values	#( #key1,"value1", #key2,"value2" )
	  *
	 */
	function Defaults keys_values type:#global =
	(
		for i = 1 to keys_values.count  by 2  do
			this.Default keys_values[i] keys_values[i+1] type:type
	),

	private


	/** Set params to control
	 * @property	array|string	params	E.G.: #( #key1, "value1", #key2, "value2" ) | "#key1:value1, #key2:value2"
	 *
	 *
	 */
	function _setParamsToControl &_Control params =
	(
		--format "\n"; print "Controls_v._setParamsToControl()"
		--format "_Control.type: %\n" _Control.type
		--format "PARAMS:	% \n" params
		--format "classOf params: %\n" (classOf params)

		/* SPLIT PARAMS STRING AND CONERT TO CORRECT DATATYPES */ 
		if classOf params == string then
			params = this._splitParamsString (params)
		
		/* DEBUG PRINT */ 	
		--for i = 1 to params.count  by 2 do format "%: % \n" params[i] params[i+1]

		for i = 1 to params.count  by 2  do
			_Control.Param params[i] params[i+1]

		_Control --return
	),


	/** _split params string
	  *
	  * @param	string	params_string E.G.: "width:256|height:64, border:false"
	  *
	  * @return	array E.G.: #("width", 256, "height", 64, "border", false)
	 */
	function _splitParamsString params_string =
	(
		--format "\n"; print "Controls_v._splitParamsString()"
		params = #()

		for key_value_pair in filterString params_string "|," splitEmptyTokens:false do
			for key_value in filterString key_value_pair ":"  do
				append params (this._convertDatatype( trimRight ( trimLeft key_value )))

		params --return
	),

	/** Format string value to valid datatype
	 */
	function _convertDatatype _string =
	(
		--_string = substituteString _string "\\" "\\\\"

		rx	= dotNetClass "System.Text.RegularExpressions.RegEx"
		rx_options	= dotNetClass "System.Text.RegularExpressions.RegexOptions"

		is_variable = (rx.match _string "^\s*(\d+|true|false|undefined|unsupplied|\(*\s*color\s+\d+\s+\d+\s+\d+\s*\)*|\(*\s*bitmap\s+\d+\s+\d+)\s*$" rx_options.IgnoreCase ).success
	
		if is_variable and (is_string = ( rx.match _string "(^'*[A-Za-z0-1_\s]+'*$)" rx_options.IgnoreCase ).success ) then
		(
			try((execute(_string)))catch(_string) -- IS VARIABLE
		)
		else
		(
			@"" + _string -- IS STRING
		)
	),

	/**
	 */
	on create do
	(
		--print "Controls_v.create()"
		--if this.group != undefined then
			--this.group = this.group
	)
)