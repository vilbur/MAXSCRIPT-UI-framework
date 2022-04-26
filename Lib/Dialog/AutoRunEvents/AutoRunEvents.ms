/** Auto run macros of controls on UI start
  *
  * 1) If control has event of type #changed
  * 2) If control has value == checked
  * 3) The run Event of Control
 */
struct AutoRunEvents_v
(

		
	/** Execute macros
	 */
	function executeMacros =
	(
		--format "\n"; print "AutoRunEvents_v.executeMacros()"
		for macro in AUTORUN_EVENTS do
			execute macro
			
		AUTORUN_EVENTS = #()
	),
		
	private
	
	
	/**  
	 */
	on create do
	(
		--print("AutoRun_v.onCreate()")
		--ConstructPropeties test:this
	)
	
)


global AUTORUN_EVENTS = #()