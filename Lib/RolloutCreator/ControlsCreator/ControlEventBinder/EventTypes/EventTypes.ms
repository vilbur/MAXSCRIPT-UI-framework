/** Event types
 */
struct EventTypes_v
(
	/* If event is array then it has "val" param
	*
	* Other items in array defines additional params for event.
	*/ 
	event_types = #(
		#( ),				-- #label	
		#( #pressed,	#rightclick ),			-- #button	
		#( #(#changed,  "val"),	#rightclick ),			-- #checkbox	https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_D23A42EA_7B69_4DEF_9D6E_C6C85F884268_htm
		#( #(#changed,  "val"),	#rightclick ),			-- #checkbutton	
		#( #(#changed,  "val inSpin"),	#(#entered, "inSpin inCancel"),	#(#buttonup, "inCancel"),	#buttondown ),	-- #spinner	
		#( #(#changed,  "val"),	#(#entered, "val") ),			-- #edittext	https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_FC73C160_735C_4F65_A71D_722D63BBB591_htm
		#( #(#selected, "val"),	#(#doubleClicked, "val"),	#(#rightClick, "val")),		-- #listbox	https://help.autodesk.com/view/3DSMAX/2017/ENU/?guid=__files_GUID_7C37748B_C682_4834_B5A6_74185C8C661A_htm
		#( #(#selected, "val"),	#(#doubleClicked, "val"),	#rightClick,	#selectionEnd ),	-- #multilistbox	
		#( #(#selected, "val"),	#rightClick ),			-- #dropdownlist	
		#( ),				-- #GroupBox

		/* Custom compounded controls */
		#( #tick )
		--#( #(#changed,  "val"),	#(#entered, "val") )	-- #browsePath
	),
	
	
	private
	
	/**  
	 */
	on create do
	(
		--print("EventTypes_v.onCreate()")
	)
)