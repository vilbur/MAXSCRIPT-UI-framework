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
	function manageGroupbox _Controls _Control =
	(
		print ("Controls_v.manageGroupbox() "+_Control.id)
		
		/* IF CONTROL IS GROUPBOX OR IS IN GROUPBOX */ 
		if( (groupbox_caption = _Control.Params.getVal #GroupBox) != undefined ) then
		(
			format "groupbox_caption	= % \n" groupbox_caption
			_GroupBox = this._createOrGetGroupBox (_Controls) (groupbox_caption)
			
			format "_Control.Params.getVal #across	= % \n" (_Control.Params.getVal #across)	
			format "_Control.Params.getVal #height	= % \n" (_Control.Params.getVal #height)	
			--_GroupBox.Params.setVal #across (_Control.Params.getVal #across)
			this._setWidthOfGroupbox (_GroupBox) (_Control)
			
			_Control.param #pos	[0, 0]

			--this._change
			_Control.Params.setVal #GroupBox _GroupBox.id

			index	= this._getIndexOfGroupBox(_GroupBox.id)

			append this.values[index] _Control.id
		)
	),
	
	
	private
	
	
	/** _get group box
	 */
	function _createOrGetGroupBox _Controls groupbox_caption =
	(
		--print "Controls_v._createCreateCreateOrGetGroupBox()"
		if( (_GroupBox = this._findGroupboxInControls(_Controls)(groupbox_caption) ) == undefined ) then
			_GroupBox = this.createNewGroupBox(_Controls)(groupbox_caption) --params:#(#across, 2)
			
		this._saveGroupBox(_GroupBox.id)
		
		_GroupBox --return
	),
	
	/** _set width of groupbox
	 */
	function _setWidthOfGroupbox _GroupBox _Control =
	(
		_GroupBox.Params.setVal #across (_Control.Params.getVal #across)
	),


	/** _ group box
	 */
	function _getIndexOfGroupBox groupbox_id =
	(
		--format "\n"; print "GroupBoxes_v._getIndexOfGroupBox()"
		findItem this.keys groupbox_id --return
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
		 _Controls.control #GroupBox groupbox_caption
	),
	
	/**  
	 */
	on create do
	(
		--print "Controls_v.create()"
	)
)