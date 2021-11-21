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
		values --return
	),
	
	/** Join
	 */
	function join key_value_delimeter delimeter:" "  =
	(
		--print ".join()"
		_string = ""
		
		for i=1 to keys.count do
			_string += keys[i] as string +key_value_delimeter+ values[i] as string + delimeter

		trimRight _string delimeter --return
	),
	
	/** Join values
	 */
	function joinValues delimeter:" " =
	(
		--print ".joinValues()"
		this._join values delimeter
	),
	
	
	/** Join array
	 */
	function _join arr delimeter =
	(
		_string = ""
		
		for i=1 to arr.count do
			_string += arr[i] + delimeter

		trimRight _string delimeter --return
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
	

	
	