filein( getFilenamePath(getSourceFileName()) + "/../List/List.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../Ini/Ini.ms" )

filein( getFilenamePath(getSourceFileName()) + "/../Dialog/Rollout/Rollout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../Dialog/Rollout/Subrollouts/Subrollouts.ms" )


filein( getFilenamePath(getSourceFileName()) + "/RolloutEvent/RolloutEvent.ms" )
filein( getFilenamePath(getSourceFileName()) + "/ControlCreator/ControlCreator.ms" )

/** RolloutCreator_v
 */
struct RolloutCreator_v
(
	ControlCreator,
	Ini	= Ini_v(),
	RolloutEvents	= RolloutEvents_v(),

	padding_bottom = 16,
	subrollouts_slot_height,

	/* store */
	width,
	
	
	
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

	/** Create dialog
	 */
	function createRollout _Rollout width: height: =
	(
		format "\n"
		print ("RolloutCreator_v.createRollout() " + _Rollout.id as string )
		
		if( width != unsupplied ) then
			this.width = width
		
		 this._testRolloutTitle(_Rollout.title) (_Rollout.id) 
			
		--format "_Rollout.title	= % \n" _Rollout.title
		ControlCreator = ControlCreator_v _Rollout:_Rollout

			
		this._setIniToEventCreators()
		
		/* EDIT start */ 
		_Rollout.rolloutCreatorBegin(this.width)
		
				/* add LOCAL VARIABLES */ 
		this._addLocalVariablesToRollout (_Rollout)

		/* add TEXT */ 
		this._addTextToRollout (_Rollout)
		
		this._setSubrolloutsHeight(_Rollout)(height)		

		/* add CONTROLS and SUBROLLOUTS */ 
		this.addControlsAndSubrolloutes (_Rollout)
		
		/* add EVENTS */ 
		RolloutEvents.bindEvents (_Rollout)
		
		
		/* EDIT end */ 
		_Rollout._RolloutCreator.end()
		--format "_Rollout._RolloutCreator	= % \n" _Rollout._RolloutCreator
	),

	/** Add controls or subrolloutes
	 */
	function addControlsAndSubrolloutes _Rollout =
	(
		--print "RolloutCreator_v.addControlsAndSubrolloutes()"
		for ControlsBox_or_Subrollouts in _Rollout._Controls do
			if( this._isControls(ControlsBox_or_Subrollouts) ) then
			
				ControlCreator.addControls(ControlsBox_or_Subrollouts)
			
			else
			
				this._createSubrollouts (_Rollout)(ControlsBox_or_Subrollouts)
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
				
				this.addSubRollouts _Subrollout
			)	
	),
	
	/** Get rolled state from ini
	 */
	function _getRolledStateFromIni subrollout_id =
	(
		--print "RolloutCreator_v._getRolledStateFromIni()"
		rolledup_state = "false"

		if( Ini.getPath() != undefined and (rolledup_state_ini = getINISetting (Ini.getPath())subrollout_id "rolledUp") != "" ) then
			rolledup_state = rolledup_state_ini

		rolledup_state --return
	),
	
	 /** _set ini to event creators
	  */
	 function _setIniToEventCreators =
	 (
		ini_path = Ini.getPath()

		RolloutEvents.ini_path	= ini_path

		ControlCreator.EventsCreator.ini_path	= ini_path

		ControlCreator.ParamsCreator.ControlValue.ini_path	= ini_path
	 ),
	 
	 /** _create subrollouts
	  */
	 function _createSubrollouts _Rollout Subrollouts =
	 (
		--print "RolloutCreator_v._createSubrollouts()"		
		this._addSubrolloutsSlots (_Rollout) (Subrollouts)
		
		for _Subrollout in Subrollouts.Rollouts do
			this.createRollout (_Subrollout)
	 ),
	 
	/** Add subrollouts slot
	 */
	function _addSubrolloutsSlots _Rollout Subrollouts =
	(
		
		/**  DIASBLE ADDING SUBROLLOUTS SLOT INTO ACROSS LAYOUT
		  */
		ControlCreator.AcrossModifier.fakeControlsOnEndofGroup(_Rollout._RolloutCreator) --fake_control_caption:"SUBROLLOUTS"

		_Rollout._RolloutCreator.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:"+subrollouts_slot_height as string )
	),


	private
	
	
	/** Test rollout title
	 */
	function _testRolloutTitle rollout_title rollout_id =
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
		--format "this._getSubrolloutsCount(_Rollout)	= % \n" (this._getSubrolloutsCount(_Rollout))
		--format "height	= % \n" height
		if( ( subrollouts_count = this._getSubrolloutsCount(_Rollout)) > 0 ) then 
			if( height != undefined and height != unsupplied ) then
				subrollouts_slot_height = (height - padding_bottom) / subrollouts_count
				
		 --subrollouts_slot_height--return
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
	)	
)