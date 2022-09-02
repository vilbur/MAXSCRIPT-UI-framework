/** Resize groupbox
  

 */
struct GroupboxResizer_v
(
	/* properties */


	/* required */
	/* dependency */
	
	/* reference */

	/** Set group box width & height
	 */
	function setGroupBoxSize rollout_id groupbox groupbox_id next_control =
	(
		format "\n"; print "GroupBoxCreator_v._setGroupBoxSize()"
		local _rollout  = execute(rollout_id as string )
		
		--format "NEXT_CONTROL	= % \n" next_control
		is_next_control_in_same_row = this._isNextControlInSameRow (next_control) ( groupbox.pos.y)
		--this._setGroupboxWidth  (_rollout) (groupbox) (next_control) (is_next_control_in_same_row)
		this._setGroupboxHeight (_rollout) (groupbox) (next_control) (is_next_control_in_same_row)
	),
	
	
	private

	/** Split control identifier
	  *
	  * @param	RolloutControl _control	E.G.: ButtonControl:button_test_gb_1
	  *
	  * @return	name id of control	E.G.: #button_test_gb_1
	 */
	function _getControlId _control =
	(
		format "\n"; print "GroupBoxCreator_v._getControlId()"
		control_id = (filterString ( _control as string) ":")[2]

		( toLower control_id) as name --return
	),

	/** _is next control in same row
	 */
	function _isNextControlInSameRow next_control groupbox_pos_y =
	(
		--format "\n"; print "GroupBoxCreator_v._isNextControlInSameRow()"
		--format "next_control	= % \n" next_control
		--format "groupbox_pos_y	= % \n" groupbox_pos_y
		if next_control != undefined then
			next_control_pos_y	= next_control.pos.y
		
		next_control != undefined and (next_control_pos_y <= groupbox_pos_y +20 and next_control_pos_y >= groupbox_pos_y - 20) -- return 
	),

	/** _set groupbox width
	 */
	function _setGroupboxWidth _rollout groupbox next_control is_next_control_in_same_row =
	(
		--format "\n"; print "GroupBoxCreator_v._setGroupboxWidth()"
		--format "is_next_control_in_same_row	= % \n" is_next_control_in_same_row

		if (width_is_default = groupbox.width) == 90 do -- 90px is default width of groupbox

			if is_next_control_in_same_row then

				groupbox.width	= next_control.pos.x - groupbox.pos.x -- set width up to next control in row
		
			else
				groupbox.width = _rollout.width - groupbox.pos.x  -- set width up to rollout border
		
		
		groupbox.width -= groupbox_margin
	),
	
	/** _set groupbox height
	 */
	function _setGroupboxHeight _rollout groupbox next_control is_next_control_in_same_row =
	(
		format "\n"; print ("GroupBoxCreator_v._setGroupboxHeight() " + groupbox as string )
		format "next_control	= % \n" next_control
		format "is_next_control_in_same_row	= % \n" is_next_control_in_same_row
		format "groupbox.height	= % \n" groupbox.height
		format "GROUPBOX_DEFAULT_HEIGHT	= % \n" GROUPBOX_DEFAULT_HEIGHT
		
		if height_is_default = (groupbox.height == GROUPBOX_DEFAULT_HEIGHT) do -- 90px is default width of groupbox
		(
			is_next_fake_control = next_control != undefined and matchPattern next_control.name pattern:"LABEL_fake*"
			
			if is_next_control_in_same_row and is_next_fake_control == false then(
				print "next is control in same row" 
				groupbox.height	=  (this._getControlSize (next_control))
			
			)else if next_control != undefined and is_next_fake_control == false then( -- if next control is on next row
				print "next control is on next row"
				groupbox.height = next_control.pos.y - groupbox.pos.y - groupbox_margin
			)
			
			
			if  next_control == undefined or is_next_fake_control then (-- if control is last
				print "control is last"	
				groupbox.height = _rollout.height - groupbox.pos.y - groupbox_margin
			)

		)
	),
	/** Get ntrol size
	 */
	function _getControlSize _control =
	(
		--format "\n"; print "GroupBoxCreator_v._getControlSize()"
		--format "_control	= % \n" _control
	
		if( (control_height = try( _control.height ) catch()) == undefined ) then 
			control_height = _control_default_height
		
		--format "control_height	= % \n" control_height
		case this._controlType(_control) of
		(
			(#GroupboxControl):	control_height
			(#buttonControl):	_control_default_height
			(#ListBoxControl):	this. _getListboxHeight(_control)
			(#MultiListBoxControl):	this. _getListboxHeight(_control)
	
			default:	control_height +  groupbox_margin
		)
	),
	
	/** _get control id
	 */
	function _controlType _control =
	(
		--format "\n"; print "GroupBoxCreator_v._getControlId()"
		control_type = (filterString ( _control as string) ":")[1]
		--format "control_type	= #% \n" control_type
		control_type as name --return
	),
	
	/** Get true height of listbox
	  * listbox  without caption is shifted up
	 */
	function _getListboxHeight _control =
	(
		--format "\n"; print "GroupBoxCreator_v._getListboxHeight()"
		if _control.caption == "" then _control.height else _control.height + 16
	),

	/**  
	 */
	on create do
	(

	)
)

