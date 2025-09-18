/** MacroScript_Content_v represent single macrosript in ".mcr" file
  *
  * http://docs.autodesk.com/3DSMAX/15/ENU/MAXScript-Help/index.html?url=files/GUID-6E21C768-7256-4500-AB1F-B144F492F055.htm,topicNumber=d30e636049
  *
  *
  *
  */
struct MacroScript_Content_v
(

	/* Properties of macroscript */
	macro_name,
	category,
	buttontext,

	tooltip = "",
	icon    = "",

	params	= Dictionary #NAME, -- KEY: #PARAM_NAME VALUE:"Param Value"
	
	silentErrors = false,
	autoUndoEnabled = false,

	public


	/** Get full id
	 */
	function _prefixByType =
	(
		toUpper ((this.getType()) as string )+ "_"   --return
	),

	/** Get type parse icon string and get "type:(.*)" portion of E.G.: "type:checkbox|checked:true|border:false"
	  *
	  * @return	#name type of control Default: #button
	 */
	function getControlType =
	(
		--print "MacroScript_Content_v.getControlType()"
		if( (control_type = this.params[#control]) != undefined ) then
			control_type as name --return

		else
			#button
	),

	/** Parse string of icon property
	  *
	  *
	  * @return	array	params	Params for control #( #key1, "value1", #key2, "value2" )
	 */
	function getParamsArray =
	(
		--print "MacroScript_Content_v.getParamsArray()"
		params_array = #()

		for param_data in params do
		(
			append params_array param_data.key
			append params_array param_data.value
		)

		params_array --return
	),


	/**
	 */
	on create do
	(
	)
)