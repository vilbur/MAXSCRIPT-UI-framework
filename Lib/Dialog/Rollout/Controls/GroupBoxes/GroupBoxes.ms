/** GroupBoxes_v
 */
struct GroupBoxes_v
(
	/* ListBody is defining these variables
	   
		this.keys	= #() 
		this.values	= #()
	*/
	include "Library/MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"

	--
	--/** Get controlcount in groupbox
	-- */
	--function getControlCountInGroupbox groupbox_id =
	--(
	--	
	--),
	
	
	/** Set group box
	 */
	function _setGroupBoxParameters _Controls _Control =
	(
		print "Controls_v._setGroupBoxParameters()"
		
		/* if control has #groupbox paramter defined */ 
		if( (groupbox_caption = _Control.Params.getVal #GroupBox) != undefined ) then
		(
			_GroupBox = this._getGroupBox (_Controls)(groupbox_caption)
			
			 _Control.Params.setVal #GroupBox _GroupBox.id

			index	= this._getIndexOfGroupBox(_GroupBox.id)
			
			append this.values[index] _Control.id
		)
	),
	
	/** _get group box
	 */
	function _getGroupBox _Controls groupbox_caption =
	(
		local _GroupBox
			
		for _ControlInList in _Controls.List where _ControlInList.type == #groupbox and _ControlInList.caption == groupbox_caption do _GroupBox = _ControlInList
			
		if( _GroupBox == undefined ) then
		(
			_GroupBox = _Controls.control #GroupBox groupbox_caption --params:#(#across, 2)
			
			this.setVal (_GroupBox.id) #()
		)
		
		_GroupBox --return
	),
	
	/** _get index of group box
	 */
	function _getIndexOfGroupBox groupbox_id =
	(
		--format "\n"; print "GroupBoxes_v._getIndexOfGroupBox()"
		findItem this.keys (groupbox_id as string ) --return
	),
	
	private
	
	

	/**  
	 */
	on create do
	(
		--print "Controls_v.create()"
		
		
	)
)