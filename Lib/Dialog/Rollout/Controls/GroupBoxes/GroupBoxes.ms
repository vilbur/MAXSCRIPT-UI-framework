global GROUPBOX_DEFAULT_HEIGHT = 24

/** GroupBoxes_v
 */
struct GroupBoxes_v
(

	List = Dictionary(), -- keys:#groupbox_id values:#(Control_ids)


	/** Get controlcount in groupbox
	 */
	function getControlsInGroupbox groupbox_id =
	(
		if this.List[groupbox_id] != undefined then
			for _controls in this.List[groupbox_id] collect _controls.value

		else
			#() --return

	),

	/** Set group box
	 */
	function addGroupbox _Controls _Control =
	(
		--format ("GroupBoxes_v.addGroupbox() " + _Control.caption)
		--format "**************************************\n"
		--format "_Control.id: %\n" _Control.id
		--format "ADD GROUPBOX = % \n" _Control
		this._setDefaultHeight(_Control)

		this._saveGroupBox(_Control.id as name )
	),

	/** Try add control to Groupbox
	 */
	function addControlToGroupbox _Controls _Control =
	(
		--format "\n"; format ("GroupBoxes_v.addControlToGroupbox() " + _Control.caption)

		/* IF CONTROL HAS GROUPBOX DEFINED IN PARAMS */
		if( (groupbox_param = _Control.Params.getVal #Groupbox) != undefined ) then
		(
			_GroupBox = this._createOrGetGroupBoxControl (_Controls) (_Control) (groupbox_param)
		
			_Control.param #pos [0, 0] -- move controls aside, so they don`t mess up with layout
		
			_Control.Params.setVal #Groupbox _GroupBox.id
		
			this._addControlToGroupboxList (_GroupBox.id as name ) (_Control.id as name )
		)
	),


	private


	/**
	 */
	function _createOrGetGroupBoxControl _Controls _Control groupbox_param =
	(
		--format "GroupBoxes_v._createCreateCreateOrGetGroupBox()"
		if( (_GroupBox = this._findGroupboxInControls(_Controls)(groupbox_param) ) == undefined ) then

			_GroupBox = this._createGroupboxByControl (this._createNewGroupBox(_Controls)(groupbox_param)) (_Control)

		_GroupBox --return
	),
	
	/** _find groupbox in controls by id or caption
	 */
	function _findGroupboxInControls _Controls groupbox_param =
	(
		--format "GroupBoxes_v._findGroupboxInControls()"

		local _GroupBox_found

		for _Control in _Controls.List while _GroupBox_found == undefined \
			where _Control.type == #groupbox \
			and  (_Control.caption == groupbox_param or _Control.id == groupbox_param ) \
		do
			_GroupBox_found = _Control
	
		_GroupBox_found --return
	),

	/**
	 */
	function _createGroupboxByControl _GroupBox _Control =
	(
		--if( ( control_across = _Control.Params.getVal #across ) != undefined ) then
			--_GroupBox.Params.setVal #across control_across
		this._setDefaultHeight(_GroupBox)

		this._saveGroupBox(_GroupBox.id)

		_GroupBox --return
	),

	/**
	 */
	function _addControlToGroupboxList groupbox_id _Control_id =
	(
		--format "\n"; format "GroupBoxes_v._addControlToGroupboxList()"
		--format "groupbox_id	= % \n" groupbox_id
		--format "_Control_id	= % \n" _Control_id
		--format "this.List	= % \n" this.List

		--append  (this.getVal(groupbox_id)) _Control_id
		this.List[groupbox_id] += #(_Control_id)
	),


	/** Set groupbox id as key and empty array as value, array will store ids of controls in groupbox
	  *
	 */
	function _saveGroupBox groupbox_id =
	(
		--format "\n"; format "GroupBoxes_v._saveGroupBox()"
		--format "groupbox_id	= % \n" groupbox_id
		----this.setVal (groupbox_id) #()
		--format "this.keys	= % \n" this.keys
		this.List[ groupbox_id as name ] = #()
	),

	/** Craete new
	 */
	function _createNewGroupBox _Controls groupbox_caption =
	(
		 _Controls.control #Groupbox groupbox_caption
	),

	/** _save group box
	 */
	function _setDefaultHeight _GroupBox =
	(
		if _GroupBox.Params.getVal #height == undefined  do -- 90px is default width of groupbox
			_GroupBox.Params.setVal #height GROUPBOX_DEFAULT_HEIGHT
	),

	/**
	 */
	on create do
	(
		--format "GroupBoxes_v.create()"
		--format "!!!!!!!!!!!!!!!"
	)
)