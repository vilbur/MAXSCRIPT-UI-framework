
	/* construct */
	title,
	width  = unsupplied, -- unsupplied for compatibility with CreateDialog()
	height = unsupplied,


	/* properties */
	id,
	parent_rollout_id,

	/* dependency */
	_Controls = #(),
	Events    = EventsList_v(),

	/* extended control params */
	add_locals	= #(), -- #(#variable_name1, init_value1, #variable_name2, init_value2)	// used in ControlCreator_v._addLocalVariablesToRollout 	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"
	add_text	= "",  -- string added to rollout	// used in ControlCreator_v._addFunctionsVariablesToRollout	"../../../RolloutCreator/ControlCreator/ControlCreator.ms"

	RCI, -- Maxscript native RolloutCreator  https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_5FC5036F_E2D7_46C9_9AFA_7B3550B9F254_htm

	/* inhered */
	--Layout,

	/** Create new rollout in first slot
	 */
	function Roll title id: height: =
	(
		--format "\n"; print "RolloutBody.Roll()"
		Subrollouts = if (Subrollout_slots = this.getSubrollouts()).count > 0 then Subrollout_slots[1] else this.Rollouts()

		Subrollouts.Roll title id:id height:height --return
	),

	/** Controls
	 */
	function Controls group:undefined =
	(
		--print "RolloutBody.controls()"
		local Controls = Controls_v group:group rollout_id:id

		append _Controls Controls

		Controls --return
	),

	/** Get new slot of subrollouts
	 */
	function Subrollouts slot: width: height: =
	(
		--format "\n"; print "RolloutBody.Subrollouts()"
		--format "height	= % \n" height
		--local Subrollouts = Subrollouts_v parent_rollout_id:id slot:(this._getSubrolloutsSlotName(slot)) width:(if width != unsupplied then width else this.width) height:height
		local Subrollouts = Subrollouts_v parent_rollout_id:(this.getFullId()) slot:(this._getSubrolloutsSlotName(slot)) width:(if width != unsupplied then width else this.width) height:height
		--local Subrollouts = Subrollouts_v parent_rollout_id:id slot:(this._getSubrolloutsSlotName(slot)) width:width height:height

		append _Controls Subrollouts

		Subrollouts --return
	),

	/** FRONT END ALIAS for user this.Subrollouts()
	 */
	function Rollouts slot: height: =
	(
		--print "RolloutBody.Rollouts()"
		--format "width	= % \n" width
		--format "height	= % \n" height
		this.Subrollouts slot:slot height:height --return
	),

	/** Get Subrollouts_v or RolloutBody
	  * works for nested subrollouts as well
	  *
	  * @param	name	id	id of rollout or subrollout slot
	  *
	  * @return	object Subrollouts_v|RolloutBody
	 */
	function get id =
	(
		--format "\n"; print "RolloutBody.get()"
		--format "this.id	= % \n" this.id
		--format "id	= % \n" id
		--format "this.getSubrollouts()	= % \n" (this.getSubrollouts())
		if id == this.id then
			return this --return

		else
			for _Subrollouts in this.getSubrollouts() where (found_rollout = _Subrollouts.get (id)) != undefined do
				return found_rollout

		undefined --return
	),

	/** Addlocal
	 */
	function addlocal key val =
	(
		--print "RolloutBody.addlocal()"
		append add_locals key

		append add_locals val
	),

	/** Add text
	 */
	function addText _text =
	(
		--print "RolloutBody.addText()"
		add_text += _text
	),

	/** Get full path id to rollout
	  *
	  * @return	string E.G.: dialog_rolllout.Subrollouts.rollout_a.Subrollouts.subrollout_a
	 */
	function getFullId =
	(
		if ( parent_rollout_id != undefined ) then
			parent_rollout_id +"."+ id as string --return

		else
			id as string --return
	),

	/*------------------------------------------------------------------------------
		RENAME METHODS BELOW TO PRIVATE
	--------------------------------------------------------------------------------*/


	/** Get subrollouts
	 */
	function getSubrollouts =
	(
		--format "\n"; print "RolloutBody._getSubrolouts()"
		--format "_Controls	= % \n" _Controls
		for _Control in _Controls where hasProperty _Control "slot" collect _Control --return
	),

	/** Test if Rollout has any subrollouts
	 */
	function hasSubrollouts =
	(
		--format "\n"; print "RolloutBody.hasSubrollouts()"
		--subrollouts_count = (this.getSubrollouts()).count

		(this.getSubrollouts()).count > 0
	),

	/** Get nested level of rollout
	  *
	  * 1) Split full id by "."
	  * 2) Divide by 2 to remove subrollouts slots
	  * 3) Minus 1 to remove DialogRollout level
	 */
	function getNestedLevel = -- split parent_rollout_id and slot id E.G.: ROLLOUT_Parent.children
	(
		--format "\n"; print "RolloutBody.getNestedLevel()"
		--format "this.GETFULLID()	= % \n" (this.getFullId())
		--format "parent_rollout_id	= % \n" parent_rollout_id
		--if( parent_rollout_id == undefined ) then 0 else ((filterString (this.getFullId()) ".").count - 1 ) / 2 --return
		if( parent_rollout_id == undefined ) then 0 else floor ((filterString (this.getFullId()) ".").count  / 2) - 1 --return
	),

	private


	/** Generate slot id if not defined
	  *
	  * 1st slot id "subrollouts"
	  * 2nd and others has numbered suffix E.G.: "subrollouts_2"
	  *
	  * @return	string
	 */
	function _getSubrolloutsSlotName slot_id =
	(
		--print "RolloutBody._getSubrolloutsSlotName()"
		if slot_id == undefined or slot_id == unsupplied then
			slot_id = if ((subrollouts_count = this._getSubrolloutsCount()) > 1 ) then "subrollouts_" +subrollouts_count as string else "subrollouts"

		slot_id as name --return
	),

	/** Get subrollouts count
	 */
	function _getSubrolloutsCount =
	(
		--format "\n"; print "RolloutBody._getSubrolloutsCount()"
		(for _struct in _Controls where matchPattern (classof _struct as string ) pattern:@"*Subrollouts_v*" collect _struct).count + 1 -- Add 1 because of current subrollouts are not added yet
	),

	/** Set id by title if not defined
	 */
	function _setId =
	(
		--print "RolloutBody._setId()"

		if ( id == undefined or id == unsupplied ) then
			id = toLower title

			if not matchPattern id pattern:@"rollout*" then
				id  = "ROLLOUT_" + id -- add prefix
			--id = substituteString title "Rollout" "" -- add "Rollout" prefix if does exists yet

			id = substituteString ( trimRight ( trimLeft id )) " " "_" -- replace whitespace with underscore

			id = this._repleaceCharacters "^([^A-Za-z]*)" "" -- remove any character except letters from start of string, variable MUST NOT starts with number E.G.: "1_FooDialog|_FooDialog" >>> "FooDialog"

			id = this._repleaceCharacters "[^A-Za-z0-9_]" "_" -- remove invalid characters from whole string E.G.: "Butt@n_&_1" >>> "Button_1"

			id = this._repleaceCharacters "[_]+" "_" -- remove multiple underscores E.G.: "button___1" >>> "button_1"

		this.validateid()

		id = id as name
	),

	/** Validate title
	 */
	function validateid =
	(
		--format "\n"; print "Subrollouts_v.validateTitle()"
		if matchPattern id pattern:@"rollout" or classof ( executed_id = execute (id) ) != UndefinedClass and classof ( executed_id ) != RolloutClass and classof ( executed_id ) != RolloutClass then
		(
			id_prefixed = "ROLLOUT_" + id

			--format "classof executed_id	= % \n" (classof executed_id)
			--print ("WARNING: Rollout id \"" + id + "\" is MaxScript variable, Rollout id has been changed to \"" + id_prefixed + "\"\n\n\n")
			format "\n"
			print ("WARNING: Rollout id \"" + id + "\" is classof "+(classof executed_id) as string+", Rollout id has been changed to \"" + id_prefixed + "\"")
			format "\n"
			id  = id_prefixed
		)
	),

	/** _repleace string
	 */
	function _repleaceCharacters search replace =
	(
		( dotNetObject "System.Text.RegularExpressions.Regex" search ).Replace ( id ) replace  --return
	),
