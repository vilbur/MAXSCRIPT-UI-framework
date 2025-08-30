--filein( getFilenamePath(getSourceFileName()) + "/GroupBox/GroupBox.ms" )	--"./GroupBox/GroupBox.ms"

global GROUPBOX_DEFAULT_HEIGHT = 24

/** GroupBoxes_v
 */
struct GroupBoxes_v
(
	/* consrtuct*/ 
	Controls,

	/* properties */
	List = Dictionary(), -- keys:#groupbox_id values:#(Control_ids)
	

	/** Classify groupboxes and controls
	 */
	function setGroupboxesAndControls =
	(
		--format "\n"; print "GroupBoxes_v.setGroupboxesAndControls()"
		--for Controls in this.Controls where this._isControls(Controls) do
			--for _Control in this.Controls.list where _Control.Params[#GROUPBOX] != undefined or _Control.type == #GROUPBOX do
		function isGroupBox _Control = _Control.type == #GROUPBOX
		
		function controlIsInGroupbox _Control = _Control.Params[#GROUPBOX] != undefined
		
		/*  */ 
		for _Control in this.Controls.list do
			/* ADD GROUPBOX */ 
			if(isGroupBox _Control)
			{
				List[groupbox_id].createTemporaryRollout(groupbox_width)

				this._addGroupbox(_Control)
			}
		--	/* ADD CONTROL TO GROUPBOX */
		--	else if(controlIsInGroupbox _Control)
		--		this._addControlToGroupbox(_Control)
		--
		--(
		--	case of
		--	(
		--		( isGroupBox _Control ):
		--			this._addControlToGroupbox(_Control)
		--		
		--		(controlIsInGroupbox _Control):
		--			this._addGroupbox(_Control)
		--	)
		--)
	),
	--
	--/** Createa temp groupbox rollout
	-- */
	--function createTempRollouts groupbox_width =
	--(
	--	--format "\n"; print "GroupBoxCreator_v.createGroupboxRollout()"
	--	--format "groupbox_width: %\n" groupbox_width
	--
	--	for groupbox_id in List.keys do
	--		 List[groupbox_id].createTemporaryRollout(groupbox_width)
	--),	
	--
	--private
	--
	--/** Set group box
	-- */
	--function _addGroupbox _GroupBox =
	--(
	--	--format ("GroupBoxes_v._addGroupbox() " + _GroupBox.caption)
	--	this._setDefaultHeight(_GroupBox)
	--
	--	this._saveGroupBox(_GroupBox)
	--),
	--
	--
	--/** ADD CONTROL TO GROUPBOX
	-- */
	--function _addControlToGroupbox &_Control =
	--(
	--	--format "\n"; format ("GroupBoxes_v._addControlToGroupbox() " + _Control.caption)
	--	/* MARK */ 
	--	--_Control.is_in_groupbox = true
	--	
	--	_GroupBox = this._getOrNewGroupBoxControl (_Control) (_Control.Params[#GROUPBOX])
	--
	--	this._addControlToGroupbox (_GroupBox.id ) (_Control)
	--	
	--	_Control --return
	--),
	--
	--/**
	-- */
	--function _getOrNewGroupBoxControl _Control groupbox_param =
	--(
	--	--format "GroupBoxes_v._createCreateCreateOrGetGroupBox()"
	--	if( (_GroupBox = this._findGroupboxInControls(groupbox_param) ) == undefined ) then
	--
	--		_GroupBox = this._createGroupboxByControl (this._createNewGroupBox(groupbox_param)) (_Control)
	--
	--	_GroupBox --return
	--),
	--
	--/** _find groupbox in controls by id or caption
	-- */
	--function _findGroupboxInControls groupbox_param =
	--(
	--	--format "GroupBoxes_v._findGroupboxInControls()"
	--
	--	local _GroupBox_found
	--
	--	for _Control in Controls.List while _GroupBox_found == undefined \
	--		where _Control.type == #groupbox \
	--		and  (_Control.caption == groupbox_param or _Control.id == groupbox_param ) \
	--	do
	--		_GroupBox_found = _Control
	--
	--	_GroupBox_found --return
	--),
	--
	--/**
	-- */
	--function _createGroupboxByControl _GroupBox _Control =
	--(
	--	--if( ( control_across = _Control.Params[#across] ) != undefined ) then
	--		--_GroupBox.Params[#across] = control_across
	--	this._setDefaultHeight(_GroupBox)
	--
	--	this._saveGroupBox(_GroupBox)
	--
	--	_GroupBox --return
	--),
	--
	--/**
	-- */
	--function _addControlToGroupbox groupbox_id _Control =
	--(
	--	--format "\n"; format "GroupBoxes_v._addControlToGroupbox()"
	--	append List[groupbox_id].Controls _Control
	--),
	--
	--/** Set groupbox id as key and empty array as value, array will store ids of controls in groupbox
	--  *
	-- */
	--function _saveGroupBox _GroupBox =
	--(
	--	--format "\n"; format "GroupBoxes_v._saveGroupBox()"
	--	this.List[ _GroupBox.id ] = GroupBox_v(_GroupBox)
	--),
	--
	--/** Craete new
	-- */
	--function _createNewGroupBox groupbox_caption =
	--(
	--	--format "\n"; format "GroupBoxes_v._createNewGroupBox()"
	--	--format "!!!!!!!!!!!!!!!!!!!!!!!! \n"
	--	
	--	 Controls.control #Groupbox groupbox_caption
	--),
	--
	--/** _save group box
	-- */
	--function _setDefaultHeight _GroupBox =
	--(
	--	if _GroupBox.Params[#height] == undefined  do -- 90px is default width of groupbox
	--		_GroupBox.Params[#height] = GROUPBOX_DEFAULT_HEIGHT
	--),

	/**
	 */
	on create do
	(
		--format "GroupBoxes_v.create()"
		--format "!!!!!!!!!!!!!!!"
	)
)