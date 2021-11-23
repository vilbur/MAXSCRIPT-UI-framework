/** Event fired
 */
struct EventFired_v
(
	--ui,
	type,
	control,
	val,
	
	inSpin,
	inCancel,
	
	on create do()
)

global EventFired = EventFired_v()