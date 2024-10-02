filein( getFilenamePath(getSourceFileName()) + "/../List/List.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../Dialog/Rollout/Rollout.ms" ) 	-- "./../Dialog/Rollout/Rollout.ms"
filein( getFilenamePath(getSourceFileName()) + "/../Dialog/Rollout/Subrollouts/Subrollouts.ms" )	-- "./../Dialog/Rollout/Subrollouts/Subrollouts.ms"

filein( getFilenamePath(getSourceFileName()) + "/RolloutEventBinder/DefaultEvents/findResizeEventType.ms" )	-- "./RolloutEventBinder/DefaultEvents/findResizeEventType.ms"

filein( getFilenamePath(getSourceFileName()) + "/RolloutEventBinder/RolloutEventBinder.ms" )	-- "./RolloutEventBinder/RolloutEventBinder.ms"

filein( getFilenamePath(getSourceFileName()) + "/ControlsCreator/ControlsCreator.ms" )	-- "./ControlsCreator/ControlsCreator.ms"

filein( getFilenamePath(getSourceFileName()) + "/SubolloutsCreator/SubolloutsCreator.ms" ) -- "./SubolloutsCreator/SubolloutsCreator.ms"


/** RolloutCreator_v
  *
  --* RolloutCreator: https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

 */
