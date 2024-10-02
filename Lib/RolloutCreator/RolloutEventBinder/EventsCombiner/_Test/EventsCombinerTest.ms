clearListener()


filein( getFilenamePath(getSourceFileName()) + "/../../../Event/Event.ms" )
filein( getFilenamePath(getSourceFileName()) + "/../EventsCombiner.ms" )


event_types = #(#moved, #resized)
EventsCombiner 	= EventsCombiner_v()


/** Get eevent list
 */
function getEeventList event_class =
(
	events	= #()

	for event_type in event_types do
		append events (Event_v type:event_type code:("(print \""+event_class as string +"\t#"+ event_type as string +"\")" ))

	events --return

)


for event_class in #(#CUSTOM, #DEFAULT, #POST) do
(
	EventsCombiner.Lists[event_class] = ( getEeventList(event_class) )

	for event_type in event_types do
	(
		Event_combined = EventsCombiner.combine event_type
		format "Event_combined	= % \n" Event_combined
	)

)
