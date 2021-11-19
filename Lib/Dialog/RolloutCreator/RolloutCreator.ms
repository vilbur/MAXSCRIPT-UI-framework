--filein( getFilenamePath(getSourceFileName()) + "/Controls/Controls.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/Controls/ControlsBox/ControlsBox.ms" )
--filein( getFilenamePath(getSourceFileName()) + "/RolloutEvent/RolloutEvent.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Rollout/Rollout.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Rollout/Subrollouts/Subrollouts.ms" )

/** RolloutCreator_v
 */
struct RolloutCreator_v
(
	/* required */
	
	/* dependency */
	--_RolloutCreator, -- https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

	_Rollouts = #(),

	/** New
	 */
	function new title id: =
	(
		_Rollout = Rollout_v title:title id:id --return
		
		--_RolloutCreator = rolloutCreator ( title as string ) title
		append _Rollouts _Rollout
		--_RolloutCreator.begin()
		_Rollout --return
	),
	
	/** Get definition
	 */
	function getDefinition _Rollout =
	(
		_Rollout._RolloutCreator.def
	),

	/** Create rollouts
	 */
	function createRollouts =
	(
		for _Rollout in _Rollouts do
			this.createRollout _Rollout
	),

	/** Create dialog
	 */
	function createRollout _Rollout =
	(
		--_RolloutCreator = rolloutCreator (_Rollout.id) (_Rollout.title)
		
		_Rollout._RolloutCreator.begin()
		
		
		for ControlsBox_or_Subrollouts in _Rollout._Controls do
			--format "ControlsBox_or_Subrollouts	= % \n" ControlsBox_or_Subrollouts
			this.addControlsOrSubrolloutes (_Rollout) (ControlsBox_or_Subrollouts)
		--this.addControls (_Rollout)
		
		--this.addSubrolloutsSlots (_Rollout)
		
		_Rollout._RolloutCreator.end()
	),

	/** Add controls or subrolloutes
	 */
	function addControlsOrSubrolloutes _Rollout ControlsBox_or_Subrollouts =
	(
		print "RolloutCreator_v.addControlsOrSubrolloutes()"
		if( this._isControlsBox(ControlsBox_or_Subrollouts) ) then
		
			this.addControls (_Rollout)(ControlsBox_or_Subrollouts)
		
		else
			this.addSubrolloutsSlots (_Rollout)(ControlsBox_or_Subrollouts)
	),
	
	
	/** Add controls
	 */
	function addControls _Rollout _Controls =
	(
		print "RolloutCreator_v.addControls()"
		--for _Controls in _Rollout._Controls do
		format "_Controls	= % \n" _Controls
		for _Control in _Controls.list do
			_Rollout._RolloutCreator.addControl _Control.type _Control.id _Control.caption
	),
	
	/** Add subrollouts slot
	 */
	function addSubrolloutsSlots _Rollout _Subrollouts =
	(
		print "RolloutCreator_v.addSubrolloutsSlot()"
		
		_Rollout._RolloutCreator.addText ("subRollout "+Subrollouts.slot as string +" \"slot_name\" height:128")
		
		for _Subrollout in _Subrollouts.Rollouts do
			--format "_Subrollout	= % \n" _Subrollout
			this.createRollout (_Subrollout)

	),

	/** Add sub rollouts
	 */
	function addSubRollouts =
	(
		for _Rollout in _Rollouts do
			for _Subrollouts in _Rollout._Controls where this._isSubrollouts(_Subrollouts) do
			(	
				for _Subrollout in _Subrollouts.Rollouts do
				(
					format "_Subrollout	= % \n" _Subrollout
					--_SubRolloutCreator = rolloutCreator (_Subrollout.id) (_Subrollout.title)
					_Subrollout._RolloutCreator.begin()
					_Subrollout._RolloutCreator.end()
					
					execute ( "\n AddSubRollout "+_Rollout.id+"." + _Subrollouts.slot as string + " "+ _Subrollout.id )
				)	
			)
	),

	
	private
	

	/** _is control box
	 */
	function _isControlsBox _Struct =
	(
		this._getType _Struct == "controls"
	),
	
	/** _is subrollouts
	 */
	function _isSubrollouts _Struct =
	(
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
	
	
	

	--
	--/** Add controls box to ui
	-- */
	--function addControlsBoxToUi ControlsBox =
	--(
	--	--print "RolloutCreator_v.addControlsBoxToUi()"
	--	_RolloutCreator.addText ("group \"" + ControlsBox.caption + "\" (") 
	--				
	--	for i = 1 to ControlsBox.controls.count do
	--			this.addControlToUI (ControlsBox.controls[i])
	--	
	--	_RolloutCreator.addText (")")
	--),
	--
	--/** Add control to UI
	-- */
	--function addControlToUI _Control =
	--(
	--	print ("RolloutCreator_v.addControlToUI() " + _Control.id)
	--	
	--	/** Test
	--	 */
	--	(function addHandlers _Control =
	--	(
	--		print "RolloutCreator_v.addHandlers()"
	--		
	--		for _Event in _Control.Events.list do
	--			_RolloutCreator.addHandler _Control.id _Event.type codeStr:_Event.code paramStr:_Event.params filter:on 
	--	
	--	))(_Control)
	--
	--	_RolloutCreator.addControl _Control.type ( _Control.id as string ) _Control.caption paramStr:_Control.params
	--),
	--



	/** Set id by title if not defined
	 */
	function _setId =
	(
		print "RolloutCreator_v._setId()"
		if ( id == undefined or id == unsupplied ) then
			id = "ROLLOUT_" + (( dotNetObject "System.Text.RegularExpressions.Regex" @"[^A-Za-z0-9_]+" ).Replace ( (substituteString title " " "_") ) "")
		
		id --return
	),
	
	/**  
	 */
	on create do
	(
		--this._setId()
		--
		--_RolloutCreator = rolloutCreator id title
		--
		--_RolloutCreator.begin() 
	)
	
)