struct RolloutCreator_v
(
	/* construct option */
	Ini,

	/* properties */
	closed_rollout_bar_height = 24,

	DEBUG = false,
	--DEBUG = true,

	/* dependency */
	RolloutEventBinder	= RolloutEventBinder_v ini_path:(Ini.getPath()),

	ControlsCreator,
	SubolloutsCreator = SubolloutsCreator_v ini_path:(Ini.getPath()),

	/* store */
	subrollouts_heights	= Dictionary(),

	/** Create dialog
	  *
	  * @param	integer	width	for centered title
	 */
	function createRollout _Rollout width: =
	(
		--format "\n\n-------------------------------------	RolloutCreator_v.createRollout() id:#%	-------------------------------------\n"  ( _Rollout.id as string );
		--format "_ROLLOUT: %\n" _Rollout.title
		--format "_ROLLOUT: %:	% \n" _Rollout.title _Rollout
		--format "WIDTH: %\n" width
		timer_create_rollout = timestamp()

		execute( "global " + _Rollout.id as string )

		/* SET SLOT IDS */
		this._setSubrolloutDefaultSlotIds(_Rollout)

		this._createSubrollouts(_Rollout)
		if this.DEBUG then format "RolloutCreator._createSubrollouts % ms\n" ((timestamp()) - timer_create_rollout)

		ControlsCreator	= ControlCreator_v _Rollout:_Rollout Ini:Ini -- MUST BE AFTER SUBROLLOUT ARE CREATED

		if _Rollout.width == unsupplied and width != unsupplied then
			_Rollout.width = width


		ControlsCreator.moveGrouboxControlsToEnd(_Rollout)

		_Rollout.RCI	= RolloutCreator (_Rollout.id) ( this._getTitleString(_Rollout) )


		/* EDIT start */
		_Rollout.RCI.begin()


		if hasProperty _Rollout #DialogHotkeys and _Rollout.DialogHotkeys.hot_keys.count > 0 then
			_Rollout.DialogHotkeys.addHotkeyTimer(_Rollout)


		/* add LOCAL VARIABLES */
		this._addLocalVariablesToRollout (_Rollout)


		/* add TEXT */
		this._addTextToRollout (_Rollout)


		/* add CONTROLS and SUBROLLOUTS SLOTS */
		this._addControlsAndSubrollouts (_Rollout)
		--if this.DEBUG then format "%._addControlsAndSubrollouts % ms\n" _Rollout.id ((timestamp()) - timer_create_rollout)


		/* add EVENTS */
		RolloutEventBinder.setRollout(_Rollout)

		RolloutEventBinder.combineEvents()

		RolloutEventBinder.mutateOpenCloseToRolledUp()

		RolloutEventBinder.addHandlers()
		/* EDIT END */
		--_Rollout.RCI.end() --return

		/* EDIT END - DEV VERSION */
		_Rollout_def =_Rollout.RCI.end() --return

		--format "_ROLLOUT_DEF:---------------------------------------------------------------------\n\n\n% \n"_Rollout.RCI

		_Rollout_def  --return
	),


	private

	/** Create subrollouts recursively from most nested to dialog level
	  *
	  * NESTED ROLLOUTS ARE CREATED AS DIALOGS OUTSIDE OF DISPLAY, TO FIND THEIR HEIGHT FOR SUBROLLOUT SLOT
	  *
	  * Rollouts
	  *
	  *
	  *	  STRUCTURE OF DIALOG:
	  *
	  *		Dialog	Level 0 - MainRollout
	  *		  Rollout	Level 1 - Rollouts in dialog
	  *		    Subrollout	Level 2
	  *		      NestedSubrollout	Level 3
	  *		        NestedSubrollout...	Level 4
	  *
	  *
	 */
	function _createSubrollouts _RolloutParent =
	(
		--format "\n"; print "RolloutCreator_v.createSubrollouts()"
		--format "_ROLLOUTPARENT:	% \n" _RolloutParent.title
		--format "_ROLLOUTPARENT:	% \n" _RolloutParent
		--format "MAX_HEIGHT_OF_SUBROLLOUT:	% \n" max_height_of_subrollout


		for Subrollouts in _RolloutParent.getSubrollouts() do -- loop slots where height is not defined by user
		(
			subrollouts_heights[ Subrollouts.slot ]  = 0

			--local max_height_of_subrollout = 0

			for _RolloutSub in Subrollouts.Rollouts do
			(
				--format "Subrollouts.slot:	% \n" ( Subrollouts.slot )
				--format "Subrollouts.slot:	% \n" ( classOf Subrollouts.slot )
				--format "subrollouts_heights:	% \n" subrollouts_heights
--
				/* SET FULL ID TO SUBROLLOUT */
				_RolloutSub.parent_rollout_id = Subrollouts.getSlotId()


				this.createRollout (_RolloutSub) --width:_RolloutSub.width height:_RolloutSub.height-- CREATE PARENT ROLLOUTS

				/* DONT CREATE ROLOUTS WITH DEFINED HEIGHT */
				if Subrollouts.height == unsupplied then
				(
					CreateDialog ( _RolloutSub.RCI.def ) width:_RolloutParent.width height:_RolloutSub.height pos:[0,-8000] -- create subroullouts away from display

					/* BELOW IS DEV VERSION OF LINE ABOVE

					  FOR FLOATEBLE SUBROLLOUTS diable adding in SubolloutsCreator.addSubRollouts()

					*/
					--execute ("try(destroyDialog "+_RolloutSub.id as string+ " )catch()") --DEV DESTROY SUBROLLOUT DIALOG
					--CreateDialog ( _RolloutSub.RCI.def ) width:_RolloutParent.width height:_RolloutSub.height -- DEV - creat
				)

				this._storeSubrolloutHeight(_RolloutSub)( Subrollouts.slot)
			)
			this._setSlotHeight(Subrollouts)
		)

		--this.max_height_of_subrollout = 0 -- reset value for next subrollouts

	),

	/** Store height of highest subrollout for auto sized dialog
	  *
	  * Height of slot fit all subrollouts closed and biggest rollout open
	  *
	  * This is only if slot height is not defined by user
	  */
	function _storeSubrolloutHeight _Rollout slot =
	(
		--format "\n"; print "RolloutCreator_v.storeSubrolloutHeight()"
		--format "_Rollout:	% \n" _Rollout.id
		--format "_Rollout.RCI:	% \n" _Rollout.RCI

		rollout_height = if _Rollout.height == unsupplied then _Rollout.RCI.def.height else _Rollout.height

		if rollout_height > subrollouts_heights[ slot ] then
			subrollouts_heights[ slot ] = rollout_height
	),

	/** Set slot height
	  *
	  */
	function _setSlotHeight Subrollouts =
	(
		--format "\n"; print "RolloutCreator_v._setSlotHeight()"
		if Subrollouts.height == unsupplied then
			Subrollouts.height = subrollouts_heights[  Subrollouts.slot ] + (  Subrollouts.Rollouts.count  * this.closed_rollout_bar_height ) -- Slot height = Biggest subrollout OPEN and other subrollouts CLOSED
	),

	/** SET SUBROLLOUT SLOT DEFAULT IDS if not set by user
	 *
	 *  Slot id is "Subrollouts" if only 1 slot exist
	 *  Slot id is "Subrollouts_{number of slot}" if more then 1 slot exist
	 */
	function _setSubrolloutDefaultSlotIds _Rollout =
	(
		--format "\n"; print "RolloutCreator_v._setSubrolloutDefaultSlotIds()"
		function slotIdIsUndefined slot_id = slot_id == undefined or slot_id == unsupplied

		for i = 1 to (Subrollouts_all = _Rollout.getSubrollouts()).count where slotIdIsUndefined(Subrollouts_all[i].slot) do
			Subrollouts_all[i].slot = if Subrollouts_all.count == 1 then #SUBROLLOUTS else  ("Subrollouts_" + i as string ) as name
	),

	 /** Create controls and subrollout slots
	  */
	 function _addControlsAndSubrollouts _Rollout =
	 (
		--format "\n"; print "RolloutCreator_v._createSubrollouts()"

		for Controls_or_Subrollouts in _Rollout._Controls do
			if( this._is(Controls_or_Subrollouts)("Controls") ) then
				ControlsCreator.addControls(Controls_or_Subrollouts)

			else if _Rollout.hasSubrollouts() then
				SubolloutsCreator.addSubrolloutSlot(_Rollout)(Controls_or_Subrollouts)
	 ),

	/** Add local variables from Control_v to rollout
	  *
	  * 	Control_v.rollout_locals =  #(#variable_name1, init_value1, #variable_name2, init_value2)
	 */
	function _addLocalVariablesToRollout _Rollout =
	(
		--print "ControlCreator_v._addLocalVariablesToRollout()"

		if( _Rollout.add_locals != unsupplied ) then
			for i = 1 to _Rollout.add_locals.count by 2 do
			(
				_value = if classOf _Rollout.add_locals[i+1] == string then "\""+_Rollout.add_locals[i+1] +"\"" else _Rollout.add_locals[i+1]
				--format "_value	= % \n" _value
				_Rollout.RCI.addLocal ( _Rollout.add_locals[i] as string )  init:_value
			)
	),

	/** Add functions variables to rollout
	 */
	function _addTextToRollout _Rollout =
	(
		--print "ControlCreator_v._addTextToRollout()"
		--format "_Rollout.add_text	= % \n" _Rollout.add_text
		if( _Rollout.add_text != "" ) then
			_Rollout.RCI.addText  _Rollout.add_text filter:true
	),

	/** get name of strct
	 */
	function _is _Struct pattern =
	(
		--print "RolloutCreator_v._getSubrolloutsCount()"
		matchPattern (classOf _Struct  as string ) pattern:(@"*"+pattern+"_v*" )
	),

	/** Center rollout title with empty space prefix
	  *
	  * TODO: move this method to RolloutCreator_v
	  *
	  * if rollout is wider then 320
	 */
	function _getTitleCentered _Rollout  =
	(
		--print "Rollout_v._setTitleCenter()"

		prefix	= ""
		prefix_cahracter	= " "
		rollout_padding	= 124 -- with of dialog border or subrallout arrow for open rollout -- HIGHER VALUE MOVES WHOLE TITLE TO LEFT, LOWER TO RIGHT
		px_per_character	= 5 -- width in pixels of character in title
		px_per_space	= 3 -- width in pixels of empty character: " "
		slot_padding	= 24 -- each subrollout is narrower then parent rollout

		if( _Rollout.width != unsupplied and _Rollout.width > 320 and ( IS_NOT_MAIN_ROLLOUT = _Rollout.parent_rollout_id) != undefined and (_Rollout.width != undefined and _Rollout.width != unsupplied ) and (max_version = (maxVersion())[8] )!= undefined and max_version > 2020  ) then
		(
			title_width	= _Rollout.title.count * px_per_character -- get difference in length of characters, longer title has shorter prefix and vice versa
			rollout_width	= _Rollout.width - rollout_padding - ( _Rollout.getNestedLevel() * slot_padding )
			prefix_lenght	= ((rollout_width - title_width) / 2) / px_per_space

			for i = 1 to prefix_lenght do -- too width 200px
				prefix += prefix_cahracter

			--prefix + _Rollout.title --return
			prefix + this._getTitleString(_Rollout) --return
		)
		else
			_Rollout.title
	),

	/** Get title of rollout
	  *
	  * @return string title with whitespace between each character E.G.: "ROLLOUT TITLE" >>> "R O L L O U T   T I T L E"
	 */
	function _getTitleString _Rollout =
	(
		--format "\n"; print "RolloutCreator_v._getTitleString()"

		/* modify only title of rollout, NOT title of dialog */
		if _Rollout.parent_rollout_id != undefined then
			( dotNetObject "System.Text.RegularExpressions.Regex" "(.)" ).Replace _Rollout.title "$1 "

		else
			_Rollout.title --return Dialog title as it is
	),

	/**
	 */
	on create do
	(
		--format "\n"; print("RolloutCreator_v.onCreate()")
	)
)