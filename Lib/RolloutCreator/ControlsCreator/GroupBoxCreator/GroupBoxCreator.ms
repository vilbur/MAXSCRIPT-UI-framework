filein( getFilenamePath(getSourceFileName()) + "/GroupBoxControlsSorter/GroupBoxControlsSorter.ms" )	-- "./GroupBoxControlsSorter/GroupBoxControlsSorter.ms"
filein( getFilenamePath(getSourceFileName()) + "/GroupboxResizer/GroupboxResizer.ms" )	-- "./GroupboxResizer/GroupboxResizer.ms"
global GROUPBOXCREATOR

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
	--include "MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"

	GroupBoxes, -- List of groupboxes where key is groupbox id and value is list of control ids in groupbox
	--rollouts	= keys,

	RolloutList = Dictionary  #string,

	/** Add grouboxes for rollout
	  *
	  * @param	#name	rollout_id_full
	  * @param	#( #("groupbox_ids"), #(#control_ids )	GroupBoxes
	  *
	 */
	function addGrouboxes rollout_id_full GroupBoxes =
	(
		--format "\n>>>>>>>>>>>><<<<<<<<<<<<\n\n"; print "GroupBoxCreator_v.addGrouboxes()"
		if GroupBoxes.List.count == 0 then
			return false

		this.RolloutList[rollout_id_full as string ] = GroupBoxes
	),

	/** Sort controls in group box callback.
	  * Called when rollout is created.
	  *
	  * @param	string	rollout_id_full is used to get controls from ui
	  *
	 */
	function sortControlsToGroupBoxes rollout_id_full =
	(
		--format "\n\n\n******************\n\n\n"; print ("GroupBoxCreator_v.sortControlsToGroupBoxes() Rollout:" + rollout_id_full as string )
		GroupBoxes = this.RolloutList[rollout_id_full as string ]

		if GroupBoxes != undefined then
			for i = GroupBoxes.List.count to 1 by -1 do
				this._sortControlsInGroupBox (execute(rollout_id_full+".controls"))(GroupBoxes.List.keys[i])(rollout_id_full)

	),

	private

	/** Sort cotntrols in group box
	 */
	function _sortControlsInGroupBox rollout_controls groupbox_id rollout_id_full =
	(
		--format "\n"; print "GroupBoxCreator_v._sortCtontrolsInGroupBox()"

		rollout_controls_ids	=  for rollout_control in rollout_controls collect (filterString ( rollout_control as string ) ":")[2] as name

		groupbox_controls	= for i = 1 to rollout_controls_ids.count where findItem GroupBoxes.List[groupbox_id] rollout_controls_ids[i] collect rollout_controls[i]

		GroupboxSorter.sortControlsInGroupBox(rollout_id_full)(execute (rollout_id_full+"."+ groupbox_id as string ))(groupbox_controls)


		this._resizeGroupBox (rollout_controls) (rollout_controls_ids) (groupbox_controls) (groupbox_id)
	),

	/** Resize group box
	 */
	function _resizeGroupBox rollout_controls rollout_controls_ids groupbox_controls groupbox_id =
	(
		--format "\n"; print "GroupBoxCreator_v._resizeGroupBox()"
		local next_control_index

		groupbox_index = findItem (rollout_controls_ids) (groupbox_id)

		/** Split control identifier and test if it is #GroupStartControl or #GroupEndControl
		 */
		function _isNotGroupbox _control =
		(
			--format "\n"; print "GroupBoxCreator_v._isNotGroupbox()"
			control_type = (filterString ( _control as string) ":")[1] as name

			control_type != #GroupStartControl and control_type != #GroupEndControl --return
		)

		/* GET INDEX OF NEXT CONTROL */ 
        for i = groupbox_index to rollout_controls.count
            where (rollout_controls_ids[i+1]	!= undefined	and	-- if next control exist
               findItem groupbox_controls rollout_controls[i+1]	== 0 and	-- if control is not in groupbox
               (_isNotGroupbox(rollout_controls[i+1]))	== true )	-- if control is not  #GroupStartControl and #GroupEndControl
                    do
						if( next_control_index == undefined ) then -- get only first occurence
							next_control_index = i+1


		 if( next_control_index != undefined ) then -- get only first occurence
			GroupboxResizer.setGroupBoxSizeByNextControl (rollout_id_full)(rollout_controls[groupbox_index])(rollout_controls[next_control_index])

		else if groupbox_controls.count > 0 then
			GroupboxResizer.resizeByLastControl( rollout_controls[groupbox_index] )(groupbox_controls[groupbox_controls.count])

		--format "next_control_index	= % \n" next_control_index

	),



	/**
	 */
	on create do
	(

	)
)

GROUPBOXCREATOR = GroupBoxCreator_v()