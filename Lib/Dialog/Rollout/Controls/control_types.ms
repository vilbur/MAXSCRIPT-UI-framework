/*--------------------------------------------------------------------------------------------
	
	
	1) IMPORTANT ON INCLUDE:
	
		PUT COMMA CHARACTER "," after include path if file is included as property in struct
			E.G.: control_types = include "Library/.../Controls/control_types.ms",
	
	
	2) IMPORTANT ALLOWING NEW CONTROL:
		Edit #(event_types) in  "../../../RolloutCreator/ControlCreator/ControlEventsCreator/ControlEventsCreator.ms"
	
	
--------------------------------------------------------------------------------------------*/


#(
	#Label,
	#Button,
	#Checkbox,
	#Checkbutton,
	#Spinner,
	#Edittext,
	#Listbox,
	#multilistbox,
	#Dropdownlist,
	#GroupBox,
	--#Combobox,
	--#Angle,
	--#Bitmap,
	--#Colorpicker,
	--#hyperlink,
	--#imgTag,
	--#Mapbutton,
	--#Materialbutton,
	--#Pickbutton,
	--#ProgressBar,
	--#Slider,
	--#Curve,-- DOES NOT WORK YET
	--#popupMenu,-- DOES NOT WORK YET
	--#Radiobuttons,-- DOES NOT WORK YET
	#Timer
)