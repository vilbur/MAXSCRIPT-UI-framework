/** Browse path is EDITTEXT control with default callback which browse path
  *
  * Event is fired if edit text field is empty and space is writen in it
  *
  *  Fired with keys SPACE|BACKSPACE
 */
struct BrowsePath_v
(
	/* required */
	_Control,

	/* properties */
	browse_params = #(  -- https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-D4B43A33-8342-4BC9-80AB-91460861D37C
		#mode,	-- #getOpenFileName|#getSaveFileName|#getSavePath is default
		#caption,
		#initialDir,
		#types,
		#filename,
		#historyCategory
	),

	Events	= #(),

	prev_value_variable,

	/** Convert custom controls to native maxscript controls
	  *
	  * CALLED IN:  "ControlCreator_v._customizeControlTypes()"
	 */
	function convertToEditText &_Control =
	(
		--print "BrowsePath_v.mutateControl()"
		this._Control = _Control

		prev_value_variable = (_Control.id as string + "_prev_state")

		_Control.type = #editText

		_Control.addlocal ( prev_value_variable as name ) "" -- E.G.:  #BROWSEPATH_id_prev_state = ""

		--------history_path = getINISetting (GetMAXIniFile()) (this._getParam #historyCategory) "History_00"

		_Control --return
	),

	/** Get callback
	  *
	  */
	function getCallback _Control event_type =
	(
		--format "\n"; print "ControlEventCreator_v.getCallback()"
		this._Control = _Control

		this.prev_value_variable = (_Control.id as string + "_prev_state")

		tooltip = if( tooltip_param = _Control.params.getVal #tooltip ) != undefined then tooltip_param else ""

		this._setDefaultParams()

		case event_type of
		(
			#changed:	this._getChangedEvent(tooltip)
			#entered:	this._getEnteredEvent(tooltip)
		)

	),

	/** Get changed event
	 */
	function _getChangedEvent tooltip =
	(
		--format "\n"; print "BrowsePath_v._getChangedEvent()"

		/** NOTE: function valueIsEmpty should be placed in rollout, but there is no problem with it  */
		callback = "function valueIsEmpty _string =
		(
			(( dotNetClass @System.Text.RegularExpressions.RegEx@).match _string @^\s+$|^$@ ).success
		)

		if( val != "+prev_value_variable+" and valueIsEmpty(val) and valueIsEmpty("+prev_value_variable+") ) then -- IF VALUE HAS CHANGED AND FIELD IS EMPTY
		(
			 -- OPEN BROWSE DIALOG
			if( (browsed_path = "+ this._getPathDialog() +") != undefined ) then -- IF PATH HAS BEEN BROWSED
			(
				"+this._Control.id+".text    = browsed_path as string
				"+this._Control.id+".tooltip = browsed_path as string

				val = EventFired.val = substituteString browsed_path @\\\\@ @\\\\\\\\@
			)
			else
			(
				"+prev_value_variable+" = val -- IF DIALOG WAS CANCELED
				"+this._Control.id+".tooltip = \""+tooltip+"\"
			)
		)
		else
		(
			"+prev_value_variable+" = "+this._Control.id+".text
			"+this._Control.id+".tooltip = \""+tooltip+"\"
		)"

		callback --return
	),
	/** Get entered event
	 */
	function _getEnteredEvent tooltip =
	(
		--format "\n"; print "BrowsePath_v._getEnteredEvent()"
		callback = "if( val != \"\" ) then
				val = EventFired.val = "+this._Control.id+".tooltip = substituteString val @\\\\@ @\\\\\\\\@

			else
				"+this._Control.id+".tooltip = \""+tooltip+"\""

		callback --return
	),

	/** _set default params
	 */
	function _setDefaultParams =
	(
		--print "BrowsePath_v._setDefaultParams()"

		for param in browse_params do
			this._Control.Params.setVal(param)(
				case param of
				(
					#mode:	#getSavePath
					--#caption:	this._Control.caption
					#historyCategory:	this._getParam #historyCategory
					#initialDir:	"C:/"
					#types:	"All files|*.*|"
					default: undefined
				)

			)  unique:true

		this._Control.Params.filter undefined  test:true
	),

	/** Get dialog getSaveFileName|getOpenFileName  https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-D4B43A33-8342-4BC9-80AB-91460861D37C
	  *
	  * Wrap parameters to escaped quotes:@
	  *
	  * #initialDir paramter is not wraped if has absolute path
	  *
	  * @return	string joined parameters for dialog	e.g.: "getSavePath caption:"my title""
	 */
	function _getPathDialog =
	(
		print "BrowsePath_v._getPathDialog()"
		path_dialog = (this._getParam #mode) as string

		for param in browse_params where (val = this._getParam param ) != undefined and param != #mode do
		(
			format "PARAM:	% \n" param
			if not ( param == #initialDir and pathConfig.isAbsolutePath(val) == false )then
				val = "@"+ val as string +"@"

			path_dialog += " " + param as string + ":" + val
		)

		path_dialog  --return
	),

	/** _getParam
	 */
	function _getParam key =
	(
		--print "BrowsePath_v._getParam()"
		(_Control.Params.getVal key )--return
	),

	/**
	 */
	on create do
	(

	)
)