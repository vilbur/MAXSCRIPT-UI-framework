	keys	= #(),
	values	= #(),
	
	/**  Set Value
	 */
	function setVal key val =
	(
		if (i = findItem keys key ) > 0 then
			this._replaceValue   i key val
		else
			this._appendNewValue i key val
			
		val --return 
	),
	/**  Set multiple values at once
	  *
	  * @property	Array	keys
	  * @property	Array	values
	  *
	  * @property	true	filter	undefined & unsupplied values are not added to list
	 */
	function setValues keys values filter: =
	(
		if( filter != true ) then 
			for i = 1 to keys.count do
				this.setVal keys[i] values[i]
		
		else
			for i = 1 to keys.count where ( values[i] != undefined and values[i] != unsupplied )  do
				this.setVal keys[i] values[i]
					
	),
	/**  Gt Value
	  *
	  * @return	value|undefined	
	 */
	function getVal key =
	(
		if (i = findItem keys key ) > 0 then
			values[i] --return
	),

	/** Get values
	  *
	  * @return	array values
	 */
	function getValues =
	(
		print "!!! listBody.ms FIX THIS METHOD"
		--if( this.count() > 1 ) then
			--values --return
		--else if( this.count() == 1 ) then 
			values[1] --return
	),
	
	/** Join array
	 */
	function join =
	(
		this._arrayToString values
	),
	
	/** Add array
	 */
	function addArray _array =
	(
		this.setVal _array[1] _array[2]
	),
	
	/**  Delete Value
	 */
	function delete key =
	(
		if (i = findItem keys key ) > 0 then
			this._removeKeyAndValue i
	),

	/** Filter
	 */
	function filter pattern test:true =
	(
		for i in values.count to 1 by -1 do
		(
			
			--format "pattern	= % \n" pattern
			
			if ( pattern == undefined or  pattern == unsupplied ) then
				this._removeUndefined i pattern test

			else if( (values[i] == undefined or values[i] == unsupplied) and pattern != undefined ) then 
				this._removeKeyAndValue i
			
			else if( matchPattern values[i] pattern:pattern != test ) then 
				this._removeKeyAndValue i
		)
		
		this --return
	),
	
	/** Format keys to #name dattype
	  *
	  *
	  *
	  *
	 */
	function formatKeys =
	(
		for i = 1 to keys.count do
			keys[i] = keys[i] as name
	),
	
	/** Get Count of values
	 */
	function count =
	(
		values.count --return
	),
	
	private
	
	/** _remove undefined
	 */
	function _removeUndefined i pattern test =
	(
		if( (values[i] == pattern ) == test ) then 
			this._removeKeyAndValue i
	),

	/** _replace value
	 */
	function _replaceValue i key val =
	(
		keys[i]	= key
		values[i]	= val
	),
	
	/** _append new value
	 */
	function _appendNewValue i key val  =
	(
		append keys key
		append values val
	),
	
	/** _remove key and value
	 */
	function _removeKeyAndValue i =
	(
		--print ("List._removeKeyAndValue " + i as string)
		deleteItem keys	i
		deleteItem values	i
	),
	
	/** Workoraund for "as string"
	  * "as string" works only for array with max 20 items
	  * https://help.autodesk.com/view/3DSMAX/2015/ENU/?guid=__files_GUID_92B98D11_60FF_4742_A1BA_692EE135E085_htm
	  *
	  * @return	string	
	  */
	function _arrayToString arr =
	(
		if( arr.count > 20 ) then
		(
			items_string = ""
			
			for item in arr do items_string += "\"" + item + "\","
			
			"#("+( trimRight items_string ",")+")" --return
		)
		else
			arr as string --return
	),
	
	