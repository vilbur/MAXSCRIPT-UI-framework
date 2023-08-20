clearListener()

filein( getFilenamePath(getSourceFileName()) + "/../EventTypes.ms" )


EventTypes 	= EventTypes_v()


button_events = EventTypes.getEventTypesOfControl (#button)
button_params = EventTypes.getParamsOfEvents (#button)

format "button_events	= % \n" button_events
format "button_params	= % \n" button_params


multilistbox_events = EventTypes.getEventTypesOfControl (#multilistbox)
multilistbox_params = EventTypes.getParamsOfEvents (#multilistbox)

format "multilistbox_events	= % \n" multilistbox_events
format "multilistbox_params	= % \n" multilistbox_params
