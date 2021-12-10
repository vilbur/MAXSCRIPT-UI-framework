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
	function manageControlAddTopGroupbox _Controls _Control =
	(
		--format "\n"; print ("GroupBoxes_v.manageGroupbox() "+_Control.id)
		
		/* IF CONTROL IS GROUPBOX */ 
		if( _Control.type == #Groupbox ) then
			this._saveGroupBox(_Control.id)

		/* IF CONTROL IS IN GROUPBOX */ 
		if( (groupbox_caption = _Control.Params.getVal #Groupbox) != undefined ) then
		(
			--format "groupbox_caption	= % \n" groupbox_caption
			_GroupBox = this._createOrGetGroupBoxControl (_Controls) (groupbox_caption)
			
			_Control.param #pos	[0, 0]

			_Control.Params.setVal #Groupbox _GroupBox.id

			this._addControlToGroupboxList (_GroupBox.id) (_Control.id)
		)
	),
	
	
	private
	
	
	/** _get group box
	 */
	function _createOrGetGroupBoxControl _Controls groupbox_caption =
	(
		--print "GroupBoxes_v._createCreateCreateOrGetGroupBox()"
		if( (_GroupBox = this._findGroupboxInControls(_Controls)(groupbox_caption) ) == undefined ) then
		(
			_GroupBox = this.createNewGroupBox(_Controls)(groupbox_caption) --params:#(#across, 2)
			
			this._saveGroupBox(_GroupBox.id)
		)
		
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
	function createNewGroupBox _Controls groupbox_caption =
	(
		 _Controls.control #Groupbox groupbox_caption
	),
	
	/**  
	 */
	on create do
	(
		--print "GroupBoxes_v.create()"
	)
)