/** Subrollouts
 */
struct Subrollouts_v
(
	--__construct = #(  ),
	
	/* required */
	/* dependency */
	/* reference */
	/* properties */
	slot,
	
	/** Create new rollout
	 */
	function new title  =
	(
		--print "Subrollouts_v.test()"
		Rollout_v title:title --return
	),
	
	private
	
	/** Get\set value of property 
	 * @param	string|name key	Name  of property E.G.: "foo_key" OR #foo_key 
	 * @param	string|#get value	Value of property
	 *
	 * @return	string|self Value or self
	 *
	 * @example this._getSetProp "foo" "bar" -- SET "bar" to property "foo"
	 * @example this._getSetProp #foo  #get  -- GET value of property "foo"
	 */
	function _getSetProp key value =
	(
		if( value != #get ) then
		(
			if( value != undefined ) then
				setProperty  this ( key as string ) value
			this --return
		) else
			getProperty this ( key as string ) --return
	),
	
	/** Check if required properties are defined when an instance of the struct is created.
	 *	
	 * @example __construct = #( #property_name ) 
	 */
	function _checkConstctructProperties =
	(
		for prop in __construct where getProperty this prop == undefined do
			messageBox ("Subrollouts\nUndefined construct property !\n\n"+ ((filterString( classof this as string )"(:")[2]) +"."+ prop )
	),
	/**  
	 */
	on create do
	(
		print("Subrollouts_v.onCreate()")
		--this._checkConstctructProperties()
	)
	
)
