
/*  Menu definition.
    Data can be Dictionary #string or array of MenuDefinition_v.
*/
struct MenuDefinition_v
(
	type = #menu,
	title = "",
	data = undefined,
	_data = undefined,
	quad_modifier = #shiftAndControlPressed,
	quad_position = #TopRight,
	quad_context_id = "ac7c70f8-3f86-4ff5-a510-e4fd6a9c368e",

	filein( getFilenamePath(getSourceFileName()) + "/old_methods_fallback.ms" )	--"./old_methods_fallback.ms"

	
	/*  Adds macro item to menu data.
	    Value is #(category, macro_name).
	*/
	function addItem category macro_name title:"" =
	(
		this.ensureMenuData()

		item_title = title

		if item_title == "" then
		(
			item_title = macro_name
		)

		this.data[item_title] = #(category, macro_name)

		this -- return
	),


	/*  Adds submenu definition to menu data.
	    Returns new submenu definition instance.
	*/
	function addMenu title =
	(
		this.ensureMenuData()

		menu_definition = MenuDefinition_v \
			type:#menu \
			title:title

		this.data[title] = menu_definition.data

		menu_definition -- return
	),


	/*  Adds quad quadrant definition.
	    Parent data becomes array of MenuDefinition_v.
	*/
	function addQuad title position:#TopRight =
	(
		this.ensureQuadData()

		quad_definition = MenuDefinition_v \
			type:#quad \
			title:title \
			quad_modifier:this.quad_modifier \
			quad_position:position \
			quad_context_id:this.quad_context_id

		append this.data quad_definition

		quad_definition -- return
	),
	
	
	/*  Checks if value is Dictionary.
	    Used before dictionary operations.
	*/
	function isDictionaryValue value =
	(
		was_dictionary = false

		if value != undefined then
		(
			if classOf value == Dictionary then
			(
				was_dictionary = true
			)
		)

		was_dictionary -- return
	),


	/*  Checks if value is array.
	    Used for quad definitions array.
	*/
	function isArrayValue value =
	(
		was_array = false

		if value != undefined then
		(
			if classOf value == Array then
			(
				was_array = true
			)
		)

		was_array -- return
	),


	/*  Reads constructor alias _data.
	    Alias exists only to support typo-safe constructor calls.
	*/
	function readDataAlias =
	(
		if this._data != undefined then
		(
			this.data = this._data
		)

		this.data -- return
	),


	/*  Ensures data property is Dictionary #string.
	    Used for normal menu content.
	*/
	function ensureMenuData =
	(
		this.readDataAlias()

		if not this.isDictionaryValue this.data then
		(
			this.data = Dictionary #string
		)

		this.data -- return
	),


	/*  Ensures data property is array.
	    Used when definition owns multiple quad definitions.
	*/
	function ensureQuadData =
	(
		this.readDataAlias()

		if not this.isArrayValue this.data then
		(
			this.data = #()
		)

		this.data -- return
	),




	on create do
	(
		this.readDataAlias()

		if this.data == undefined then
		(
			this.data = Dictionary #string
		)
	)
)


