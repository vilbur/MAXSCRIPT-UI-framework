filein( getFilenamePath(getSourceFileName()) + "/../ConstructPropeties/ConstructPropeties.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../List/List.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../Ini/Ini.ms" )

filein( getFilenamePath(getSourceFileName()) + "/Event/Event.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../Dialog/Rollout/Rollout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../Dialog/Rollout/Subrollouts/Subrollouts.ms" )

filein( getFilenamePath(getSourceFileName()) + "/RolloutEventBinder/RolloutEventBinder.ms" )

filein( getFilenamePath(getSourceFileName()) + "/ControlsCreator/ControlsCreator.ms" )

/** RolloutCreator_v
 */
struct RolloutCreator_v
(
	__construct = #( ),

	/* construct option */ 
	ini, -- path to ini file
	
	/* construct */ 
	ControlsCreator,

	IniFile	= Ini_v _path:ini,
	EventBinder	= RolloutEventBinder_v ini_path:(IniFile.getPath()),

	padding_bottom = 16,
	subrollouts_slot_height = 64,

	/* store */
	width,

	/** Create dialog
	 */
	function createRollout _Rollout width: height: =
	(
		format "\n\n\n\n=====================================	RolloutCreator_v.%	=====================================\n"  _Rollout.id;
		--print ("RolloutCreator_v.createRollout()"  )
		ControlsCreator = ControlCreator_v _Rollout:_Rollout ini_path:(IniFile.getPath())

		this._setupCreation (_Rollout) (width) (height)

		/* EDIT start */ 
		_Rollout.rolloutCreatorBegin(this.width)

		ControlsCreator.createControlsInGroupboxLast(_Rollout)

		/* add LOCAL VARIABLES */ 
		this._addLocalVariablesToRollout (_Rollout)

		/* add TEXT */ 
		this._addTextToRollout (_Rollout)

		/* add CONTROLS and SUBROLLOUTS */ 
		this._addControlsAndSubrolloutes (_Rollout)

		/* add EVENTS */ 
		EventBinder.combineEventsAndAddHandlers(_Rollout)

		/* EDIT end */ 
		_Rollout._RolloutCreator.end()
		--format "\n\n_Rollout._RolloutCreator	= % \n" _Rollout._RolloutCreator -- DEbuG; PRINT ROLLOUT DEINITION
	),

	/** New
	 */
	function new title id: =
	(
		Rollout_v title:title id:id --return
	),

	/** Get definition
	 */
	function getDefinition _Rollout =
	(
		_Rollout._RolloutCreator.def
	),

	/** Add sub rollouts
	 */
	function addSubRollouts _Rollout =
	(
		--print "RolloutCreator_v._addSubRollouts()"
		for _Subrollouts in _Rollout._Controls where this._isSubrollouts(_Subrollouts) do
			for _Subrollout in _Subrollouts.Rollouts do
			(
				execute  ( "AddSubRollout "+_Rollout.id+"." + _Subrollouts.slot +" "+ _Subrollout.id + " rolledUp:"+(this._getRolledStateFromIni(_Subrollout.id)) )

				this.addSubRollouts (_Subrollout)
			)	
	),

	private

	/** _setup creation
	 */
	function _setupCreation _Rollout width height =
	(
		if( width != unsupplied ) then
			this.width = width

		this._validateRolloutTitle(_Rollout.title) (_Rollout.id)

		this._setSubrolloutsHeight(_Rollout)(height)

	),

	/** Add controls or subrolloutes
	 */
	function _addControlsAndSubrolloutes _Rollout =
	(
		--print "RolloutCreator_v._addControlsAndSubrolloutes()"
		--for ControlsBox_or_Subrollouts in _Rollout._Controls do
			--format "___Controls__	= % \n" ControlsBox_or_Subrollouts

		for ControlsBox_or_Subrollouts in _Rollout._Controls do
		(
			--format "CONTROLSBOX_OR_SUBROLLOUTS	= % \n" ControlsBox_or_Subrollouts
			if( this._isControls(ControlsBox_or_Subrollouts) ) then

				ControlsCreator.addControls(ControlsBox_or_Subrollouts)
			
			else
			
				this._createSubrollouts (_Rollout)(ControlsBox_or_Subrollouts)

		)

	),

	/** Get rolled state from ini
	 */
	function _getRolledStateFromIni subrollout_id =
	(
		--print "RolloutCreator_v._getRolledStateFromIni()"
		rolledup_state = "false"

		if( IniFile.getPath() != undefined and (rolledup_state_ini = getINISetting (IniFile.getPath())subrollout_id "rolledUp") != "" ) then
			rolledup_state = rolledup_state_ini

		rolledup_state --return
	),


	 /** _create subrollouts
	  */
	 function _createSubrollouts _Rollout Subrollouts =
	 (
		--print ( "RolloutCreator_v._createSubrollouts " + Subrollouts.slot as string  )

		this._addSubrolloutsSlots (_Rollout) (Subrollouts)

		for _Subrollout in Subrollouts.Rollouts do
			this.createRollout (_Subrollout)
	 ),

	/** Add subrollouts slot
	 */
	function _addSubrolloutsSlots _Rollout Subrollouts =
	(
		--print ("RolloutCreator_v._addSubrolloutsSlots() " + Subrollouts.slot as string )
		/**  DIASBLE ADDING SUBROLLOUTS SLOT INTO ACROSS LAYOUT
		  */
		ControlsCreator.AcrossModifier.fakeControlsOnEndofGroup(_Rollout._RolloutCreator) --fake_control_caption:"SUBROLLOUTS"

		_Rollout._RolloutCreator.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:"+subrollouts_slot_height as string )
	),

	private

	/** Validate that title of rollout is not maxscript keyword or E.G.: "Rollout|Group|Locals|..."
	 */
	function _validateRolloutTitle rollout_title rollout_id =
	(
		--print "RolloutCreator_v._testRolloutTitle()"
		if( rollout_title_is_defined = execute ("((class_of_title = classOf "+rollout_id+") != UndefinedClass and class_of_title != RolloutClass) ")  ) then
			throw ("\n\nERROR INVALID ROLLOUT TITLE\n\nRollout.title == \""+rollout_title+"\"")	
	),

	/** _set subrollouts height
	 */
	function _setSubrolloutsHeight _Rollout height =
	(
		--print "RolloutCreator_v._setSubrolloutsHeight()"
		--print "DEDUG HEIGHT OF SUBROLLOUTS"

		if( ( subrollouts_count = this._getSubrolloutsCount(_Rollout)) > 0 ) then 
			if( height != undefined and height != unsupplied ) then
				subrollouts_slot_height = (height - padding_bottom) / subrollouts_count
				--subrollouts_slot_height = ((height - padding_bottom) / subrollouts_count) - 512
				--subrollouts_slot_height = 256
	),

	/** Add local variables from Control_v to rollout
	  *
	  * 	Control_v.rollout_locals =  #(#variable_name1, init_value1, #variable_name2, init_value2)
	 */
	function _addLocalVariablesToRollout _Rollout =
	(
		--print "ControlCreator_v._addLocalVariablesToRollout()"
		--format "_Rollout.add_locals	= % \n" _Rollout.add_locals
		if( _Rollout.add_locals != unsupplied ) then
			for i = 1 to _Rollout.add_locals.count by 2 do
				_Rollout._RolloutCreator.addLocal ( _Rollout.add_locals[i] as string )  init:_Rollout.add_locals[i+1]
	),

	/** Add functions variables to rollout
	 */
	function _addTextToRollout _Rollout =
	(
		--print "ControlCreator_v._addTextToRollout()"
		--format "_Rollout.add_text	= % \n" _Rollout.add_text
		if( _Rollout.add_text != undefined ) then
				_Rollout._RolloutCreator.addText  _Rollout.add_text filter:true
	),

	/** _get subrollouts count
	 */
	function _getSubrolloutsCount _Rollout =
	(
		--print "RolloutCreator_v._getSubrolloutsCount()"
		(for _Subrollouts in _Rollout._Controls where this._isSubrollouts(_Subrollouts) collect _Subrollouts).count --return
	),

	/** _is control box
	 */
	function _isControls _Struct =
	(
		this._getType _Struct == "controls"
	),

	/** _is subrollouts
	 */
	function _isSubrollouts _Struct =
	(
		--print "RolloutCreator_v._getSubrolloutsCount()"
		this._getType _Struct == "subrollouts"
	),

	/** Get name given struct
	  * @property	struct	_Struct
	  *
	  * @return	string lower case	name of given struc stripped of "_v" suffix E.G.: "FooStruct_v" returm "foostruct"
	 */
	function _getType _Struct =
	(
		toLower (( filterString( classof _Struct as string ) "_*(:" )[2])  --return
	),

	/**  
	 */
	on create do
	(
		--print("RolloutCreator_v.onCreate()")
		ConstructPropeties test:this
	)	
)