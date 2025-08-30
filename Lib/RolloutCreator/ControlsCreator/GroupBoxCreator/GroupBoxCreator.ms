--filein( getFilenamePath(getSourceFileName()) + "/GroupBoxControlsSorter/GroupBoxControlsSorter.ms" )	-- "./GroupBoxControlsSorter/GroupBoxControlsSorter.ms"
--filein( getFilenamePath(getSourceFileName()) + "/GroupboxResizer/GroupboxResizer.ms" )	-- "./GroupboxResizer/GroupboxResizer.ms"
global GROUPBOXCREATOR

/** Group box creator

  1) Controls in group box are created as last on position [0,0], it will not break across layout

  2 ) On rollout created call GroupBoxCreator_v._sortControlsInGroupBox()

 */
struct GroupBoxCreator_v
(
	/* properties */
	groupbox_margin	= 16,

	control_default_height = 24,
	
	/* required */
	/* dependency */
	--GroupboxSorter 	= GroupBoxControlsSorter_v(),
	--GroupboxResizer 	= GroupboxResizer_v(),

	/* reference */
	/* ListBody is defining these variables

		this.keys	= #()
		this.values	= #()
	*/
	--include "MAXSCRIPT-UI-framework/Lib/List/ListBody.ms"

	--GroupBoxes, -- List of groupboxes where key is groupbox id and value is list of control ids in groupbox
	--rollouts	= keys,
	--
	--GroupBoxList = Dictionary #NAME,
	--
	--/** Add grouboxes for rollout
	--  *
	--  * @param	#name	rollout_id_full
	--  * @param	#( #("groupbox_ids"), #(#control_ids )	GroupBoxes
	--  *
	-- */
	--function addGrouboxes rollout_id_full GroupBoxes =
	--(
	--	--format "\n>>>>>>>>>>>><<<<<<<<<<<<\n\n"; print "GroupBoxCreator_v.addGrouboxes()"
	--	--rollout_id_full = rollout_id_full
	--	
	--	--if GroupBoxes.List.count == 0 then
	--		--return false
	--
	--	this.GroupBoxList[rollout_id_full] = GroupBoxes
	--),
	
	/** Create temp rollouts
	 */
	function createTempRollouts Controls rollout_width =
	(
		format "\n"; print "GroupBoxCreator_v.createTempRollouts()"
		
		/* FOR EACH GROUPBOX */ 
		for Groupbox in Controls.list where Groupbox.type == #GROUPBOX do
		(
			format "\n"
			format "Groupbox.id: %\n" Groupbox.id
			
			execute ("try( destroyDialog "+Groupbox.id as string +" )catch()")
			
			--format "Controls_in_groupbox: %\n" Controls_in_groupbox
			
			/* GET WIDTH OF GROUPBOX  */ 
			groupbox_width = if not Groupbox.hasParam #WIDTH then
							(
								if Groupbox.hasParam #ACROSS then 
									rollout_width / Groupbox.Params[#ACROSS]
							)
							else
								Groupbox.Params[#WIDTH]
			
			
			
			format "GROUPBOX_ACROSS: %\n" groupbox_across
			format "GROUPBOX_WIDTH: %\n" groupbox_width
			
			/* DEFINE ROLLOUT CREATOR */ 
			RCI = rolloutCreator ( Groupbox.id as string  ) ( Groupbox.id as string  )
			
			RCI.begin()
			
			--for _Control in Controls.List where _Control.type != #GROUPBOX do
				--format "_Control.Params[#GROUPBOX]: %\n" _Control.Params[#GROUPBOX]

			/* ADD CONTROLS TO ROLLOUT */ 
			for _Control in Controls.List
				where _Control.type != #GROUPBOX \	            -- is not groupbox 
				and _Control.Params[#GROUPBOX] == Groupbox.id do -- control is in this groupbox
					RCI.addControl (_Control.type) (_Control.id) (_Control.caption) paramStr:_Control.params_str filter:true;
	
			
			/* CREATE DIALOG */ 
			createDialog (RCI.end()) pos:[ (getMAXWindowPos()).x +512, 512 ] width:groupbox_width			
		)
	),

	/** Sort controls in group box callback.
	  * Called when rollout is created.
	  *
	  * @param	string	rollout_id_full is used to get controls from ui
	  *
	 */
	function sortControlsToGroupBoxes _rollout =
	(
		----format "\n\n\n******************\n\n\n"; print ("GroupBoxCreator_v.sortControlsToGroupBoxes() Rollout:" + _rollout.name as string )
		
		--format "_rollout: %\n" _rollout
		
		--getProperty GB_groupbox_a_1 #BTN_button_1 #POS [ 0 , 16 ]
		--GroupBoxes = #()
		
		GroupBoxes = for ctrl in _rollout.controls where matchPattern ( ctrl as string ) pattern:("GroupBoxControl*") collect ctrl
		
		for GroupBox in GroupBoxes do
		(

			
			max_pos = [0,0]
			
			/* GET CONTROLS INIT POS */ 			
			groupbox_controls_pos = GroupBox.pos
			
			groupbox_controls_pos.x -= groupbox_margin / 2
			groupbox_controls_pos.y += groupbox_margin
			
			--try( destroyDialog rollout_temp )catch()
			
			rollout_temp = execute ( GroupBox.name as string )
			format "ROLLOUT_TEMP: %\n" rollout_temp

			/* PLACE EACH CONTROL ON POSITION BY TEMP ROLLOUT */ 
			for ctrl_temp in rollout_temp.controls where not matchPattern ( ctrl as string ) pattern:("Group*") do
			(
				format "\n"
				ctrl = getProperty _rollout (ctrl_temp.name as name )
				format "CTRL: %\n" ctrl
				has_width = isProperty ctrl_temp #WIDTH
				
				/* GET POSITION OF CONTROL FROM TEMP ROLLOUT */ 
				temp_pos  = getProperty ctrl_temp #POS
				format "temp_pos: %\n" temp_pos
				/* GET SIZE OF CONTROL FROM TEMP ROLLOUT */ 
				temp_width  = if has_width then  getProperty ctrl_temp #WIDTH else 96
				temp_height = this._getControlSize( ctrl_temp )
				
				/*------------------------------------------------------------------------------
					MOVE CONTROL
				--------------------------------------------------------------------------------*/
				setProperty ctrl #POS ( groupbox_controls_pos + temp_pos )
				
				/*------------------------------------------------------------------------------
					RESIZE CONTROL
				--------------------------------------------------------------------------------*/
				if has_width then 
					setProperty ctrl #WIDTH ( temp_width )
				
				/* GET POSITION OF CONTROL */ 
				max_x = temp_pos.x
				max_y = temp_pos.y + temp_height
					
				/* FIX SPINNER POSITION */ 
				if classOf ctrl_temp != SpinnerControl then
					max_x += temp_width
				
				/* CAPTURE MAX POSTION OF CONTROLS */ 
				if max_x > max_pos.x then max_pos.x = max_x
				
				if max_y > max_pos.y then max_pos.y = max_y 
			)
			
			/* DESTROY TEMP ROLLOUT */ 
			--try( destroyDialog rollout_temp )catch()
			
			/*------------------------------------------------------------------------------
				RESIZE GROUPBOX
			--------------------------------------------------------------------------------*/
			new_width  = max_pos.x + groupbox_margin
			new_height = max_pos.y + groupbox_margin
			
			--if GroupBox.width < new_width then
				--GroupBox.width = new_width
			
			if GroupBox.height < new_height then
				GroupBox.height = new_height
		)

	),

	private
	
	
	
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
			--(#GroupboxControl):	control_height
			(#buttonControl):	control_default_height
			(#ListBoxControl):	_getListboxHeight(_control)
			(#MultiListBoxControl):	_getListboxHeight(_control)

			default:	control_height
		)
	),
	
	
--	/** Sort cotntrols in group box
--	 */
--	function _sortControlsInGroupBox rollout_controls groupbox_id rollout_id_full =
--	(
--		--format "\n"; print "GroupBoxCreator_v._sortCtontrolsInGroupBox()"
--
--		groupbox_dialog_controls = execute ( groupbox_id as string + ".controls" )
--		
--		control_pos = execute ( groupbox_id as string + "." + _Control.id as string + ".pos" )
--
--		--rollout_controls_ids	=  for rollout_control in rollout_controls collect (filterString ( rollout_control as string ) ":")[2] as name
--		--
--		--groupbox_controls	= for i = 1 to rollout_controls_ids.count where findItem GroupBoxes.List[groupbox_id] rollout_controls_ids[i] collect rollout_controls[i]
--		--
--		--GroupboxSorter.sortControlsInGroupBox(rollout_id_full)(execute (rollout_id_full+"."+ groupbox_id as string ))(groupbox_controls)
--		--
--		--
--		--this._resizeGroupBox (rollout_controls) (rollout_controls_ids) (groupbox_controls) (groupbox_id)
--	),
--
--	/** Resize group box
--	 */
--	function _resizeGroupBox rollout_controls rollout_controls_ids groupbox_controls groupbox_id =
--	(
--		--format "\n"; print "GroupBoxCreator_v._resizeGroupBox()"
--		local next_control_index
--
--		groupbox_index = findItem (rollout_controls_ids) (groupbox_id)
--
--		/** Split control identifier and test if it is #GroupStartControl or #GroupEndControl
--		 */
--		function _isNotGroupbox _control =
--		(
--			--format "\n"; print "GroupBoxCreator_v._isNotGroupbox()"
--			control_type = (filterString ( _control as string) ":")[1] as name
--
--			control_type != #GroupStartControl and control_type != #GroupEndControl --return
--		)
--
--		/* GET INDEX OF NEXT CONTROL */ 
--        for i = groupbox_index to rollout_controls.count
--            where (rollout_controls_ids[i+1]	!= undefined	and	-- if next control exist
--               findItem groupbox_controls rollout_controls[i+1]	== 0 and	-- if control is not in groupbox
--               (_isNotGroupbox(rollout_controls[i+1]))	== true )	-- if control is not  #GroupStartControl and #GroupEndControl
--                    do
--						if( next_control_index == undefined ) then -- get only first occurence
--							next_control_index = i+1
--
--
--		 if( next_control_index != undefined ) then -- get only first occurence
--			GroupboxResizer.setGroupBoxSizeByNextControl (rollout_id_full)(rollout_controls[groupbox_index])(rollout_controls[next_control_index])
--
--		else if groupbox_controls.count > 0 then
--			GroupboxResizer.resizeByLastControl( rollout_controls[groupbox_index] )(groupbox_controls[groupbox_controls.count])
--
--		--format "next_control_index	= % \n" next_control_index
--
--	),



	/**
	 */
	on create do
	(

	)
)

GROUPBOXCREATOR = GroupBoxCreator_v()