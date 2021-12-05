filein( getFilenamePath(getSourceFileName()) + "/EventsList/EventsList.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Controls/Controls.ms" )
filein( getFilenamePath(getSourceFileName()) + "/Subrollouts/Subrollouts.ms" )

/** Rollout
 */
struct Rollout_v
(
	/* required */
	title,
	id,
	
	/* properties */
	/* extended control params */ 
	add_locals	= #(),	-- #(#variable_name1, init_value1, #variable_name2, init_value2)	// used in ControlCreator_v._addLocalVariablesToRollout 	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"
	add_text,		-- string added to rollout	// used in ControlCreator_v._addFunctionsVariablesToRollout	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"

	is_subrollout = false,
	
	/* dependency */
	_Controls = #(),
	Events    = EventsList_v(),
	
	_RolloutCreator, -- Maxscript native RolloutCreator  https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

	
	/* inhered */ 
	Layout,

	
	/** Controls
	 */
	function Controls group:undefined =
	(
		--print "Rollout_v.controls()"
		local Controls = Controls_v group:group
		
		append _Controls Controls
		
		Controls --return
	),
	
	/** Get Subrollouts for rollout
	 */
	function Subrollouts =
	(
		--print "Rollout_v.subrollouts()"
		local Subrollouts = Subrollouts_v slot:(this._getSlot())
		
		append _Controls Subrollouts
		
		Subrollouts --return
	),
	
	/** Addlocal
	 */
	function addlocal ke val =
	(
		--print "Rollout_v.addlocal()"
		append add_locals key
		append add_locals val
	),
	
	/** Add text
	 */
	function addText text =
	(
		--print "Rollout_v.addText()"
		add_text += text
		
	),
	
	/** Subrollouts
	  *
	  * wrapper for user friedly coding
	 */
	function Rollouts =
	(
		this.Subrollouts() --return
	),
	
	private
	
	
	/** _get slot
	 */
	function _getSlot =
	(
		--print "Rollout_v._getSlot()"
		local subrollouts = for _struct in _Controls where matchPattern (classof _struct as string ) pattern:@"*Subrollouts_v*" collect _struct 

		("slot_"+id+"_"+(subrollouts.count+1) as string ) --return
	),
	
	/** Set id by title if not defined
	 */
	function _setId =
	(
		--print "RolloutCreator_v._setId()"
		if ( id == undefined or id == unsupplied ) then
			id = "ROLLOUT_" + (( dotNetObject "System.Text.RegularExpressions.Regex" @"[^A-Za-z0-9_]+" ).Replace ( (substituteString title " " "_") ) "")
		
		id --return
	),
	
	/**  
	 */
	on create do
	(
		this._setId()
		
		_RolloutCreator = rolloutCreator id title
		--_RolloutCreator = rolloutCreator id ("                                                     " + title)
	)
	
)
