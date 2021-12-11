global GROUPBOX_DEFAULT_HEIGHT = 99

/** GroupBoxes_v
 */
struct GroupBoxes_v
(
	/* ListBody is defining these variables
	   
		this.keys	= #() 
		this.values	= #()
	*/
	include "Library/MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"
		
	/** Get controlcount in groupbox
	 */
	function getControlsInGroupbox groupbox_id =
	(
		if( ( _controls = this.getVal(groupbox_id) ) == undefined ) then
			_controls = #()
		
		_controls --return
	),
	
	
	/** Set group box
	 */
	function tryAddGroupbox _Controls _Control =
	(
		/* IF CONTROL IS GROUPBOX */ 
		if( _Control.type == #Groupbox ) then
		(
			this._setDefaultHeight(_Control)
			
			this._saveGroupBox(_Control.id)
		)
	),
	
	/** Try add control
	 */
	function tryAddControl _Controls _Control =
	(
		/* IF CONTROL IS IN GROUPBOX */ 
		if( (groupbox_caption = _Control.Params.getVal #Groupbox) != undefined ) then
		(
			--format "groupbox_caption	= % \n" groupbox_caption
			_GroupBox = this._createOrGetGroupBoxControl (_Controls) (_Control) (groupbox_caption)

			_Control.param #pos [0, 0] -- move controls aside, so they don`t mess up with layout

			_Control.Params.setVal #Groupbox _GroupBox.id

			this._addControlToGroupboxList (_GroupBox.id) (_Control.id)
		)
	),
	
	--_Control.Params.setVal #height 196z
	private
	
	
	/** _get group box
	 */
	function _createOrGetGroupBoxControl _Controls _Control groupbox_caption =
	(
		--print "GroupBoxes_v._createCreateCreateOrGetGroupBox()"
		if( (_GroupBox = this._findGroupboxInControls(_Controls)(groupbox_caption) ) == undefined ) then
		
			_GroupBox = this._createGroupboxByControl (this._createNewGroupBox(_Controls)(groupbox_caption)) (_Control)

		
		_GroupBox --return
	),
	
	/** _create groupbox by control
	 */
	function _createGroupboxByControl _GroupBox _Control =
	(		
		if( ( control_across = _Control.Params.getVal #across ) != undefined ) then 
			_GroupBox.Params.setVal #across control_across
		
		
		--_GroupBox.Params.setVal #height #bycontrols -- hook for ControlCreator, it will set he by controls by
		
		this._setDefaultHeight(_GroupBox)
		this._saveGroupBox(_GroupBox.id)
		
		_GroupBox --return
	),
	
	/** _
	 */
	function _addControlToGroupboxList _GroupBox_id _Control_id =
	(
		append  (this.getVal(_GroupBox_id)) _Control_id
	),

	/** _find groupbox in controls
	 */
	function _findGroupboxInControls _Controls groupbox_caption =
	(
		local _GroupBox
			
		for _Control in _Controls.List where _Control.type == #groupbox and _Control.caption == groupbox_caption do _GroupBox = _Control
		
		_GroupBox --return
	),
	
	/** _save group box
	 */
	function _saveGroupBox groupbox_id =
	(
		this.setVal (groupbox_id) #()
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
		--_GroupBox.Params.setVal #height 300
		
		if _GroupBox.Params.getVal #height == undefined  do -- 90px is default width of groupbox
			_GroupBox.Params.setVal #height GROUPBOX_DEFAULT_HEIGHT
	),
	
	/**  
	 */
	on create do
	(
		--print "GroupBoxes_v.create()"
	)
)