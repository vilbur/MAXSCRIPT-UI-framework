/** Browse path is edittext control with default event which browse path
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

	/** Browse path
	  *
	  * Add browse path event before users defined event
	 */
	/** Browse path
	  *
	  * Add browse path event before users defined event
	 */
	function getEvents _Control =
	(
		--print "BrowsePath_v.getControl()"
		this._Control = _Control
		--format "_Control.id	= % \n" _Control.id
		prev_value_variable = (_Control.id as string + "_prev_state")

		tooltip = if( tooltip_param = this._Control.params.getVal #tooltip ) != undefined then tooltip_param else ""

		this._setDefaultParams()

		this._setChangedEvent(tooltip)
		this._setEnteredEvent(tooltip)

		Events --return
	),

	/** Get changed event
	 */
	function _setChangedEvent tooltip =
	(
		--format "\n"; print "BrowsePath_v._getChangedEvent()"
		Event_changed =  Event_v type: #changed


		/** NOTE: function valueIsEmpty should be placed in rollout, but there is no problem with it  */
		Event_changed.code = "
			function valueIsEmpty _string =
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

		append Events Event_changed
	),
	/** Get entered event
	 */
	function _setEnteredEvent tooltip =
	(
		--format "\n"; print "BrowsePath_v._getEnteredEvent()"
		Event_entered =  Event_v type: #entered

		Event_entered.code = "
			if( val != \"\" ) then
				val = EventFired.val = "+this._Control.id+".tooltip = substituteString val @\\\\@ @\\\\\\\\@

			else
				"+this._Control.id+".tooltip = \""+tooltip+"\""

		append Events Event_entered
	),

	/** Browse path
	  *
	  * Add browse path event before users defined event
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
	  * @return	string joined parameters for dialog	e.g.: "getSavePath caption:"my title""
	 */
	function _getPathDialog =
	(
		--print "BrowsePath_v._getPathDialog()"
		--if( path_dialog = this._getParam #mode ) == undefined  then
		path_dialog = (this._getParam #mode) as string
		--path_dialog = "getSavePath"

		for param in browse_params where (val = this._getParam param ) != undefined and param != #mode do
			path_dialog += " " + param as string +":@"+ val as string +"@"
		--format "path_dialog = % \n" path_dialog
		path_dialog --return
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