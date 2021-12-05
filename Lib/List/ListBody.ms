	keys	= #(),
	values	= #(),
	
	/**  Set Value
	  *
	  * UNIQUE rules:
	  *
	  *		1) ADD new if NOT exist 
	  *		2) REPLACE if exist	- unique	== unsupplied
	  *		3) ADD new if exist	- unique 	== false
	  *		4) NOT add if exist	- unique 	== true
	  *
	  *
	  * @param	mixin	key	key of value
	  * @param	mixin	value
	  * @param	boolean|void	unique	Explained above in UNIQUE rules
	  *
	 */
	function setVal key val unique: =
	(
		i	= findItem keys key
		exist	= i > 0
		--format "exist	= % \n" exist
		if ( exist == false or (exist and unique == false) ) then 
			this._appendNewValue key val
	
		else if( exist and unique == unsupplied ) then 
			this._replaceValue   i key val

		val --return 
	),
	/**  Set multiple values at once
	  *
	  * @param	Array	keys
	  * @param	Array	values
	  *
	  * @param	true	filter	undefined & unsupplied values are not added to list
	 */
	function setValues keys values filter:false =
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
	  *
	  * @param	string	pair_delimeter	delimeter of key and value pair	E.G.: pair_delimeter	= ":" >>> "key1:value1"
	  * @param	string	delimeter	delimeter of pairs 	E.G.: delemiter	= "|" >>> "key1:value1|key2:value2"
	  *
	  * @return	string	
	 */
	function join pair_delimeter delimeter:" "  =
	(
		--print ".join()"
		_string = ""
		
		for i=1 to keys.count do
			_string += keys[i] as string +pair_delimeter+ values[i] as string + delimeter

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
	
	/** Merge Lsits
	  *
	  * UNIQUE rules:
	  *
	  *		1) unique 	== true	>>> Keep unique, values are not overrided
	  *		2) unique 	== false	>>> Add all values, simply merge Lists
	  *		3) unique	== unsupplied	>>> Keep unique, BUT OVERRIDE first List by List_to_merge
	  *
	  * @param	List_v	List_to_merge	
	  * @param	boolean	unique	Explained above in UNIQUE rules
	  *
	  * @return	this	
	 */
	function merge List_to_merge unique:true =
	(
		if( List_to_merge != undefined ) then
			for i = 1 to List_to_merge.keys.count do
				this.setVal (List_to_merge.keys[i]) (List_to_merge.values[i]) unique:unique
		
		else
			print "ListBody.ms.merge(List_to_merge==undefined)"
		
		this --return 
	),
	
	/** Make list Unique - first occurrence is king
	 */
	function unique =
	(
		looped_keys	= #()
		duplicated	= #()
		 
	
		for i = 1 to keys.count do
			if( (found = findItem looped_keys keys[i] ) == 0 ) then 
				append looped_keys keys[i]
			else
				append duplicated i
		
	
		for i in duplicated.count to 1 by -1 do
			this._removeKeyAndValue duplicated[i]
		--print ".unique()"
	),
	
	
	/** Copy
	 */
	function copy =
	(
		List_copy        = List_v()
		List_copy.keys   = deepCopy keys
		List_copy.values = deepCopy values
				
		List_copy --return
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
		keys.count --return
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
	function _appendNewValue key val  =
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
	

	
	