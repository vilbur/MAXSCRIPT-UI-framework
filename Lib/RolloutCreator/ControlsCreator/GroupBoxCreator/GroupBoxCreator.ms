filein( getFilenamePath(getSourceFileName()) + "/GroupBoxControlsSorter/GroupBoxControlsSorter.ms" )
filein( getFilenamePath(getSourceFileName()) + "/GroupboxResizer/GroupboxResizer.ms" )

/** Group box creator
  
  1) Controls in group box are created as last on position [0,0], it will not break across layout
  
  2 ) On rollout created call GroupBoxCreator_v._sortControlsInGroupBox()
  
 */
struct GroupBoxCreator_v
(
	/* properties */



	/* required */
	/* dependency */
	GroupboxSorter 	= GroupBoxControlsSorter_v(),
	GroupboxResizer 	= GroupboxResizer_v(),
	
	/* reference */
	/* ListBody is defining these variables
	   
		this.keys	= #() 
		this.values	= #()
	*/
	include "Library/MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"
	
	GroupBoxes, -- List of groupboxes where key is groupbox id and value is list of control ids in groupbox
	rollouts	= keys,

	/** Add grouboxes for rollout
	  *
	  * @param	#name	rollout_id_full
	  * @param	#( #("groupbox_ids"), #(#control_ids )	GroupBoxes
	  *
	 */
	function addGrouboxes rollout_id_full GroupBoxes =
	(
		--format "\n>>>>>>>>>>>><<<<<<<<<<<<\n\n"; print "GroupBoxCreator_v.addGrouboxesForRollout()"
		--format "rollout_id_full	= % \n" rollout_id_full
		--format "GroupBoxes.ids	= % \n" GroupBoxes.ids
		--format "GroupBoxes.controls	= % \n" GroupBoxes.controls
		--format "GroupBoxes.values.count > 0	= % \n" (GroupBoxes.values.count > 0)
		if GroupBoxes.controls.count == 0 then 
			return false
		
		--if( GroupBoxes.controls.count > 0 and ( GroupBoxes_exists = this.getVal (rollout_id_full) ) != undefined ) then 
		--if( (  GroupBoxes_exists = this.getVal (rollout_id_full) )!= undefined ) then 
			--GroupBoxes.controls = GroupBoxes_exists.controls + GroupBoxes.controls
		
		this.setVal (rollout_id_full) (GroupBoxes)
	),
	
	/** Sort controls in group box callback.
	  * Called when rollout is created.
	  *
	  * @param	string	rollout_id_full is used to get controls from ui
	  *
	 */
	function sortControlsToGroupBoxes rollout_id_full =
	(
		--format "\n\n\n******************\n\n\n"; print ("GroupBoxCreator_v.sortControlsToGroupBoxes()" + rollout_id_full as string )
		--format "this.rollouts	= % \n" this.rollouts
		GroupBoxes = this.getVal (rollout_id_full)

		format "GroupBoxes	= % \n" GroupBoxes
		if( GroupBoxes != undefined ) then 
			for i = GroupBoxes.keys.count to 1 by -1 do
			(
				
				groupbox = execute (rollout_id_full+"."+ GroupBoxes.keys[i] as string ) -- rollout_id.groupbox_id
				
				groupbox_controls = this._getControlsInGroupbox(execute(rollout_id_full+".controls")) (GroupBoxes.values[i])

				GroupboxSorter.sortControlsInGroupBox(groupbox)(groupbox_controls)
				
				GroupboxResizer.setGroupBoxSize (rollout_id_full) (groupbox)(GroupBoxes.keys[i])
				
			)
				--this._sortControlsInGroupBox(rollout_id_full)(GroupBoxes.keys[i])(GroupBoxes.values[i])
	),

	private

	/** Filter controls in rollout and return only controls in groupbox
	  * 
	  * @return	array of ids	
	 */
	function _getControlsInGroupbox control_ids_in_rollout controls_ids_in_groupbox =
	(
		format "\n"; print "GroupBoxCreator_v._getControlsInGroupbox()"

		for i = 1 to control_ids_in_rollout.count where findItem controls_ids_in_groupbox (this._getControlId(control_ids_in_rollout[i])) > 0 collect control_ids_in_rollout[i]
	),

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
	
	--/** _get group box position
	-- */
	--function _getControlBoxPosition control_position =
	--(
	--	--format "\n"; print "GroupBoxCreator_v._getControlBoxPosition()"
	--	control_position.x += padding.x
	--	control_position.y += _first_control_offset_y + padding.y
	--
	--	control_position -- return
	--),

	--/** _move control to groupbox
	-- */
	--function _moveControlToGroupbox _control &control_position =
	--(
	--	--format "\n"; print "GroupBoxCreator_v._moveControlToGroupbox()"
	--	_control.pos = next_control_position = control_position
	--
	--	next_control_position.y +=  try( _control.height ) catch(_control_default_height)
	--	next_control_position.y +=  margin 
	--
	--	next_control_position --return
	--),




	--/** _get bbox width
	-- */
	--function _getBboxWidth groupbox_controls =
	--(
	--	--format "\n"; print "GroupBoxCreator_v._getControlsBoundingBox()"
	--	max_width  = 0
	--
	--	for groupbox_control in groupbox_controls do
	--		max_width += if (_control_width = try( _control.width ) catch(128)) >  max_width then _control_width else 0
	--
	--	max_width  --return
	--),
	--
	--/** _get bbox height
	-- */
	--function _getBboxHeight groupbox_controls =
	--(
	--	--format "\n"; print "GroupBoxCreator_v._getBboxHeight()"
	--	max_height  = 0
	--
	--	for groupbox_control in groupbox_controls do
	--		max_height += try( _control.height ) catch(_control_default_height)
	--
	--	max_height  --return
	--),

	/**  
	 */
	on create do
	(

	)
)

global GroupBoxCreator = GroupBoxCreator_v()