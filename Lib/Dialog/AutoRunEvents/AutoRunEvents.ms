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

		for data_pair in AUTORUN_EVENTS do
		(
			print ("Autorun: " + data_pair.key as string )

			execute data_pair.value
		)

		AUTORUN_EVENTS = Dictionary()
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
