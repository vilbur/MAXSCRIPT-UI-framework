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
		/** Filter controls in rollout and return only controls in groupbox
		  * 
		  * @return	array of ids	
		 */
		function _getControlsInGroupbox control_ids_in_rollout controls_ids_in_groupbox =
		(
			--format "\n"; print "GroupBoxCreator_v._getControlsInGroupbox()"
			for i = 1 to control_ids_in_rollout.count where findItem controls_ids_in_groupbox (this._getControlId(control_ids_in_rollout[i])) > 0 collect control_ids_in_rollout[i]
		)
		/** Find next control after groupbox
		  *
		  * 	This control MUST NOT be in another groupbox
		 */
		function _getNextControlToGroupBox controls_in_rollout groupbox_id =
		(
			--format "\n"; print "GroupBoxCreator_v._getNextControlToGroupBox()"
			--format "controls_in_rollout	= % \n" controls_in_rollout
			/** _current control index
			 */
			function _currentControlIndex controls_in_rollout groupbox_id =
			(
				--format "\n"; print "GroupBoxCreator_v._currentControlIndex()"
				for i = 1 to controls_in_rollout.count where matchPattern (this._getControlId(controls_in_rollout[i]) ) pattern:groupbox_id do return i
			)
			
			/** Split control identifier and test if it is #GroupStartControl or #GroupEndControl
			 */
			function _isNotGroupbox _control =
			(
				--format "\n"; print "GroupBoxCreator_v._isNotGroupbox()"
				control_type = (filterString ( _control as string) ":")[1] as name
	
				control_type != #GroupStartControl and control_type != #GroupEndControl --return
			)
			
			/** Test if given control is in groupbox
			 */
			function _isInGroupbox next_control =
			(
				--format "\n"; print "GroupBoxCreator_v._isInGroupbox()"
				for control_ids_in_groupbox in groupboxes.values where findItem control_ids_in_groupbox (this._getControlId(next_control)) > 0 do return true
			)
			
			
			local next_control_index
		
			current_control_index = _currentControlIndex (controls_in_rollout) (groupbox_id)
			
			for i = 1 to controls_in_rollout.count
				where ( i		>= current_control_index	and -- start loop up current control
				   (CONTROL_NEXT	= controls_in_rollout[i+1])	!= undefined	and -- if next control exist
				   (NOT_IN_GROUPBOX	= _isInGroupbox (CONTROL_NEXT))	!= true	and -- if control is not in groupbox
				   (IS_NOT_GROUPBOX	= _isNotGroupbox(CONTROL_NEXT))	== true )         -- if control is not  #GroupStartControl and #GroupEndControl
				do
				   if( next_control_index == undefined ) then -- get only first occurence
					   next_control_index = i+1
		
			if( next_control_index != undefined ) then
				controls_in_rollout[next_control_index] --return 
		)
		
		GroupBoxes = this.getVal (rollout_id_full)
		
		controls_in_rollout = execute(rollout_id_full+".controls")

		--format "GroupBoxes	= % \n" GroupBoxes
		if( GroupBoxes != undefined ) then 
			for i = GroupBoxes.keys.count to 1 by -1 do
			(
				groupbox_id = GroupBoxes.keys[i]
				
				groupbox = execute (rollout_id_full+"."+ groupbox_id as string ) -- rollout_id.groupbox_id
				
				groupbox_controls	= _getControlsInGroupbox(controls_in_rollout) (GroupBoxes.values[i])
				next_control	= _getNextControlToGroupBox(controls_in_rollout)(groupbox_id)
				
				GroupboxSorter.sortControlsInGroupBox(groupbox)(groupbox_controls)
				
				GroupboxResizer.setGroupBoxSize (rollout_id_full)(groupbox)(groupbox_id)(next_control)
			)
	),

	
	private
		
	/** Find next control after groupbox
	  *
	  * 	This control MUST NOT be in another groupbox
	 */
	function _getNextControlToGroupBox controls_in_rollout groupbox_id =
	(
		--format "\n"; print "GroupBoxCreator_v._getNextControlToGroupBox()"
		--format "controls_in_rollout	= % \n" controls_in_rollout
		/** _current control index
		 */
		function _currentControlIndex controls_in_rollout groupbox_id =
		(
			--format "\n"; print "GroupBoxCreator_v._currentControlIndex()"
			for i = 1 to controls_in_rollout.count where matchPattern (this._getControlId(controls_in_rollout[i]) ) pattern:groupbox_id do return i
		)
		
		/** Split control identifier and test if it is #GroupStartControl or #GroupEndControl
		 */
		function _isNotGroupbox _control =
		(
			--format "\n"; print "GroupBoxCreator_v._isNotGroupbox()"
			control_type = (filterString ( _control as string) ":")[1] as name

			control_type != #GroupStartControl and control_type != #GroupEndControl --return
		)
		
		/** Test if given control is in groupbox
		 */
		function _isInGroupbox next_control =
		(
			--format "\n"; print "GroupBoxCreator_v._isInGroupbox()"
			for control_ids_in_groupbox in groupboxes.values where findItem control_ids_in_groupbox (this._getControlId(next_control)) > 0 do return true
		)
		
		
		local next_control_index
	
		current_control_index = _currentControlIndex (controls_in_rollout) (groupbox_id)
		
		for i = 1 to controls_in_rollout.count
			where ( i		>= current_control_index	and -- start loop up current control
			   (CONTROL_NEXT	= controls_in_rollout[i+1])	!= undefined	and -- if next control exist
			   (NOT_IN_GROUPBOX	= _isInGroupbox (CONTROL_NEXT))	!= true	and -- if control is not in groupbox
			   (IS_NOT_GROUPBOX	= _isNotGroupbox(CONTROL_NEXT))	== true )         -- if control is not  #GroupStartControl and #GroupEndControl
			do
			   if( next_control_index == undefined ) then -- get only first occurence
				   next_control_index = i+1
	
		if( next_control_index != undefined ) then
			controls_in_rollout[next_control_index] --return 
	),
	
	/** Split control identifier
	  *
	  * @param	RolloutControl _control	E.G.: ButtonControl:button_test_gb_1
	  *
	  * @return	name id of control	E.G.: #button_test_gb_1
	 */
	function _getControlId _control =
	(
		(filterString ( _control as string) ":")[2] as name --return
	),
	

	/**  
	 */
	on create do
	(

	)
)

global GroupBoxCreator = GroupBoxCreator_v()