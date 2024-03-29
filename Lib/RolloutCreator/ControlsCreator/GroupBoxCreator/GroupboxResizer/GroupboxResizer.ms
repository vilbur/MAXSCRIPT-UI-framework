/** Resize groupbox

 */
struct GroupboxResizer_v
(
	/* properties */
	groupbox_margin	= 16,

	control_default_height = 24,
	/* required */
	/* dependency */

	/* reference */

	/** Set group box width & height
	 */
	function setGroupBoxSizeByNextControl rollout_id groupbox next_control =
	(
		--format "\n"; print "GroupboxResizer_v._setGroupBoxSize()"
		--format "groupbox	= % \n" groupbox
		/** _is next control in same row
		 */
		function _isNextControlInSameRow next_control groupbox_pos_y =
		(
			if next_control != undefined then
				next_control_pos_y	= next_control.pos.y

			next_control != undefined and (next_control_pos_y <= groupbox_pos_y +20 and next_control_pos_y >= groupbox_pos_y - 20) -- return
		)

		local _rollout  = execute(rollout_id as string )

		is_next_control_in_same_row = _isNextControlInSameRow (next_control) ( groupbox.pos.y)

		this._setGroupboxHeight (_rollout) (groupbox) (next_control) (is_next_control_in_same_row)
	),

	/** Resize groupbox by last Control in groupbox
	*/
   function resizeByLastControl groupbox last_control =
   (
	   --format "\n"; print "GroupBoxCreator_v.resizeByLastControl()"

	   if groupbox.height == control_default_height then -- if height is not defined by user
			groupbox.height = last_control.pos.y + (this._getControlSize (last_control)) + groupbox_margin - groupbox.pos.y
   ),

	private


	/** _set groupbox width
	 */
	function _setGroupboxWidth _rollout groupbox next_control is_next_control_in_same_row =
	(
		--format "\n"; print "GroupboxResizer_v._setGroupboxWidth()"
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
		--format "\n"; print ("GroupboxResizer_v._setGroupboxHeight() " + groupbox as string )
		--format "next_control	= % \n" next_control
		--format "is_next_control_in_same_row	= % \n" is_next_control_in_same_row
		--format "groupbox.height	= % \n" groupbox.height
		--format "GROUPBOX_DEFAULT_HEIGHT	= % \n" GROUPBOX_DEFAULT_HEIGHT

		if HEIGHT_IS_DEFAULT = (groupbox.height == GROUPBOX_DEFAULT_HEIGHT) do
		(
			is_next_fake_control = next_control != undefined and matchPattern next_control.name pattern:"LABEL_fake*"

			if is_next_control_in_same_row and is_next_fake_control == false then(
				--print "next is control in same row"
				groupbox.height	=  (this._getControlSize (next_control))

			)else if next_control != undefined and is_next_fake_control == false then( -- if next control is on next row
				--print "next control is on next row"
				groupbox.height = next_control.pos.y - groupbox.pos.y - groupbox_margin
			)

			if  next_control == undefined or is_next_fake_control then (-- if control is last
				--print "control is last"
				groupbox.height = _rollout.height - groupbox.pos.y - groupbox_margin
			)
		)
	),

	/** Get control size
	 */
	function _getControlSize _control =
	(
		/** Split control identifier
		  *
		  * @param	RolloutControl _control	E.G.: ButtonControl:button_test_gb_1
		  * @return	name id of control	E.G.: #ButtonControl
		 */
		function _controlType _control =
		(
			(filterString ( _control as string) ":")[1] as name --return
		)

		/** Get true height of listbox
		  * listbox  without caption is shifted up
		 */
		function _getListboxHeight _control =
		(
			if _control.caption == "" then _control.height else _control.height + 16
		)

		if( (control_height = try( _control.height ) catch()) == undefined ) then
			control_height = control_default_height

		case _controlType(_control) of
		(
			(#GroupboxControl):	control_height
			(#buttonControl):	control_default_height
			(#ListBoxControl):	_getListboxHeight(_control)
			(#MultiListBoxControl):	_getListboxHeight(_control)

			default:	control_height +  groupbox_margin
		)
	),

	/**
	 */
	on create do
	(

	)
)