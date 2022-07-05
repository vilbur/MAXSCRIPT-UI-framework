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
	name,
	category,
	buttontext,

	tooltip = "",
	icon    = "",
	params = #( #(), #() ), -- 2D matrix #( #(keys), #(values) )

	public

	--/** Get id of control
	--  *
	--  * Id is generated from button text because of one control can consist of multiple macroscripts E.G.: Left\Righclick
	--  *
	--  * @return	#name e.g.: #BUTTON_buttontext
	-- */
	--function getControlId =
	--(
	--	(this._prefixByType()) + "_"+ (( dotNetObject "System.Text.RegularExpressions.Regex" @"[^A-Za-z0-9-_]" ).Replace ( toLower buttontext ) "_") as name --return
	--),

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
	function getType =
	(
		--print "MacroScript_Content_v.getParamsArray()"
		if( (control_type = this.getParam(#type)) != undefined ) then
			(control_type as name )--return
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

		for i = 1 to params[1].count do 
		(
			append params_array params[1][i]
			append params_array params[2][i]
		)

		params_array --return
	),

	/** Get param
	  *
	  * @property	string|name param E.G.: "width|#width
	 */
	function getParam param =
	(
		--print "MacroScript_Content_v.getParam()"
		if (index = findItem params[1] param ) > 0 then 
			params[2][index] --return
	),

	/**  
	 */
	on create do
	(
	)
)