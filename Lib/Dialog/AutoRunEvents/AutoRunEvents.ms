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
		format "\n"; print "AutoRunEvents_v.executeMacros()"

		for data_pair in AUTORUN_EVENTS do
		(
			--print ("Autorun: " + data_pair.key as string )
			format "data_pair:	% \n" data_pair
			--format "data_pair.value:	% \n" data_pair.value
			--try(
			--	execute data_pair.value
			--
			--)catch(
			--	format "\n——————————————— ERROR IN FILE ———————————————\n\n%\n" (getSourceFileName())
			--	format "\n————————————————— EXCEPTION —————————————————\n\n%\n" (getCurrentException())
			--	format "\n——————————————————— TRACE ———————————————————\n%\n"   (getCurrentExceptionStackTrace())
			--	format "\n——————————————————— STACK ———————————————————\n%\n"   (getCurrentExceptionCallStack())
			--)
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
